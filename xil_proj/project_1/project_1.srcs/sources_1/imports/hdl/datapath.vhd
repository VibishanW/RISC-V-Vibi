library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity datapath is
    generic(gReset_PC : STD_LOGIC_VECTOR(31 downto 0) := x"00000000");
	port(oPC, oALURes, oWriteData, oInstr : out STD_LOGIC_VECTOR(31 downto 0);
	    oZero : out STD_LOGIC;
		iPCNext, iReadData : in STD_LOGIC_VECTOR(31 downto 0);
		iClk, iRst : in STD_LOGIC;
		
		--ctrl signals
		iPCSrc : in STD_LOGIC;
        iRegW : in STD_LOGIC;
        iImmiSrc : in STD_LOGIC_VECTOR(2 downto 0);
        iALUSrc : in STD_LOGIC;
        iALUCtrl : in STD_LOGIC_VECTOR(3 downto 0);
        iMemW : in STD_LOGIC;
        iResSrc : in STD_LOGIC;
        iBranch : in STD_LOGIC;
        iJump : in STD_LOGIC
		);
end entity datapath;

architecture struct of datapath is
	

-- internal signals
    signal wPC : STD_LOGIC_VECTOR(31 downto 0);
    signal wPCIncr : STD_LOGIC_VECTOR(31 downto 0);
    signal wPCTarg : STD_LOGIC_VECTOR(31 downto 0);
    signal wPCNext : STD_LOGIC_VECTOR(31 downto 0);
    signal wInstr : STD_LOGIC_VECTOR(31 downto 0);
    signal wSrcA : STD_LOGIC_VECTOR(31 downto 0);
    signal wSrcB : STD_LOGIC_VECTOR(31 downto 0);
    signal wImmiExt : STD_LOGIC_VECTOR(7 downto 0);
    signal wALURes : STD_LOGIC_VECTOR(31 downto 0);
    signal wRD : STD_LOGIC_VECTOR(7 downto 0);
    signal wRd2 : STD_LOGIC_VECTOR(31 downto 0);
    signal wResult : STD_LOGIC_VECTOR(31 downto 0);
    

begin

PCSrc : entity work.pc_src
    port map(
        iPCIncr => wPCIncr,
        iPCTarg => wPCTarg,
        iPCSrc  => iPCSrc,
        oPCNext => wPCNext
    );
        
-- Increments PC(address)
PCounter : entity work.pc_counter
    generic map(
        gReset_PC => gReset_PC)
    port map(
        iClk      => iClk,
        iRst      => iRst,
        iPCNext   => wPCNext,
        oPC       => wPC
    );
    
 PCPFour : entity work.pc_plus_four
    port map(
        iPC       => wPC,
        oPCNext   => wPCIncr
    );
    
 PCTarget : entity work.pc_target
    port map(
        iPC       => wPC,
        iImmExt   => wImmiExt,
        oPCTarg       => wPCTarg
    );
    
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
        iAd2 => wInstr(24 downto 20), 
        iWrAd => wInstr(11 downto 7),
        iWb => wRD, 
        oRd1 => wSrcA, 
        oRd2 => wRd2
    );
    
 EXT : entity work.ext_immi
    port map(
        iInstr => wInstr,
        iImmiSel => iImmiSrc,
        oImmiExt => wImmiExt
    );
        
 
 AluSrc : entity work.alu_src
    port map(
        iRd2 => wRd2,
        iImmExt => wImmiExt,
        iALUSrc => iALUSrc,
        oSrcB => wSrcB
    );
    
 ALU : entity work.ALU
    port map(
        iSrcA => wSrcA,
        iSrcB => wSrcB,
        iALUCtrl => iALUCtrl,
        oZero => oZero,
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
        iResSrc => iResSrc,
        iRD => wRD,
        iALURes => wALURes,
        oResult => wResult
    );
end;