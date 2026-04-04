----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2026 07:38:52 PM
-- Design Name: 
-- Module Name: instr_memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Pulls instruction based on current address pointer.
-- ROM is LUT for input instruction set.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_memory is
  Port ( 
    iPC : in STD_LOGIC_VECTOR(31 downto 0);
    oInstr : out STD_LOGIC_VECTOR(31 downto 0)
   );
end instr_memory;

architecture Behavioral of instr_memory is
type imem is array(0 to 1023) of STD_LOGIC_VECTOR(31 downto 0);

constant ROM : imem := (
    0 => x"00000013", -- nop
    1 => x"00100093", -- addi x1, x0, 1
    2 => x"00200113", -- addi x2, x0, 2
    3 => x"002081B3", -- add  x3, x1, x2
    4 => x"0000006F", -- jal  x0, 0  (jump to self / infinite loop)
    others => x"00000013"  -- pad rest with nops
);

signal index : integer range 0 to 1024;
begin
index <= to_integer(unsigned(iPC(11 downto 2)));
oInstr <= ROM[index];
end Behavioral;
