-------------------------------------------------------------------------
-- Yohan Bopearatchy & Bailey G
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- regID_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of ID to EX pipeline registers
-- 
--
--
-- NOTES:
-- 11/11/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regID_EX is
	port(i_CLK		: in std_logic; --Clock
	     i_RST		: in std_logic; --Reset
	     i_WE		: in std_logic; --Write enable
 	     i_flush		: in std_logic;	-- flush
	     i_stall		: in std_logic; -- stall
	     id_MemtoReg	: in std_logic_vector(1 downto 0); --MemtoReg control signal from ID stage
	     id_RegWrite	: in std_logic; --RegWrite control signal from ID stage
	     id_DMemWr		: in std_logic; --Dmem write back signal from ID stage
	     id_ALUSrc		: in std_logic; --ALU source control signal from ID stage
	     id_RegDst		: in std_logic_vector(1 downto 0); --Register destination control signal from ID stage
	     id_Halt		: in std_logic; --Halt signal from ID stage
	     id_DmemRead	: in std_logic;	--DmemRead from ID stage
	     id_ALUOp		: in std_logic_vector(4 downto 0); --ALU Op output signal from ID stage
	     if_Pc4		: in std_logic_vector(31 downto 0); --PC + 4 from IF stage
	     id_ReadReg0	: in std_logic_vector(31 downto 0); --Read register0 output signal from ID stage
	     id_ReadReg1	: in std_logic_vector(31 downto 0); --Read register1 output signal from ID stage
	     id_ImmExt		: in std_logic_vector(31 downto 0); --Immediate Extend output signal from ID stage
	     id_Inst		: in std_logic_vector(31 downto 0); --Instruction signal from ID stage
	     o_ex_MemtoReg	: out std_logic_vector(1 downto 0); --MemtoReg control signal to EX stage
	     o_ex_RegWrite	: out std_logic; --RegWrite control signal to EX stage
	     o_ex_DMemWr	: out std_logic; --Dmem write back signal to EX stage
	     o_ex_ALUSrc	: out std_logic; --ALU source control signal to EX stage
	     o_ex_RegDst	: out std_logic_vector(1 downto 0); --Register destination control signal to EX stage
	     o_ex_Halt		: out std_logic; --Halt signal to EX stage
	     o_ex_DmemRead	: out std_logic; --DmemRead to EX stage
	     o_ex_ALUOp		: out std_logic_vector(4 downto 0); --ALU Op output signal to EX stage
	     o_ex_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to EX stage
	     o_ex_ReadReg0	: out std_logic_vector(31 downto 0); --Read register0 output signal to EX stage
	     o_ex_ReadReg1	: out std_logic_vector(31 downto 0); --Read register1 output signal to EX stage
	     o_ex_ImmExt	: out std_logic_vector(31 downto 0); --Immediate Extend output signal to EX stage
	     o_ex_Inst		: out std_logic_vector(31 downto 0)); --Instruction signal to EX stage
end regID_EX;

