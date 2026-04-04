----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 10:30:22 PM
-- Design Name: 
-- Module Name: res_out - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Select result from read data port or ALU's result port.
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

entity res_out is
    Port ( iResSrc : in STD_LOGIC_VECTOR(1 downto 0);
           iRD : in STD_LOGIC_VECTOR(31 downto 0);
           iALURes : in STD_LOGIC_VECTOR(31 downto 0);
           oResult : out STD_LOGIC_VECTOR(31 downto 0)
    );
end res_out;

architecture rtl of res_out is

begin
oResult <= iALURes when iResSrc(0) = '1' else iRD; -- remove (0) + change logic when alter to multicycle
end rtl;
