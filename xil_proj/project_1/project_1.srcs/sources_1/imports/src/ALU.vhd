----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 05:14:12 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( iSrcA : in STD_LOGIC_VECTOR(4 downto 0);
           iSrcB : in STD_LOGIC_VECTOR(4 downto 0);
           iALUCtrl : in STD_LOGIC_VECTOR(3 downto 0);
           iZero : in STD_LOGIC;
           oALURes : out STD_LOGIC_VECTOR(31 downto 0);
end ALU;

architecture Behavioral of ALU is

begin

--case(iALUCtrl)
--    "00" then op result = SrcA op SrcB

end Behavioral;
