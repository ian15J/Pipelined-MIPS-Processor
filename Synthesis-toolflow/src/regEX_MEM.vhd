-------------------------------------------------------------------------
-- Yohan Bopearatchy & Bailey G
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- regEX_MEM.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of EX to MEM pipeline registers
-- 
--
--
-- NOTES:
-- 11/11/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regEX_MEM is
	port(i_CLK			: in std_logic; --Clock
		i_RST			: in std_logic; --Reset
		i_WE			: in std_logic; --Write enable
		i_flush			: in std_logic;	-- flush
      		i_stall			: in std_logic; -- stall
		ex_MemtoReg		: in std_logic_vector(1 downto 0); --MemtoReg control signal from EX stage
		ex_Reg_Rd		: in std_logic_vector(4 downto 0); --Reg_Rd signal from EX stage
		ex_RegWrite		: in std_logic; --RegWrite control signal from EX stage
		ex_DMemWr		: in std_logic; --Dmem write back signal from EX stage
		ex_Halt			: in std_logic; --Halt signal from EX stage
		ex_DmemRead		: in std_logic;
		ex_Pc8			: in std_logic_vector(31 downto 0); --PC + 8 from EX stage
		ex_ALUOut		: in std_logic_vector(31 downto 0); --ALU output from EX stage
		ex_ReadReg1		: in std_logic_vector(31 downto 0); --Register output from EX stage
		o_mem_MemtoReg		: out std_logic_vector(1 downto 0); --MemtoReg control signal to MEM stage
		o_mem_Reg_Rd		: out std_logic_vector(4 downto 0); --Reg_Rd signal to MEM stage
		o_mem_RegWrite		: out std_logic; --RegWrite control signal to MEM stage
		o_mem_DMemWr		: out std_logic; --Dmem write back signal to MEM stage
		o_mem_Halt		: out std_logic; --Halt signal to MEM stage
		o_mem_DmemRead		: out std_logic;
	   	o_mem_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to MEM stage
		o_mem_ALUOut		: out std_logic_vector(31 downto 0); --ALU output signal to MEM stage
		o_mem_ReadReg1		: out std_logic_vector(31 downto 0)); --Register output signal to MEM stage

end regEX_MEM;

architecture structural of regEX_MEM is

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

-- Signals
signal 	s_stall_and : std_logic;
signal 	s_stall_not : std_logic;

signal  s_RegWrite_flush : std_logic;
signal  s_DMemWr_flush : std_logic;
signal  s_Halt_flush : std_logic;
signal  s_DmemRead_flush : std_logic;
signal  s_Reg_Rd_flush : std_logic_vector(4 downto 0);
signal  s_MemtoReg_flush : std_logic_vector(1 downto 0);
signal  s_Pc8_flush : std_logic_vector(31 downto 0);
signal  s_ALUOut_flush : std_logic_vector(31 downto 0);
signal  s_ReadReg1_flush : std_logic_vector(31 downto 0);


begin
  Stall_N: invg port map(i_stall, s_stall_not);
  Stall_A: andg2 port map(i_WE, s_stall_not, s_stall_and);

  RegWrite_flush: flush_1 port map(i_flush, ex_RegWrite, s_RegWrite_flush);
  EX_MEM_RegWrite_reg: dffg port map(i_CLK, i_RST, s_stall_and, s_RegWrite_flush, o_mem_RegWrite);

  DMemWr_flush: flush_1 port map(i_flush, ex_DMemWr, s_DmemWr_flush);
  EX_MEM_DMemWr_reg: dffg port map(i_CLK, i_RST, s_stall_and, s_DmemWr_flush, o_mem_DMemWr);

  Halt_flush: flush_1 port map(i_flush, ex_Halt, s_Halt_flush);
  EX_MEM_Halt_reg: dffg port map(i_CLK, i_RST, s_stall_and, s_Halt_flush, o_mem_Halt);

  DmemRead_flush: flush_1 port map(i_flush, ex_DmemRead, s_DmemRead_flush);
  EX_MEM_DmemRead_reg: dffg port map(i_CLK, i_RST, s_stall_and, s_DmemRead_flush, o_mem_DmemRead);

  Reg_Rd_flush: flush_N generic map(5) port map(i_flush, ex_Reg_Rd, s_Reg_Rd_flush);
  EX_MEM_Reg_Rd_reg: register_N generic map(5) port map(i_CLK, i_RST, s_stall_and, s_Reg_Rd_flush, o_mem_Reg_Rd);

  MemtoReg_flush: flush_N generic map(2) port map(i_flush, ex_MemtoReg, s_MemtoReg_flush);
  EX_MEM_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, s_stall_and, s_MemtoReg_flush, o_mem_MemtoReg);

  Pc8_flush: flush_N generic map(32) port map(i_flush, ex_Pc8, s_Pc8_flush);
  EX_MEM_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_Pc8_flush, o_mem_Pc8);

  ALUOut_flush: flush_N generic map(32) port map(i_flush, ex_ALUOut, s_ALUOut_flush);
  EX_MEM_ALUOut_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_ALUOut_flush, o_mem_ALUOut);

  ReadReg1_flush: flush_N generic map(32) port map(i_flush, ex_ReadReg1, s_ReadReg1_flush);
  EX_MEM_ReadReg1_reg: register_N generic map(32) port map(i_CLK, i_RST, s_stall_and, s_ReadReg1_flush, o_mem_ReadReg1);
  

end structural;
