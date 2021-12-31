-------------------------------------------------------------------------
-- Yohan Bopearatchy
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

begin
 MEM_WB_RegWrite_reg: dffg port map(i_CLK, i_RST, i_WE, mem_RegWrite, o_wb_RegWrite);
 MEM_WB_Halt_reg: dffg port map(i_CLK, i_RST, i_WE, mem_Halt, o_wb_Halt);

 MEM_WB_Reg_Rd_reg: register_N generic map(5) port map(i_CLK, i_RST, i_WE, mem_Reg_Rd, o_wb_Reg_Rd);
 MEM_WB_MemtoReg_reg: register_N generic map(2) port map(i_CLK, i_RST, i_WE, mem_MemtoReg, o_wb_MemtoReg);
 MEM_WB_Pc8_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, mem_Pc8, o_wb_Pc8);
 MEM_WB_DMemOut_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, mem_DMemOut, o_wb_DMemOut);
 MEM_WB_ALUOut_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, mem_ALUOut, o_wb_ALUOut);

end structural;
