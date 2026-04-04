----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 04:52:24 PM
-- Design Name: 
-- Module Name: ALU_Src - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Determines whether to use immediate value or read port 2 for ALU input.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Src is
    Port ( iRd2 : in STD_LOGIC_VECTOR(31 downto 0);
           iImmExt : in STD_LOGIC_VECTOR(31 downto 0);
           iALUSrc : in STD_LOGIC;
           oSrcB : out STD_LOGIC_VECTOR(31 downto 0)
          );
end ALU_Src;

architecture rtl of ALU_Src is

begin
oSrcB <= iImmExt when iALUSrc = '1' else iRd2;
end rtl;
