library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity control_unit is
    generic(
        gReset_PC : STD_LOGIC_VECTOR(31 downto 0) := x"00000000"
        );
	port(oPCSrc : out STD_LOGIC_VECTOR(31 downto 0);
        oRegW : out STD_LOGIC;
        oImmSrc : out STD_LOGIC_VECTOR(2 downto 0);
        oALUSrc : out STD_LOGIC;
        oALUCtrl : out STD_LOGIC_VECTOR(3 downto 0);
        oMemW : out STD_LOGIC;
        oResSrc : out STD_LOGIC_VECTOR(1 downto 0);
        oBranch : out STD_LOGIC;
        oJump : out STD_LOGIC;
		iFunc3 : in STD_LOGIC_VECTOR(2 downto 0);
		iFunc7 : in STD_LOGIC;
		iOp : in STD_LOGIC_VECTOR(6 downto 0);
		iClk, iRst : in STD_LOGIC);
end entity control_unit;

architecture struct of control_unit is

signal wALUOp : STD_LOGIC_VECTOR(1 downto 0);

begin
-- Increments PC(address)
MD : entity work.MainDecoder
    port map (
        iOp         => iOp,
        oRegW       => oRegW,
        oImmSrc     => oImmSrc,
        oALUSrc     => oALUSrc,
        oMemW       => oMemW,
        oResSrc     => oResSrc,
        oBranch     => oBranch,
        oJump       => oJump,
        oALUOp      => wALUOp
    );
    
ALUDec : entity work.ALUDecoder
    port map (
        iFunc3    => iFunc3,
        iFunc7    => iFunc7,
        iALUOp    => wALUOp,
        oALUCtrl  => oALUCtrl
    );
end;