architecture structural of regID_EX is

  component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

  component register_N is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;     		-- Clock input
       i_RST        : in std_logic;    			-- Reset input
       i_WE         : in std_logic;     		-- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);-- Data value input Nbit
       o_Q          : out std_logic_vector(N-1 downto 0));-- Data value output Nbit
  end component;

  component andg2 is
	port(i_A          : in std_logic;
		 i_B          : in std_logic;
		 o_F          : out std_logic);
	end component;

  component invg is
	port(i_A          : in std_logic;
		 o_F          : out std_logic);
	end component;

	component flush_N is
		generic(N : integer := 32);
   		 port(
        i_flush : in std_logic;
        i_D: in std_logic_vector(N-1 downto 0);
        andOut: out std_logic_vector(N-1 downto 0));
	  end component;

   component flush_1 is
		port(
			i_flush : in std_logic;
			i_D: in std_logic;
			andOut: out std_logic);
	end component;

	--Signals
	signal  s_RegWrite_flush : std_logic;
	signal 	s_RegWrite_stall_and : std_logic;
	signal 	s_RegWrite_stall_not : std_logic;

	signal  s_DMemWr_flush : std_logic;
	signal 	s_DMemWr_stall_and : std_logic;
	signal 	s_DMemWr_stall_not : std_logic;
	
	signal  s_ALUSrc_flush : std_logic;
	signal 	s_ALUSrc_stall_and : std_logic;
	signal 	s_ALUSrc_stall_not : std_logic;

	signal  s_Halt_flush : std_logic;
	signal 	s_Halt_stall_and : std_logic;
	signal 	s_Halt_stall_not : std_logic;

	signal  s_DmemRead_flush : std_logic;
	signal 	s_DmemRead_stall_and : std_logic;
	signal 	s_DmemRead_stall_not : std_logic;

	signal s_MemtoReg_flush : std_logic_vector(1 downto 0);
	signal s_MemtoReg_stall_and : std_logic;
	signal s_MemtoReg_stall_not : std_logic;

	signal s_RegDst_flush : std_logic_vector(1 downto 0);
	signal s_RegDst_stall_and : std_logic;
	signal s_RegDst_stall_not : std_logic;

	signal s_ALUOp_flush : std_logic_vector(4 downto 0);
	signal s_ALUOp_stall_and : std_logic;
	signal s_ALUOp_stall_not : std_logic;

	signal s_Pc8_flush : std_logic_vector(31 downto 0);
	signal s_Pc8_stall_and : std_logic;
	signal s_Pc8_stall_not : std_logic;

	signal s_ReadReg0_flush : std_logic_vector(31 downto 0);
	signal s_ReadReg0_stall_and : std_logic;
	signal s_ReadReg0_stall_not : std_logic;

	signal s_ReadReg1_flush : std_logic_vector(31 downto 0);
	signal s_ReadReg1_stall_and : std_logic;
	signal s_ReadReg1_stall_not : std_logic;

	signal s_ImmExt_flush : std_logic_vector(31 downto 0);
	signal s_ImmExt_stall_and : std_logic;
	signal s_ImmExt_stall_not : std_logic;

	signal s_Inst_flush : std_logic_vector(31 downto 0);
	signal s_Inst_stall_and : std_logic;
	signal s_Inst_stall_not : std_logic;
