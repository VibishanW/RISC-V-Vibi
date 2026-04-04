library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Package Declaration Section
package reg_pkg is
 
  constant WIDTH : integer := 32 - 1;
  
  type x_bit_reg is array(0 to 31) of STD_LOGIC_VECTOR(WIDTH downto 0);
  
  constant X_BIT_REG_INIT : x_bit_reg := (
    others => x"00000000"
    );
  
--  type x_bit_reg is record
--    zero  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    ra  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    sp  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    gp  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    tp  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t0  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t1  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t2  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s0  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s1  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a0  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a1  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a2  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a3  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a4  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a5  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a6  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    a7  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s2  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s3  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s4  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s5  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s6  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s7  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s8  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s9  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s10  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    s11  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t3  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t4  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t5  : STD_LOGIC_VECTOR(WIDTH downto 0);
--    t6  : STD_LOGIC_VECTOR(WIDTH downto 0);
--  end record x_bit_reg;
  
--  Constant x_bit_reg : x_bit_reg_init := (
--    zero => x"0000000",
--    ra => x"0000000",
--    sp => x"0000000",
--    gp => x"0000000",
--    tp => x"0000000",
--    t0 => x"0000000",
--    t1 => x"0000000",
--    t2 => x"0000000",
--    s0 => x"0000000",
--    s1 => x"0000000",
--    a0 => x"0000000",
--    a1 => x"0000000",
--    a2 => x"0000000",
--    a3 => x"0000000",
--    a4 => x"0000000",
--    a5 => x"0000000",
--    a6 => x"0000000",
--    a7 => x"0000000",
--    s2 => x"0000000",
--    s3 => x"0000000",
--    s4 => x"0000000",
--    s5 => x"0000000",
--    s6 => x"0000000",
--    s7 => x"0000000",
--    s8 => x"0000000",
--    s9 => x"0000000",
--    s10 => x"0000000",
--    s11 => x"0000000",
--    t3 => x"0000000",
--    t4 => x"0000000",
--    t5 => x"0000000",
--    t6 => x"0000000"
--    )
 
end package reg_pkg;