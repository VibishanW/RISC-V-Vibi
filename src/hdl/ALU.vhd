----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 05:14:12 PM
-- Design Name: 
-- Module Name: ALU - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- ALU uses 2 input 32 bit values and conducts arithmetic logic operations.
-- Operations are determined via ALUCtrl flags set by the ALUDecoder.
-- Additionally zero flag is set here when result is x00000000
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( iSrcA : in STD_LOGIC_VECTOR(31 downto 0);
           iSrcB : in STD_LOGIC_VECTOR(31 downto 0);
           iALUCtrl : in STD_LOGIC_VECTOR(3 downto 0);
           oZero : out STD_LOGIC;
           oALURes : out STD_LOGIC_VECTOR(31 downto 0)
           );
end ALU;

architecture rtl of ALU is
signal wALURes : STD_LOGIC_VECTOR(31 downto 0);
begin

process(iALUCtrl, iSrcA, iSrcB)
begin
    case iALUCtrl is
        when "0000" => --add
            wALURes <= STD_LOGIC_VECTOR(unsigned(iSrcA) + unsigned(iSrcB));
        when "0001" => --sub
            wALURes <= STD_LOGIC_VECTOR(unsigned(iSrcA) - unsigned(iSrcB));
        when "0010" => --and
            wALURes <= iSrcA and iSrcB;
        when "0011" => --or
            wALURes <= iSrcA or iSrcB;
        when "0100" => --xor
            wALURes <=  iSrcA xor iSrcB;
        when "0101" => --slt (Set Less Than)
            if signed(iSrcA) < signed(iSrcB) then
                wALURes <= (31 downto 1 => '0') & '1';
            else
                wALURes <= (others => '0');
            end if;
        when "0110" => --sltu (Set Less Than Unsigned)
            if unsigned(iSrcA) < unsigned(iSrcB) then
                wALURes <= (31 downto 1 => '0') & '1';
            else
                wALURes <= (others => '0');
            end if;
        when "0111" => --sll (Shift Left Logical): Shift left fill with 0s. Max shift is 32 bits which is 4 downto 0)
            wALURes <= STD_LOGIC_VECTOR(shift_left(unsigned(iSrcA),to_integer(unsigned(iSrcB(4 downto 0)))));
        when "1000" => --srl (Shift Right Logical): Shift right fill with 0s. Max shift is 32 bits which is 4 downto 0)
            wALURes <= STD_LOGIC_VECTOR(shift_right(unsigned(iSrcA),to_integer(unsigned(iSrcB(4 downto 0)))));
        when "1001" => --sra (Shift Right Arithmethic): Preserves signed bit.
            wALURes <= STD_LOGIC_VECTOR(shift_right(signed(iSrcA),to_integer(unsigned(iSrcB(4 downto 0)))));
        when others  =>
            wALURes <= (others => '0');
    end case;
end process;

oALURes <= wALURes;
oZero <= '1' when wALURes = x"00000000" else '0';

end rtl;