begin
  RegWrite_flush: flush_1 port map(i_flush, id_RegWrite, s_RegWrite_flush);
  RegWrite_Stall_N: invg port map(i_stall, s_RegWrite_stall_not);
  RegWrite_stall_A: andg2 port map(i_WE, s_RegWrite_stall_not, s_RegWrite_stall_and);
  ID_EX_RegWrite_reg: dffg port map(i_CLK, i_RST, s_RegWrite_stall_and, s_RegWrite_flush, o_ex_RegWrite);

  DMemWr_flush: flush_1 port map(i_flush, id_DMemWr, s_DMemWr_flush);
  DMemWr_Stall_N: invg port map(i_stall, s_DMemWr_stall_not);
  DMemWr_Stall_A: andg2 port map(i_WE, s_DMemWr_stall_not, s_DMemWr_stall_and);
  ID_EX_DMemWr_reg: dffg port map(i_CLK, i_RST, s_DMemWr_stall_and, s_DMemWr_flush, o_ex_DMemWr);

  ALUSrc_flush: flush_1 port map(i_flush, id_ALUSrc, s_ALUSrc_flush);
  ALUSrc_Stall_N: invg port map(i_stall, s_ALUSrc_stall_not);
  ALUSrc_Stall_A: andg2 port map(i_WE, s_ALUSrc_stall_not, s_ALUSrc_stall_and);
  ID_EX_ALUSrc_reg: dffg port map(i_CLK, i_RST, s_ALUSrc_stall_and, s_ALUSrc_flush, o_ex_ALUSrc);

  Halt_flush: flush_1 port map(i_flush, id_Halt, s_Halt_flush);
  Halt_Stall_N: invg port map(i_stall, s_Halt_stall_not);
  Halt_Stall_A: andg2 port map(i_WE, s_Halt_stall_not, s_Halt_stall_and);
  ID_EX_Halt_reg: dffg port map(i_CLK, i_RST, s_Halt_stall_and, s_Halt_flush, o_ex_Halt);

  DmemRead_flush: flush_1 port map(i_flush, id_DmemRead, s_DmemRead_flush);
  DmemRead_Stall_N: invg port map(i_stall, s_DmemRead_stall_not);
  DmemRead_Stall_A: andg2 port map(i_WE, s_DmemRead_stall_not, s_DmemRead_stall_and);
  ID_EX_DmemRead_reg: dffg port map(i_CLK, i_RST, s_DmemRead_stall_and, s_DmemRead_flush, o_ex_DmemRead);

  MemtoReg_flush: flush_N generic map(2) port map(i_flush, id_MemtoReg, s_MemtoReg_flush);
  MemtoReg_Stall_N: invg port map(i_stall, s_MemtoReg_stall_not);
  MemtoReg_Stall_A: andg2 port map(i_WE, s_MemtoReg_stall_not, s_MemtoReg_stall_and);
  ID_EX_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, s_MemtoReg_stall_and, s_MemtoReg_flush, o_ex_MemtoReg);

  RegDst_flush: flush_N generic map(2) port map(i_flush, id_RegDst, s_RegDst_flush);
  RegDst_Stall_N: invg port map(i_stall, s_RegDst_stall_not);
  RegDst_Stall_A: andg2 port map(i_WE, s_RegDst_stall_not, s_RegDst_stall_and);
  ID_EX_RegDst_reg: register_N generic map(2) port map(i_CLK, i_RST, s_RegDst_stall_and, s_RegDst_flush, o_ex_RegDst);

  ALUOp_flush: flush_N generic map(5) port map(i_flush, id_ALUOp, s_ALUOp_flush);
  ALUOp_Stall_N: invg port map(i_stall, s_ALUOp_stall_not);
  ALUOp_Stall_A: andg2 port map(i_WE, s_ALUOp_stall_not, s_ALUOp_stall_and);
  ID_EX_ALUOp_reg: register_N generic map(5) port map(i_CLK, i_RST, s_ALUOp_stall_and, s_ALUOp_flush, o_ex_ALUOp);
 
  Pc8_flush: flush_N generic map(32) port map(i_flush, if_Pc4, s_Pc8_flush);
  Pc8_Stall_N: invg port map(i_stall, s_Pc8_stall_not);
  Pc8_Stall_A: andg2 port map(i_WE, s_Pc8_stall_not, s_Pc8_stall_and);
  ID_EX_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, s_Pc8_stall_and, s_Pc8_flush, o_ex_Pc8);

  ReadReg0_flush: flush_N generic map(32) port map(i_flush, id_ReadReg0, s_ReadReg0_flush);
  ReadReg0_Stall_N: invg port map(i_stall, s_ReadReg0_stall_not);
  ReadReg0_Stall_A: andg2 port map(i_WE, s_ReadReg0_stall_not, s_ReadReg0_stall_and);
  ID_EX_ReadReg0_reg: register_N generic map(32) port map(i_CLK, i_RST, s_ReadReg0_stall_and, s_ReadReg0_flush, o_ex_ReadReg0);
  
  ReadReg1_flush: flush_N generic map(32) port map(i_flush, id_ReadReg1, s_ReadReg1_flush);
  ReadReg1_Stall_N: invg port map(i_stall, s_ReadReg1_stall_not);
  ReadReg1_Stall_A: andg2 port map(i_WE, s_ReadReg1_stall_not, s_ReadReg1_stall_and);
  ID_EX_ReadReg1_reg: register_N generic map(32) port map(i_CLK, i_RST, s_ReadReg1_stall_and, s_ReadReg1_flush, o_ex_ReadReg1);

  ImmExt_flush: flush_N generic map(32) port map(i_flush, id_ImmExt, s_ImmExt_flush);
  ImmExt_Stall_N: invg port map(i_stall, s_ImmExt_stall_not);
  ImmExt_Stall_A: andg2 port map(i_WE, s_ImmExt_stall_not, s_ImmExt_stall_and);
  ID_EX_ImmExt_reg: register_N generic map(32) port map(i_CLK, i_RST, s_ImmExt_stall_and, s_ImmExt_flush, o_ex_ImmExt);

  Inst_flush: flush_N generic map(32) port map(i_flush, id_Inst, s_Inst_flush);
  Inst_Stall_N: invg port map(i_stall, s_Inst_stall_not);
  Inst_Stall_A: andg2 port map(i_WE, s_Inst_stall_not, s_Inst_stall_and);
  ID_EX_Inst_reg: register_N generic map(32) port map(i_CLK, i_RST, s_Inst_stall_and, s_Inst_flush, o_ex_Inst);

  
end structural;
