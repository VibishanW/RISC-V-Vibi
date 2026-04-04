----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 06:03:45 PM
-- Design Name: 
-- Module Name: MainDecoder - Behavioral
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

entity MainDecoder is
    Port ( 
        iOp : in STD_LOGIC_VECTOR(6 downto 0);
        oRegW : out STD_LOGIC;
        oImmSrc : out STD_LOGIC_VECTOR(2 downto 0);
        oALUSrc : out STD_LOGIC;
        oMemW : out STD_LOGIC;
        oResSrc : out STD_LOGIC_VECTOR(1 downto 0);
        oBranch : out STD_LOGIC;
        oJump : out STD_LOGIC;
        oALUOp : out STD_LOGIC_VECTOR(1 downto 0)
    );
end MainDecoder;

architecture Behavioral of MainDecoder is

begin
    process(iOp)
    begin
        case iOp(6 downto 0) is
            when "0110011" =>
                oRegW <= '1';
                oImmSrc <= "XXX";
                oALUSrc <= '0';
                oMemW <= '0';
                oResSrc <= "00";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "10";
            when "0010011" =>
                oRegW <= '1';
                oImmSrc <= "000";
                oALUSrc <= '1';
                oMemW <= '0';
                oResSrc <= "00";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "10";
            when "0000011" =>
                oRegW <= '1';
                oImmSrc <= "000";
                oALUSrc <= '1';
                oMemW <= '0';
                oResSrc <= "01";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "00";
            when "0100011" =>
                oRegW <= '0';
                oImmSrc <= "001";
                oALUSrc <= '1';
                oMemW <= '1';
                oResSrc <= "XX";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "00";
            when "1100011" =>
                oRegW <= '0';
                oImmSrc <= "010";
                oALUSrc <= '0';
                oMemW <= '0';
                oResSrc <= "XX";
                oBranch <= '1';
                oJump <= '0';
                oALUOp <= "01";
            when "1101111" =>
                oRegW <= '1';
                oImmSrc <= "100";
                oALUSrc <= 'X';
                oMemW <= '0';
                oResSrc <= "10";
                oBranch <= '0';
                oJump <= '1';
                oALUOp <= "XX";
            when "1100111" =>
                oRegW <= '1';
                oImmSrc <= "000";
                oALUSrc <= '1';
                oMemW <= '0';
                oResSrc <= "10";
                oBranch <= '0';
                oJump <= '1';
                oALUOp <= "00";
            when "0110111" =>
                oRegW <= '1';
                oImmSrc <= "011";
                oALUSrc <= 'X';
                oMemW <= '0';
                oResSrc <= "00";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "XX";
            when "0010111" =>
                oRegW <= '1';
                oImmSrc <= "011";
                oALUSrc <= '1';
                oMemW <= '0';
                oResSrc <= "00";
                oBranch <= '0';
                oJump <= '0';
                oALUOp <= "00";
            end case;
    end process;
end Behavioral;
