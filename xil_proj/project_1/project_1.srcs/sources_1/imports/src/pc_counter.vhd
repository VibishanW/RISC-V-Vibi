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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_counter is
    Generic (
           gReset_PC : std_logic_vector(31 downto 0) := x"00000000"
    );
    Port ( iClk : in std_logic;
           iRst : in std_logic;
           iPCNext : in std_logic_vector(31 downto 0);
           oPC : out std_logic_vector(31 downto 0));
end pc_counter;

architecture Behavioral of pc_counter is
    signal rpc_val : std_logic_vector(31 downto 0);
begin
oPC <= rpc_val;

process(iClk)
begin
    if rising_edge(iClk) then
        if iRst = '0' then
            rpc_val <= gReset_PC;
        else
            rpc_val <= iPCNext;
        end if;    
    end if;
end process;

end Behavioral;
