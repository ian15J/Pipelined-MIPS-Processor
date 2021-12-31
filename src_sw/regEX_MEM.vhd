-------------------------------------------------------------------------
-- Yohan Bopearatchy
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
		ex_MemtoReg		: in std_logic_vector(1 downto 0); --MemtoReg control signal from EX stage
		ex_Reg_Rd		: in std_logic_vector(4 downto 0); --Reg_Rd signal from EX stage
		ex_RegWrite		: in std_logic; --RegWrite control signal from EX stage
		ex_DMemWr		: in std_logic; --Dmem write back signal from EX stage
		ex_Halt			: in std_logic; --Halt signal from EX stage
		ex_Pc8			: in std_logic_vector(31 downto 0); --PC + 8 from EX stage
		ex_ALUOut		: in std_logic_vector(31 downto 0); --ALU output from EX stage
		ex_ReadReg1		: in std_logic_vector(31 downto 0); --Register output from EX stage
		o_mem_MemtoReg		: out std_logic_vector(1 downto 0); --MemtoReg control signal to MEM stage
		o_mem_Reg_Rd		: out std_logic_vector(4 downto 0); --Reg_Rd signal to MEM stage
		o_mem_RegWrite		: out std_logic; --RegWrite control signal to MEM stage
		o_mem_DMemWr		: out std_logic; --Dmem write back signal to MEM stage
		o_mem_Halt		: out std_logic; --Halt signal to MEM stage
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

begin
  EX_MEM_RegWrite_reg: dffg port map(i_CLK, i_RST, i_WE, ex_RegWrite, o_mem_RegWrite);
  EX_MEM_DMemWr_reg: dffg port map(i_CLK, i_RST, i_WE, ex_DMemWr, o_mem_DMemWr);
  EX_MEM_Halt_reg: dffg port map(i_CLK, i_RST, i_WE, ex_Halt, o_mem_Halt);

  EX_MEM_Reg_Rd_reg: register_N generic map(5) port map(i_CLK, i_RST, i_WE, ex_Reg_Rd, o_mem_Reg_Rd);
  EX_MEM_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, i_WE, ex_MemtoReg, o_mem_MemtoReg);
  EX_MEM_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, ex_Pc8, o_mem_Pc8);
  EX_MEM_ALUOut_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, ex_ALUOut, o_mem_ALUOut);
  EX_MEM_ReadReg1_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, ex_ReadReg1, o_mem_ReadReg1);
  

end structural;
