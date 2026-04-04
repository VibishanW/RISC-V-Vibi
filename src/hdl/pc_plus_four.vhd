----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2026 09:38:02 PM
-- Design Name: 
-- Module Name: pc_plus_four - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Increment PC counter by 4
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

entity pc_plus_four is
    Port ( iPC : in STD_LOGIC_VECTOR(31 downto 0);
           oPCNext : out STD_LOGIC_VECTOR(31 downto 0));
end pc_plus_four;

architecture rtl of pc_plus_four is

begin
oPCNext <= STD_LOGIC_VECTOR(unsigned(iPC) + 4);
end rtl;
