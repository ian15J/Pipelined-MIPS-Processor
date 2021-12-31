-------------------------------------------------------------------------
-- Yohan Bopearatchy & Bailey G
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- regMEM_WB.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of MEM to WB pipeline registers
-- 
--
--
-- NOTES:
-- 11/11/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regMEM_WB is
	port(i_CLK		: in std_logic; --Clock
	     i_RST		: in std_logic; --Reset
	     i_WE		: in std_logic; --Write enable
	     i_flush		: in std_logic;	-- flush
             i_stall		: in std_logic; -- stall
	     mem_MemtoReg	: in std_logic_vector(1 downto 0); --MemtoReg control signal from MEM stage
	     mem_Reg_Rd		: in std_logic_vector(4 downto 0); --Reg_Rd signal from MEM stage
	     mem_RegWrite	: in std_logic; --RegWrite control signal from MEM stage
	     mem_Halt		: in std_logic; --Halt signal from MEM stage
	     mem_Pc8		: in std_logic_vector(31 downto 0); --PC + 8 from EX stage
	     mem_DMemOut	: in std_logic_vector(31 downto 0); --Dmem output from MEM stage
	     mem_ALUOut		: in std_logic_vector(31 downto 0); --ALU output from MEM stage
	     o_wb_MemtoReg	: out std_logic_vector(1 downto 0); --MemtoReg control signal to WB stage
	     o_wb_Reg_Rd	: out std_logic_vector(4 downto 0); --Reg_Rd signal to WB stage
	     o_wb_RegWrite	: out std_logic; --RegWrite control signal to WB stage
	     o_wb_Halt		: out std_logic; --Halt signal to WB stage
	     o_wb_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to EX stage
	     o_wb_DMemOut	: out std_logic_vector(31 downto 0); --Dmem output signal to WB stage
	     o_wb_ALUOut	: out std_logic_vector(31 downto 0)); --ALU output signal to WB stage

end regMEM_WB;

architecture structural of regMEM_WB is
  component register_N is
   generic(N : integer := 32);
   port(i_CLK        : in std_logic;     		-- Clock input
       i_RST        : in std_logic;    			-- Reset input
       i_WE         : in std_logic;     		-- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);-- Data value input Nbit
       o_Q          : out std_logic_vector(N-1 downto 0));-- Data value output Nbit

  end component;

 component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
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

component and2t1_N is
	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	port(i_A         : in std_logic_vector(N-1 downto 0);
		 i_B         : in std_logic_vector(N-1 downto 0);
		 o_F         : out std_logic_vector(N-1 downto 0));
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
signal 	s_stall_and : std_logic;
signal 	s_stall_not : std_logic;

signal s_RegWrite_flush : std_logic;
signal s_Halt_flush : std_logic;

signal s_Reg_Rd_flush : std_logic_vector(4 downto 0);
signal s_MemtoReg_flush : std_logic_vector(1 downto 0);
signal s_Pc8_flush : std_logic_vector(31 downto 0);
signal s_DMemOut_flush : std_logic_vector(31 downto 0);
signal s_ALUOut_flush : std_logic_vector(31 downto 0);

begin
 Stall_N: invg port map(i_stall, s_stall_not);
 Stall_A: andg2 port map(i_WE, s_stall_not, s_stall_and);

 RegWrite_flush: flush_1 port map(i_flush, mem_RegWrite, s_RegWrite_flush);
 MEM_WB_RegWrite_reg: dffg port map(i_CLK, i_RST, s_stall_and, mem_RegWrite, o_wb_RegWrite);

 Halt_flush: flush_1 port map(i_flush, mem_Halt, s_Halt_flush);
 MEM_WB_Halt_reg: dffg port map(i_CLK, i_RST, s_stall_and, s_Halt_flush, o_wb_Halt);

 Reg_Rd_flush: flush_N generic map(5) port map(i_flush, mem_Reg_Rd, s_Reg_Rd_flush);
 MEM_WB_Reg_Rd_reg: register_N generic map(5) port map(i_CLK, i_RST, s_stall_and, s_Reg_Rd_flush, o_wb_Reg_Rd);

 MemtoReg_flush: flush_N generic map(2) port map(i_flush, mem_MemtoReg, s_MemtoReg_flush);
 MEM_WB_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, s_stall_and, s_MemtoReg_flush, o_wb_MemtoReg);

 Pc8_flush: flush_N generic map(32) port map(i_flush, mem_Pc8, s_Pc8_flush);
 MEM_WB_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_Pc8_flush, o_wb_Pc8);

 DMemOut_flush: flush_N generic map(32) port map(i_flush, mem_DMemOut, s_DMemOut_flush);
 MEM_WB_DMemOut_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_DMemOut_flush, o_wb_DMemOut);

 ALUOut_flush: flush_N generic map(32) port map(i_flush, mem_ALUOut, s_ALUOut_flush);
 MEM_WB_ALUOut_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_ALUOut_flush, o_wb_ALUOut);

end structural;
