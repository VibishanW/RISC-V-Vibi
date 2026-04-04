----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 10:23:00 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Loads and stores values into memory.
-- Takes in ALU result (address) to index data memory for storing and loading information (Reads and Writes).
-- Writes are sync and write enable dependent while reads are async.
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
use work.reg_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
    Port ( iClk : in STD_LOGIC;
           iRst : in STD_LOGIC;
           iALUout : in STD_LOGIC_VECTOR(31 downto 0);
           iWD : in STD_LOGIC_VECTOR(31 downto 0);
           iWE : in STD_LOGIC;
           oRD : out STD_LOGIC_VECTOR(31 downto 0)
           );
end data_memory;

architecture rtl of data_memory is
signal dmem : t_data_mem := C_DATA_MEM_INIT;
signal index : integer range 0 to 1023;
begin

index <= to_integer(unsigned(iALUout(11 downto 2)));
process(iClk)
begin
    if rising_edge(iClk) then
        if iRst = '1' then
            dmem <= C_DATA_MEM_INIT;
        elsif iWE = '1' then
            dmem(index) <= iWD;
        end if;
    end if;
end process;

process(dmem, index)
begin
    oRD <= dmem(index);
end process;
end rtl;
