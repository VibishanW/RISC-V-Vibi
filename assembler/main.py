#!/usr/bin/env python3
"""
Vibi's RV32I assembler for RISC-V CPU.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

# ISA tables

REG_ALIASES = {
    "zero": 0, "ra": 1, "sp": 2, "gp": 3, "tp": 4,
    "t0": 5, "t1": 6, "t2": 7,
    "s0": 8, "fp": 8, "s1": 9,
    "a0": 10, "a1": 11, "a2": 12, "a3": 13, "a4": 14, "a5": 15, "a6": 16, "a7": 17,
    "s2": 18, "s3": 19, "s4": 20, "s5": 21, "s6": 22, "s7": 23, "s8": 24, "s9": 25,
    "s10": 26, "s11": 27,
    "t3": 28, "t4": 29, "t5": 30, "t6": 31,
}

# R-type
R_OPS = {
    "add":  (0b0110011, 0b000, 0b0000000),
    "sub":  (0b0110011, 0b000, 0b0100000),
    "sll":  (0b0110011, 0b001, 0b0000000),
    "slt":  (0b0110011, 0b010, 0b0000000),
    "sltu": (0b0110011, 0b011, 0b0000000),
    "xor":  (0b0110011, 0b100, 0b0000000),
    "srl":  (0b0110011, 0b101, 0b0000000),
    "sra":  (0b0110011, 0b101, 0b0100000),
    "or":   (0b0110011, 0b110, 0b0000000),
    "and":  (0b0110011, 0b111, 0b0000000),
}

# I-type ALU
I_OPS = {
    "addi":  (0b0010011, 0b000),
    "slti":  (0b0010011, 0b010),
    "sltiu": (0b0010011, 0b011),
    "xori":  (0b0010011, 0b100),
    "ori":   (0b0010011, 0b110),
    "andi":  (0b0010011, 0b111),
}

# Shift immediates (special I-type)
SHIFTI_OPS = {
    "slli": (0b0010011, 0b001, 0b0000000),
    "srli": (0b0010011, 0b101, 0b0000000),
    "srai": (0b0010011, 0b101, 0b0100000),
}

# Loads
LOAD_OPS = {
    "lb":  (0b0000011, 0b000),
    "lh":  (0b0000011, 0b001),
    "lw":  (0b0000011, 0b010),
    "lbu": (0b0000011, 0b100),
    "lhu": (0b0000011, 0b101),
}

# Stores
STORE_OPS = {
    "sb": (0b0100011, 0b000),
    "sh": (0b0100011, 0b001),
    "sw": (0b0100011, 0b010),
}

# Branches
BRANCH_OPS = {
    "beq":  (0b1100011, 0b000),
    "bne":  (0b1100011, 0b001),
    "blt":  (0b1100011, 0b100),
    "bge":  (0b1100011, 0b101),
    "bltu": (0b1100011, 0b110),
    "bgeu": (0b1100011, 0b111),
}

# Upper immediates
U_OPS = {
    "lui":   0b0110111,
    "auipc": 0b0010111,
}

# Jumps
JAL_OPCODE = 0b1101111
JALR_OPCODE = 0b1100111

# System
SYSTEM_OPCODE = 0b1110011

NOP = 0x00000013


# Data model

@dataclass
class Item:
    addr: int
    kind: str          # "insn" or "word"
    text: str
    lineno: int


# Utility helpers

def strip_comment(line: str) -> str:
    # Support # and // comments
    line = re.split(r"#|//", line, maxsplit=1)[0]
    return line.strip()


def is_label_name(s: str) -> bool:
    return re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", s) is not None


def parse_reg(token: str) -> int:
    token = token.strip()
    if re.fullmatch(r"x([0-9]|[12][0-9]|3[01])", token):
        return int(token[1:])
    key = token.lower()
    if key in REG_ALIASES:
        return REG_ALIASES[key]
    raise ValueError(f"Invalid register: {token}")


def parse_int(token: str) -> int:
    token = token.strip().lower().replace("_", "")
    if token.startswith("-0x"):
        return -int(token[3:], 16)
    if token.startswith("0x"):
        return int(token, 16)
    if token.startswith("-0b"):
        return -int(token[3:], 2)
    if token.startswith("0b"):
        return int(token, 2)
    return int(token, 10)


def parse_imm(expr: str, labels: Dict[str, int], current_addr: int) -> int:
    expr = expr.strip()
    if expr in labels:
        return labels[expr]
    return parse_int(expr)


def split_operands(op_str: str) -> List[str]:
    if not op_str.strip():
        return []
    return [x.strip() for x in op_str.split(",")]


def parse_mem_operand(op: str) -> Tuple[int, int]:
    """
    Parses offset(rs1), e.g. 8(x2), -4(sp), 0(x0)
    """
    m = re.fullmatch(r"\s*([^)]+)\(([^)]+)\)\s*", op)
    if not m:
        raise ValueError(f"Invalid memory operand: {op}")
    imm = parse_int(m.group(1).strip())
    rs1 = parse_reg(m.group(2).strip())
    return imm, rs1


def check_signed(val: int, bits: int, what: str) -> None:
    lo = -(1 << (bits - 1))
    hi = (1 << (bits - 1)) - 1
    if not (lo <= val <= hi):
        raise ValueError(f"{what} out of range for {bits}-bit signed: {val}")


def check_unsigned(val: int, bits: int, what: str) -> None:
    lo = 0
    hi = (1 << bits) - 1
    if not (lo <= val <= hi):
        raise ValueError(f"{what} out of range for {bits}-bit unsigned: {val}")


# Encoders

def enc_r(opcode: int, funct3: int, funct7: int, rd: int, rs1: int, rs2: int) -> int:
    return (
        ((funct7 & 0x7F) << 25) |
        ((rs2 & 0x1F) << 20) |
        ((rs1 & 0x1F) << 15) |
        ((funct3 & 0x7) << 12) |
        ((rd & 0x1F) << 7) |
        (opcode & 0x7F)
    )


def enc_i(opcode: int, funct3: int, rd: int, rs1: int, imm: int) -> int:
    check_signed(imm, 12, "I-type immediate")
    imm12 = imm & 0xFFF
    return (
        (imm12 << 20) |
        ((rs1 & 0x1F) << 15) |
        ((funct3 & 0x7) << 12) |
        ((rd & 0x1F) << 7) |
        (opcode & 0x7F)
    )


def enc_shifti(opcode: int, funct3: int, funct7: int, rd: int, rs1: int, shamt: int) -> int:
    check_unsigned(shamt, 5, "shift amount")
    return (
        ((funct7 & 0x7F) << 25) |
        ((shamt & 0x1F) << 20) |
        ((rs1 & 0x1F) << 15) |
        ((funct3 & 0x7) << 12) |
        ((rd & 0x1F) << 7) |
        (opcode & 0x7F)
    )


def enc_s(opcode: int, funct3: int, rs1: int, rs2: int, imm: int) -> int:
    check_signed(imm, 12, "S-type immediate")
    imm12 = imm & 0xFFF
    imm11_5 = (imm12 >> 5) & 0x7F
    imm4_0 = imm12 & 0x1F
    return (
        (imm11_5 << 25) |
        ((rs2 & 0x1F) << 20) |
        ((rs1 & 0x1F) << 15) |
        ((funct3 & 0x7) << 12) |
        (imm4_0 << 7) |
        (opcode & 0x7F)
    )


def enc_b(opcode: int, funct3: int, rs1: int, rs2: int, offset: int) -> int:
    # Branch immediate is signed and bit 0 must be zero
    if offset & 0x1:
        raise ValueError(f"Branch offset must be 2-byte aligned: {offset}")
    check_signed(offset, 13, "B-type branch offset")
    imm = offset & 0x1FFF
    bit12 = (imm >> 12) & 0x1
    bit11 = (imm >> 11) & 0x1
    bits10_5 = (imm >> 5) & 0x3F
    bits4_1 = (imm >> 1) & 0xF
    return (
        (bit12 << 31) |
        (bits10_5 << 25) |
        ((rs2 & 0x1F) << 20) |
        ((rs1 & 0x1F) << 15) |
        ((funct3 & 0x7) << 12) |
        (bits4_1 << 8) |
        (bit11 << 7) |
        (opcode & 0x7F)
    )


def enc_u(opcode: int, rd: int, imm: int) -> int:
    # U-type keeps upper 20 bits, low 12 bits assumed zero in instruction encoding
    if imm & 0xFFF:
        # Accept raw values but warn by forcing truncation semantics
        pass
    upper = imm & 0xFFFFF000
    return upper | ((rd & 0x1F) << 7) | (opcode & 0x7F)


def enc_j(opcode: int, rd: int, offset: int) -> int:
    # J immediate is signed and bit 0 must be zero
    if offset & 0x1:
        raise ValueError(f"JAL offset must be 2-byte aligned: {offset}")
    check_signed(offset, 21, "J-type jump offset")
    imm = offset & 0x1FFFFF
    bit20 = (imm >> 20) & 0x1
    bits10_1 = (imm >> 1) & 0x3FF
    bit11 = (imm >> 11) & 0x1
    bits19_12 = (imm >> 12) & 0xFF
    return (
        (bit20 << 31) |
        (bits19_12 << 12) |
        (bit11 << 20) |
        (bits10_1 << 21) |
        ((rd & 0x1F) << 7) |
        (opcode & 0x7F)
    )


# Pseudo instructions

def expand_pseudo(mnemonic: str, ops: List[str]) -> Tuple[str, List[str]]:
    m = mnemonic.lower()

    if m == "nop":
        return "addi", ["x0", "x0", "0"]
    if m == "mv":
        # mv rd, rs -> addi rd, rs, 0
        if len(ops) != 2:
            raise ValueError("mv expects 2 operands")
        return "addi", [ops[0], ops[1], "0"]
    if m == "not":
        # not rd, rs -> xori rd, rs, -1
        if len(ops) != 2:
            raise ValueError("not expects 2 operands")
        return "xori", [ops[0], ops[1], "-1"]
    if m == "neg":
        # neg rd, rs -> sub rd, x0, rs
        if len(ops) != 2:
            raise ValueError("neg expects 2 operands")
        return "sub", [ops[0], "x0", ops[1]]
    if m == "j":
        # j label -> jal x0, label
        if len(ops) != 1:
            raise ValueError("j expects 1 operand")
        return "jal", ["x0", ops[0]]
    if m == "jr":
        # jr rs -> jalr x0, 0(rs)
        if len(ops) != 1:
            raise ValueError("jr expects 1 operand")
        return "jalr", ["x0", f"0({ops[0]})"]
    if m == "ret":
        return "jalr", ["x0", "0(ra)"]

    return mnemonic, ops


# Assembler passes

def first_pass(lines: List[str]) -> Tuple[List[Item], Dict[str, int]]:
    items: List[Item] = []
    labels: Dict[str, int] = {}
    pc = 0

    for lineno, raw in enumerate(lines, start=1):
        line = strip_comment(raw)
        if not line:
            continue

        # Peel off labels
        while ":" in line:
            left, right = line.split(":", 1)
            if not is_label_name(left.strip()):
                break
            label = left.strip()
            if label in labels:
                raise ValueError(f"Line {lineno}: duplicate label '{label}'")
            labels[label] = pc
            line = right.strip()
            if not line:
                break

        if not line:
            continue

        if line.startswith(".org"):
            parts = line.split(None, 1)
            if len(parts) != 2:
                raise ValueError(f"Line {lineno}: .org requires an address")
            pc = parse_int(parts[1])
            continue

        if line.startswith(".word"):
            rest = line[len(".word"):].strip()
            words = [x.strip() for x in rest.split(",") if x.strip()]
            if not words:
                raise ValueError(f"Line {lineno}: .word requires at least one value")
            for w in words:
                items.append(Item(addr=pc, kind="word", text=w, lineno=lineno))
                pc += 4
            continue

        items.append(Item(addr=pc, kind="insn", text=line, lineno=lineno))
        pc += 4

    return items, labels


def encode_item(item: Item, labels: Dict[str, int]) -> int:
    if item.kind == "word":
        val = parse_imm(item.text, labels, item.addr)
        return val & 0xFFFFFFFF

    text = item.text.strip()
    parts = text.split(None, 1)
    mnemonic = parts[0].lower()
    operands = split_operands(parts[1] if len(parts) > 1 else "")

    mnemonic, operands = expand_pseudo(mnemonic, operands)

    # R-type
    if mnemonic in R_OPS:
        if len(operands) != 3:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rd, rs1, rs2")
        rd = parse_reg(operands[0])
        rs1 = parse_reg(operands[1])
        rs2 = parse_reg(operands[2])
        opcode, funct3, funct7 = R_OPS[mnemonic]
        return enc_r(opcode, funct3, funct7, rd, rs1, rs2)

    # I-type ALU
    if mnemonic in I_OPS:
        if len(operands) != 3:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rd, rs1, imm")
        rd = parse_reg(operands[0])
        rs1 = parse_reg(operands[1])
        imm = parse_imm(operands[2], labels, item.addr)
        opcode, funct3 = I_OPS[mnemonic]
        return enc_i(opcode, funct3, rd, rs1, imm)

    # Shift immediates
    if mnemonic in SHIFTI_OPS:
        if len(operands) != 3:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rd, rs1, shamt")
        rd = parse_reg(operands[0])
        rs1 = parse_reg(operands[1])
        shamt = parse_imm(operands[2], labels, item.addr)
        opcode, funct3, funct7 = SHIFTI_OPS[mnemonic]
        return enc_shifti(opcode, funct3, funct7, rd, rs1, shamt)

    # Loads
    if mnemonic in LOAD_OPS:
        if len(operands) != 2:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rd, imm(rs1)")
        rd = parse_reg(operands[0])
        imm, rs1 = parse_mem_operand(operands[1])
        opcode, funct3 = LOAD_OPS[mnemonic]
        return enc_i(opcode, funct3, rd, rs1, imm)

    # Stores
    if mnemonic in STORE_OPS:
        if len(operands) != 2:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rs2, imm(rs1)")
        rs2 = parse_reg(operands[0])
        imm, rs1 = parse_mem_operand(operands[1])
        opcode, funct3 = STORE_OPS[mnemonic]
        return enc_s(opcode, funct3, rs1, rs2, imm)

    # Branches
    if mnemonic in BRANCH_OPS:
        if len(operands) != 3:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rs1, rs2, label/offset")
        rs1 = parse_reg(operands[0])
        rs2 = parse_reg(operands[1])
        target = parse_imm(operands[2], labels, item.addr)
        offset = target - item.addr if operands[2].strip() in labels else target
        opcode, funct3 = BRANCH_OPS[mnemonic]
        return enc_b(opcode, funct3, rs1, rs2, offset)

    # U-type
    if mnemonic in U_OPS:
        if len(operands) != 2:
            raise ValueError(f"Line {item.lineno}: {mnemonic} expects rd, imm")
        rd = parse_reg(operands[0])
        imm = parse_imm(operands[1], labels, item.addr)
        opcode = U_OPS[mnemonic]
        return enc_u(opcode, rd, imm)

    # jal
    if mnemonic == "jal":
        if len(operands) == 1:
            rd = 1  # default ra
            target_expr = operands[0]
        elif len(operands) == 2:
            rd = parse_reg(operands[0])
            target_expr = operands[1]
        else:
            raise ValueError(f"Line {item.lineno}: jal expects label or rd, label")

        target = parse_imm(target_expr, labels, item.addr)
        offset = target - item.addr if target_expr.strip() in labels else target
        return enc_j(JAL_OPCODE, rd, offset)

    # jalr
    # Supports:
    #   jalr rd, imm(rs1)
    #   jalr rd, rs1, imm
    #   jalr rs1
    if mnemonic == "jalr":
        if len(operands) == 1:
            rd = 1
            rs1 = parse_reg(operands[0])
            imm = 0
        elif len(operands) == 2:
            rd = parse_reg(operands[0])
            imm, rs1 = parse_mem_operand(operands[1])
        elif len(operands) == 3:
            rd = parse_reg(operands[0])
            rs1 = parse_reg(operands[1])
            imm = parse_imm(operands[2], labels, item.addr)
        else:
            raise ValueError(f"Line {item.lineno}: jalr expects rd, imm(rs1) or rd, rs1, imm")
        return enc_i(JALR_OPCODE, 0b000, rd, rs1, imm)

    # ecall / ebreak
    if mnemonic == "ecall":
        return 0x00000073
    if mnemonic == "ebreak":
        return 0x00100073

    raise ValueError(f"Line {item.lineno}: unsupported instruction '{mnemonic}'")


def assemble(source: str) -> List[Tuple[int, int]]:
    lines = source.splitlines()
    items, labels = first_pass(lines)

    out: List[Tuple[int, int]] = []
    for item in items:
        word = encode_item(item, labels)
        out.append((item.addr, word))
    return out


# Output helpers

def emit_hex(image: List[Tuple[int, int]]) -> str:
    """
    One 32-bit word per line, in address order.
    Assumes dense enough image for ROM-style usage.
    """
    image = sorted(image, key=lambda x: x[0])
    return "\n".join(f"{word:08X}" for _, word in image)


def emit_vhdl_rom(image: List[Tuple[int, int]], depth: int = 1024, pad_with_nop: bool = True) -> str:
    """
    Emits lines for a VHDL ROM array indexed by word address.
    """
    image = sorted(image, key=lambda x: x[0])
    words: Dict[int, int] = {}
    for addr, word in image:
        if addr % 4 != 0:
            raise ValueError(f"Address 0x{addr:08X} is not word-aligned")
        idx = addr // 4
        if idx >= depth:
            raise ValueError(f"ROM depth {depth} too small for address 0x{addr:08X}")
        words[idx] = word

    lines: List[str] = []
    for idx in sorted(words.keys()):
        lines.append(f'    {idx} => x"{words[idx]:08X}",')

    fill = 'x"00000013"' if pad_with_nop else '(others => \'0\')'
    lines.append(f"    others => {fill}")
    return "\n".join(lines)



# CLI

def main() -> None:
    parser = argparse.ArgumentParser(description="Assemble RV32I source for a custom RISC-V CPU.")
    parser.add_argument("input", help="Assembly source file")
    parser.add_argument("--format", choices=["hex", "vhdl"], default="hex", help="Output format")
    parser.add_argument("--depth", type=int, default=1024, help="ROM depth for VHDL output")
    parser.add_argument("-o", "--output", help="Output file (default: stdout)")
    args = parser.parse_args()

    with open(args.input, "r", encoding="utf-8") as f:
        src = f.read()

    image = assemble(src)

    if args.format == "hex":
        out = emit_hex(image)
    else:
        out = emit_vhdl_rom(image, depth=args.depth)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(out)
            f.write("\n")
    else:
        print(out)


if __name__ == "__main__":
    main()