----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 06:03:45 PM
-- Design Name: 
-- Module Name: ALUDecoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- ALU Decoder that flips control values related to arithmetic operations to guide correct logical operations.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUDecoder is
    Port ( iOp5 : in STD_LOGIC;
           iALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           iFunc3 : in STD_LOGIC_VECTOR(2 downto 0);
           iFunc7 : in STD_LOGIC;
           oALUCtrl : out STD_LOGIC_VECTOR(3 downto 0));
end ALUDecoder;

architecture rtl of ALUDecoder is

begin
    process(iOp5, iALUOp, iFunc3, iFunc7)
    begin
        case iALUOp is
            when "00" =>
                oALUCtrl <= "0000"; --add
            when "01" =>
                oALUCtrl <= "0001"; --sub
            when "10" =>
                case iFunc3 is
                    when "000" =>
                        if(iFunc7 = '1' and iOp5 = '1') then
                            oALUCtrl <= "0001"; --sub
                        else
                            oALUCtrl <= "0000"; --add
                        end if;
                    when "001" =>
                        oALUCtrl <= "0111"; --sll
                    when "010" =>
                        oALUCtrl <= "0101"; --slt
                    when "011" =>
                        oALUCtrl <= "0110"; --sltu
                    when "100" =>
                        oALUCtrl <= "0100"; --xor
                    when "101" =>
                        if(iFunc7 = '1') then
                            oALUCtrl <= "1001"; --sra
                        else
                            oALUCtrl <= "1000"; --srl
                        end if;
                    when "110" =>
                        oALUCtrl <= "0011"; --or
                    when "111" =>
                        oALUCtrl <= "0010"; --and
                    when others =>
                        oALUCtrl <= "0000"; --add
                end case;
            when others =>
                oALUCTrl <= "0000";
        end case;
    end process;
               
end rtl;
