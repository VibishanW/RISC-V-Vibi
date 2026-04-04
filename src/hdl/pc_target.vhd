----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2026 09:47:43 PM
-- Design Name: 
-- Module Name: pc_target - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Target PC by incrementing by immediate value.
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

entity pc_target is
    Port ( iPC : in STD_LOGIC_VECTOR(31 downto 0);
           iImmExt : in STD_LOGIC_VECTOR(31 downto 0);
           oPCTarg : out STD_LOGIC_VECTOR(31 downto 0));
end pc_target;

architecture rtl of pc_target is

begin
oPCTarg <= STD_LOGIC_VECTOR(signed(iPC)+signed(iImmExt));

end rtl;
