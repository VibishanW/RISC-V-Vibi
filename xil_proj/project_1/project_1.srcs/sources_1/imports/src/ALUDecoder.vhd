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

entity ALUDecoder is
    Port ( iALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           iFunc3 : in STD_LOGIC_VECTOR(2 downto 0);
           iFunc7 : in STD_LOGIC;
           oALUCtrl : out STD_LOGIC_VECTOR(3 downto 0));
end ALUDecoder;

architecture Behavioral of ALUDecoder is

begin
    process(iALUOp, iFunc3, iFunc7)
    begin
        case iALUOp is
            when "00" =>
                oALUCtrl <= "0000";
            when "01" =>
                oALUCtrl <= "0001";
            when "10" =>
                case iFunc3 is
                    when "000" =>
                        if(iFunc7 = '1') then
                            oALUCtrl <= "0001";
                        else
                            oALUCtrl <= "0000";
                        end if;
                    when "001" =>
                        oALUCtrl <= "0111";
                    when "010" =>
                        oALUCtrl <= "0101";
                    when "011" =>
                        oALUCtrl <= "0110";
                    when "100" =>
                        oALUCtrl <= "0100";
                    when "101" =>
                        if(iFunc7 = '1') then
                            oALUCtrl <= "1001";
                        else
                            oALUCtrl <= "1000";
                        end if;
                    when "110" =>
                        oALUCtrl <= "0011";
                    when "111" =>
                        oALUCtrl <= "0010";
                end case;
        end case;
    end process;
               
end Behavioral;
