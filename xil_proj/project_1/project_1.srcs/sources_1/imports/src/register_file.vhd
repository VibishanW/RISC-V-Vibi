library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.reg_pkg.all;

entity register_file is
	generic (
	    width : integer := 32
	);
	port(iClk, iRst, iWen: in STD_LOGIC;
		iAd1, iAd2: in STD_LOGIC_VECTOR(4 downto 0);
		iWb: in STD_LOGIC_VECTOR(7 downto 0);
		oRd1, oRd2: out STD_LOGIC_VECTOR(31 downto 0));
end register_file;

architecture struct of datapath is

signal regs : x_bit_reg := X_BIT_REG_INIT;
begin
process(iClk) -- set reg 0 to 0
begin
if rising_edge(iClk) then
    if rising_edge(iRst) then
        regs <= x_bit_reg;
    end if
end if
end process;

-- combination logic to set ad1 and ad2 to rd1 and rd2

--mux 1: Address 1 -> Read 1 Port
process(iClk,iAd1,oRd1)
begin
if rising_edge(iClk) then
    oRd1 <= regs(to_integer(iAd1));
end if;
end process;
    
--    case(ad1)
--        when "00000" => rd1 <= ROM[0;
--        when "00001" => rd1 <= ROM[1];
--        when "00010" => rd1 <= ROM[2];
--        when "00011" => rd1 <= gp;
--        when "00100" => rd1 <= tp;
--        when "00101" => rd1 <= t0;
--        when "00110" => rd1 <= t1;
--        when "00111" => rd1 <= t2;
--        when "01000" => rd1 <= s0;
--        when "01001" => rd1 <= s1;
--        when "01010" => rd1 <= a0;
--        when "01011" => rd1 <= a1;
--        when "01100" => rd1 <= a2;
--        when "01101" => rd1 <= a3;
--        when "01110" => rd1 <= a4;
--        when "01111" => rd1 <= a5;
--        when "10000" => rd1 <= a6;
--        when "10001" => rd1 <= a7;
--        when "10010" => rd1 <= s2;
--        when "10011" => rd1 <= s3;
--        when "10100" => rd1 <= s4;
--        when "10101" => rd1 <= s5;
--        when "10110" => rd1 <= s6;
--        when "10111" => rd1 <= s7;
--        when "11000" => rd1 <= s8; 
--        when "11001" => rd1 <= s9;
--        when "11010" => rd1 <= s10;
--        when "11011" => rd1 <= s11;
--        when "11100" => rd1 <= t3;
--        when "11101" => rd1 <= t4;
--        when "11110" => rd1 <= t5;
--        when "11111" => rd1 <= t6;
--        when others => rd1 <= (others => '0');
--     end case;
     
--mux 2: Address 2 -> Read 2 Port
process(iClk,iAd2,oRd2)
begin
if rising_edge(iClk) then
    oRd2 <= regs(to_integer(iAd2));
end if;
end process;

--if rising_edge(iclk) then
--    case(ad1)
--        when "00000" => rd2 <= zero;
--        when "00001" => rd2 <= ra1;
--        when "00010" => rd2 <= sp;
--        when "00011" => rd2 <= gp;
--        when "00100" => rd2 <= tp;
--        when "00101" => rd2 <= t0;
--        when "00110" => rd2 <= t1;
--        when "00111" => rd2 <= t2;
--        when "01000" => rd2 <= s0;
--        when "01001" => rd2 <= s1;
--        when "01010" => rd2 <= a0;
--        when "01011" => rd2 <= a1;
--        when "01100" => rd2 <= a2;
--        when "01101" => rd2 <= a3;
--        when "01110" => rd2 <= a4;
--        when "01111" => rd2 <= a5;
--        when "10000" => rd2 <= a6;
--        when "10001" => rd2 <= a7;
--        when "10010" => rd2 <= s2;
--        when "10011" => rd2 <= s3;
--        when "10100" => rd2 <= s4;
--        when "10101" => rd2 <= s5;
--        when "10110" => rd2 <= s6;
--        when "10111" => rd2 <= s7;
--        when "11000" => rd2 <= s8; 
--        when "11001" => rd2 <= s9;
--        when "11010" => rd2 <= s10;
--        when "11011" => rd2 <= s11;
--        when "11100" => rd2 <= t3;
--        when "11101" => rd2 <= t4;
--        when "11110" => rd2 <= t5;
--        when "11111" => rd2 <= t6;
--        when others => rd1 <= (others => '0');
--     end case;

process(iClk)
begin
--decode

end process


-- process enable write on clk edge
-- make reg 0 un editable
end;