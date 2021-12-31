-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a control unit
--
-- NOTES:
-- 10/9/21

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_unit is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control_unit;

architecture behavior of tb_control_unit is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
	
  component control_unit is
	port(i_Op       : in std_logic_vector(6-1 downto 0); 	-- input opcode
       i_Funct    : in std_logic_vector(6-1 downto 0);	-- input function
       o_ALUsrc   : out std_logic;			-- output for ALU source, 0 for B, 1 for Imm
       o_SignExt  : out std_logic;			-- output for imm sign extend, 0 for zero-extend, 1 for sign-extend
       o_ALUop	  : out std_logic_vector(5-1 downto 0);	-- output for ALU opcode
       o_MemToReg : out std_logic_vector(2-1 downto 0); -- output whether reg writes ALU, Dmem, PC, or repl.qb
       s_DMemWr   : out std_logic;			-- whether dmem writes or not
       s_RegWr	  : out std_logic;			-- whether RegFile writes or not
       o_branch   : out std_logic;			-- whether branch instruction or not
       o_jump     : out std_logic_vector(2-1 downto 0);	-- whether jump instruction or not
       o_RegDst   : out std_logic_vector(2-1 downto 0));-- output whether RegFile dest input is rt, rd, or 31

end component;
 
	signal s_CLK: std_logic;
  -- Temporary signals
	signal s_Op : std_logic_vector(6-1 downto 0);
	signal s_Funct : std_logic_vector(6-1 downto 0);
	signal s_ALUop  : std_logic_vector(5-1 downto 0);
	signal s_MemToReg : std_logic_vector(2-1 downto 0);
	signal s_SignExt: std_logic;
	signal s_ALUsrc : std_logic;
	signal s_DMemWr : std_logic;
	signal s_RegWr  : std_logic;
	signal s_branch : std_logic;
	signal s_jump 	: std_logic_vector(2-1 downto 0);
	signal s_RegDst : std_logic_vector(2-1 downto 0);

begin

  DUT: control_unit port map(s_Op, s_Funct, s_ALUsrc, s_SignExt, s_ALUop, s_MemToReg, s_DMemWr, s_RegWr, s_branch, s_jump, s_RegDst);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Test R type
    s_Op <= 	"000000";
    s_Funct <= 	"100000"; --add
    wait for cCLK_PER;

    -- Test R type
    s_Op <= 	"000000";
    s_Funct <= 	"000000"; --sll
    wait for cCLK_PER;

    -- Test lw type
    s_Op <= 	"100011";
    wait for cCLK_PER;
    -- Test sw type
    s_Op <= 	"101011";
    wait for cCLK_PER;
    -- Test beq type
    s_Op <= 	"000100";
    wait for cCLK_PER;
    -- Test j type
    s_Op <= 	"000010";
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;
