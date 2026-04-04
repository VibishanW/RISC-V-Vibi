----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2026 06:43:47 PM
-- Design Name: 
-- Module Name: pc_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Increment program counter.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_counter is
    Generic (
           gReset_PC : STD_lOGIC_VECTOR(31 downto 0) := x"00000000"
    );
    Port ( iClk : in STD_LOGIC;
           iRst : in STD_LOGIC;
           iPCNext : in STD_lOGIC_VECTOR(31 downto 0);
           oPC : out STD_lOGIC_VECTOR(31 downto 0));
end pc_counter;

architecture rtl of pc_counter is
    signal rPc_val : STD_lOGIC_VECTOR(31 downto 0);
begin
oPC <= rPc_val;

process(iClk)
begin
    if rising_edge(iClk) then
        if iRst = '1' then
            rPc_val <= gReset_PC;
        else
            rPc_val <= iPCNext;
        end if;    
    end if;
end process;

end rtl;
