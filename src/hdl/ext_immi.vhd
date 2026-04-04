----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2026 07:32:44 PM
-- Design Name: 
-- Module Name: ext_immi - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Extends immediate using MSB based on instruction type.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ext_immi is
    Port ( iInstr : in STD_LOGIC_VECTOR(31 downto 0);
           iImmiSel : in STD_LOGIC_VECTOR(2 downto 0);
           oImmiExt : out STD_LOGIC_VECTOR(31 downto 0)
           );
end ext_immi;

architecture rtl of ext_immi is

begin
    process(iInstr, iImmiSel)
    begin
        case iImmiSel is
            when "000" => 
                oImmiExt <= (31 downto 11 => iInstr(31)) & iInstr(30 downto 20);
            when "001" =>
                oImmiExt <= (31 downto 11 => iInstr(31)) & iInstr(30 downto 25) & iInstr(11 downto 7);
            when "010" =>
                oImmiExt <= (31 downto 12 => iInstr(31)) & iInstr(7) & iInstr(30 downto 25) & iInstr(11 downto 8) & '0';
            when "011" =>
                oImmiExt <= iInstr(31 downto 12) & (11 downto 0 => '0');
            when "100" =>
                oImmiExt <= (31 downto 20 => iInstr(31)) & iInstr(19 downto 12) & iInstr(20) & iInstr(30 downto 21) & '0';
            when others =>
                oImmiExt <= (others => '0');
        end case;
    end process;
end rtl;
