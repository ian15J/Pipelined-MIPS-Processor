-------------------------------------------------------------------------
-- Yohan Bopearatchy
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
	     id_MemtoReg	: in std_logic_vector(1 downto 0); --MemtoReg control signal from ID stage
	     id_RegWrite	: in std_logic; --RegWrite control signal from ID stage
	     id_DMemWr		: in std_logic; --Dmem write back signal from ID stage
	     id_ALUSrc		: in std_logic; --ALU source control signal from ID stage
	     id_RegDst		: in std_logic_vector(1 downto 0); --Register destination control signal from ID stage
	     id_Halt		: in std_logic; --Halt signal from ID stage
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

begin
  ID_EX_RegWrite_reg: dffg port map(i_CLK, i_RST, i_WE, id_RegWrite, o_ex_RegWrite);
  ID_EX_DMemWr_reg: dffg port map(i_CLK, i_RST, i_WE, id_DMemWr, o_ex_DMemWr);
  ID_EX_ALUSrc_reg: dffg port map(i_CLK, i_RST, i_WE, id_ALUSrc, o_ex_ALUSrc);
  ID_EX_Halt_reg: dffg port map(i_CLK, i_RST, i_WE, id_Halt, o_ex_Halt);
  
  ID_EX_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, i_WE, id_MemtoReg, o_ex_MemtoReg);
  ID_EX_RegDst_reg: register_N generic map(2) port map(i_CLK, i_RST, i_WE, id_RegDst, o_ex_RegDst);
  ID_EX_ALUOp_reg: register_N generic map(5) port map(i_CLK, i_RST, i_WE, id_ALUOp, o_ex_ALUop);
  ID_EX_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, if_pc4, o_ex_Pc8);
  ID_EX_ReadReg0_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, id_ReadReg0, o_ex_ReadReg0);
  ID_EX_ReadReg1_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, id_ReadReg1, o_ex_ReadReg1);
  ID_EX_ImmExt_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, id_ImmExt, o_ex_ImmExt);
  ID_EX_Inst_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, id_Inst, o_ex_Inst);
  
end structural;
