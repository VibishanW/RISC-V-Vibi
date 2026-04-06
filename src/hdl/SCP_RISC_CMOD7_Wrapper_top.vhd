----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2026 07:32:34 PM
-- Design Name: 
-- Module Name: SCP_RISC_CMOD7_Wrapper_top - Behavioral
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

entity SCP_RISC_CMOD7_Wrapper_top is
  Port (iClk : in STD_LOGIC;
        iRst : in STD_LOGIC;
        oLED : out STD_LOGIC_VECTOR(3 downto 0)
        );
end SCP_RISC_CMOD7_Wrapper_top;

architecture struct of SCP_RISC_CMOD7_Wrapper_top is

    signal wPC        : std_logic_vector(31 downto 0);
    signal wALURes    : std_logic_vector(31 downto 0);
    signal wWriteData : std_logic_vector(31 downto 0);
    signal wPCNext    : std_logic_vector(31 downto 0) := (others => '0');
    signal wReadData  : std_logic_vector(31 downto 0) := (others => '0');
begin

    u_cpu : entity work.single_cycle_processor
        port map(
            oPC        => wPC,
            oALURes    => wALURes,
            oWriteData => wWriteData,
            iPCNext    => wPCNext,
            iReadData  => wReadData,
            iClk       => iClk,
            iRst       => iRst
        );

    oLED <= wPC(5 downto 2);

end architecture;
