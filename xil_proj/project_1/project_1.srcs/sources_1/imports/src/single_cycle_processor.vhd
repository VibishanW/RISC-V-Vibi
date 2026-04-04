library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.reg_pkg.all;

entity single_cycle_processor is
	port(oPC, oALURes, oWriteData: out STD_LOGIC_VECTOR(31 downto 0);
		iPCNext, iReadData: in STD_LOGIC_VECTOR(31 downto 0);
		iClk, iRst: in STD_LOGIC);
end;

architecture struct of single_cycle_processor is
--	component controlunit
--	port(instr: in STD_LOGIC_VECTOR(31 downto 0);
--		clk, rst: in STD_LOGIC;
--		a1, a2, a3: in STD_LOGIC);
--	end component;
--	component datapath
--	port(clk, rst, PCMux, ALUMux: in STD_LOGIC;
--		PC, ALURes, WriteData: in STD_LOGIC_VECTOR(31 downto 0);
--		instr, ReadData: in	STD_LOGIC_VECTOR(31 downto 0));
--	end component;

    signal wInstr :	STD_LOGIC_VECTOR(31 downto 0);
    signal rPC : STD_LOGIC_VECTOR(31 downto 0);
    signal wALURes : STD_LOGIC_VECTOR(31 downto 0);
    signal wWriteData : STD_LOGIC_VECTOR(31 downto 0);
    signal wPC_Src : STD_LOGIC_VECTOR(31 downto 0);
    signal wRes_Src : STD_LOGIC_VECTOR(1 downto 0);
    signal wMem_Write : STD_LOGIC;
    signal wALU_Src : STD_LOGIC;
    signal wImmi_Src : STD_LOGIC_VECTOR(2 downto 0);
    signal wReg_Write : STD_LOGIC;
    signal wALU_Ctrl : STD_LOGIC_VECTOR(3 downto 0);
    signal wBranch : STD_LOGIC;
    signal wJump : STD_LOGIC;
	--signal PCMux, ALUMux : STD_LOGIC;
begin
    datapath : entity work.datapath
    --pull Zero Register
    port map (
        oPC      => rPC,
        oALURes  => wALURes,
        oWriteData   => wWriteData,
        oInstr      => wInstr,
        iPCNext      => iPCNext,
        iReadData    => iReadData,
        iClk     => iClk,
        iRst     => iRst,
        --ctrl signals
        iPCSrc  => wPC_Src,
        iResSrc => wRes_Src,
        iMemW => wMem_Write,
        iALUSrc => wALU_Src,
        iImmiSrc => wImmi_Src,
        iRegW   => wReg_Write,
        iALUCtrl    => wALU_Ctrl,
        iBranch     => wBranch,
        iJump       => wJump
    );

    ctrlunit : entity work.control_unit
    port map (
        iClk    => iClk,
        iRst     => iRst,
        iFunc3  => wInstr(14 downto 12),
        iFunc7  => wInstr(30),
        iOp     => wInstr(6 downto 0),
        oPCSrc  => wPC_Src,
        oResSrc  => wRes_SrC,
        oMemW => wMem_Write,
        oALUSrc  => wALU_Src,
        oImmSrc  => wImmi_Src,
        oRegW  => wReg_Write,
        oALUCtrl   => wALU_Ctrl,
        oBranch => wBranch,
        oJump => wJump
    );
end;