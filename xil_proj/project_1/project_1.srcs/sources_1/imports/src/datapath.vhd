library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity datapath is
    generic(gReset_PC : STD_LOGIC_VECTOR(31 downto 0) := x"00000000");
	port(oPC, oALURes, oWriteData, oInstr : out STD_LOGIC_VECTOR(31 downto 0);
		iPCNext, iReadData : in STD_LOGIC_VECTOR(31 downto 0);
		iClk, iRst : in STD_LOGIC;
		
		--ctrl signals
		iPCSrc : in STD_LOGIC_VECTOR(31 downto 0);
        iRegW : in STD_LOGIC;
        iImmiSrc : in STD_LOGIC_VECTOR(2 downto 0);
        iALUSrc : in STD_LOGIC;
        iALUCtrl : in STD_LOGIC_VECTOR(3 downto 0);
        iMemW : in STD_LOGIC;
        iResSrc : in STD_LOGIC_VECTOR(1 downto 0);
        iBranch : in STD_LOGIC;
        iJump : in STD_LOGIC
		);
end entity datapath;

architecture struct of datapath is
	signal we : STD_LOGIC; --write enable
	signal writeback : STD_LOGIC_VECTOR(7 downto 0); --write back
	signal wRd2 : STD_LOGIC_VECTOR(31 downto 0);

-- internal signals
    signal wPC : STD_LOGIC_VECTOR(31 downto 0);
    signal wInstr : STD_LOGIC_VECTOR(31 downto 0);
    signal wSrcA : STD_LOGIC_VECTOR(4 downto 0);
    signal wSrcB : STD_LOGIC_VECTOR(4 downto 0);
    signal wImmiExt : STD_LOGIC_VECTOR(31 downto 0);
    signal wALURes : STD_LOGIC_VECTOR(31 downto 0);
    signal wRD : STD_LOGIC;
    
    
    --Breakout Signals
    --signal oALURes : STD_LOGIC_VECTOR(31 downto 0);
begin
-- Increments PC(address)
PCounter : entity work.pc_counter
    generic map(
        gReset_PC => gReset_PC);
    port map(
        iClk      => iClk,
        iRst      => iRst,
        iPCNext   => iPCNext,
        oPC       => wPC
    );
    
-- iPC <= wPC;
    
-- Address to instruction
 IM : entity work.instr_memory
    port map (
        iPC       => wPC,
        oInstr    => wInstr
    );
    
    
-- Instruction to drive read and writes
 RF : entity work.register_file
    port map(
        iClk => iClk, 
        iRst => iRst, 
        iWen => iRegW, 
        iAd1 => wInstr(19 downto 15), 
        iAd2 => wInstr(20 downto 24), 
        iWb => wRD, 
        oRd1 => wSrcA, 
        oRd2 => wRd2
    );
    
 EXT : entity work.ext_immi
    port map(
        iImmi => wInstr(31 downto 7),
        iImmiSel => iImmiSrc,
        oImmiExt => wImmiExt
    );
        
 
 AluSrc : entity work.alu_src
    port map(
        iRd2 => wRd2,
        iImmExt => wImmExt,
        iALUSrc => iALUSrc,
        oSrcB => wSrcB
    );
    
 ALU : entity work.ALU
    port map(
        iSrcA => wSrcA,
        iSrcB => wSrcB,
        iALUCtrl => iALUCtrl,
        iZero => iZero,
        oALURes => wALURes
    );
    

 DM : entity work.data_memory
    port map(
        iClk => iClk,
        iRst => iRst,
        iALUout => wALURes,
        iWD => wRd2,
        iWE => iMemW,
        oRD => wRD
    );
 
 --iALURes =
 Result : entity work.res_out
    port map(
        iResSrc => wResSrc,
        iRD => wRD,
        iALURes => wALURes,
        oResult => wResult
    );
    
    oInstr <= wInstr;
        
-- sequential logic

-- output RD1 and RD2
end;