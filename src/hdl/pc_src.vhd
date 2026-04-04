----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2026 09:59:27 PM
-- Design Name: 
-- Module Name: pc_src - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
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

entity pc_src is
    Port ( iPCIncr : in STD_LOGIC_VECTOR(31 downto 0); 
           iPCTarg : in STD_LOGIC_VECTOR(31 downto 0);
           iPCSrc  : in STD_LOGIC;
           oPCNext : out STD_LOGIC_VECTOR(31 downto 0));
end pc_src;

architecture rtl of pc_src is

begin
oPCNext <= iPCTarg when iPCSrc = '1' else iPCIncr;
end rtl;
