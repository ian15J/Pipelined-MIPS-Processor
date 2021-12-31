-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a control unit to set dataflow control bits
--
--
-- NOTES:
-- 10/9/21
-- 10/16/21 Updated Ian Johnson
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is 
 port(i_Op       : in std_logic_vector(6-1 downto 0); 	-- input opcode
       i_Funct    : in std_logic_vector(6-1 downto 0);	-- input function
       o_Halt	  : out std_logic;			-- Halt signal
       o_ALUsrc   : out std_logic;			-- output for ALU source, 0 for B, 1 for Imm
       o_SignExt  : out std_logic;			-- output for imm sign extend, 0 for zero-extend, 1 for sign-extend
       o_ALUop	  : out std_logic_vector(5-1 downto 0);	-- output for ALU opcode
       o_MemToReg : out std_logic_vector(2-1 downto 0); -- output whether reg writes ALU, Dmem, PC, or repl.qb
       s_DMemWr   : out std_logic;			-- whether dmem writes or not
       s_RegWr	  : out std_logic;			-- whether RegFile writes or not
       o_branch   : out std_logic;			-- whether branch instruction or not
       o_jump     : out std_logic_vector(2-1 downto 0);	-- whether jump instruction or not
       o_RegDst   : out std_logic_vector(2-1 downto 0); -- output whether RegFile dest input is rt, rd, or 31
       o_invEq	  : out std_logic;			-- output whether beq or bne for conditional logic
       o_pcSrc    : out std_logic;			-- output whether PC gets PC+4 or new address
       o_DmemRead : out std_logic);			-- output if dmem is read from

end control_unit;

architecture dataflow of control_unit is

	signal s_ALUop  : std_logic_vector(5-1 downto 0);
	signal s_MemToReg : std_logic_vector(2-1 downto 0);
	signal s_ALUsrc : std_logic;
	signal s_s_DMemWr : std_logic;
	signal s_s_RegWr: std_logic;
	signal s_branch : std_logic;
	signal s_jump 	: std_logic_vector(2-1 downto 0);
	signal s_RegDst : std_logic_vector(2-1 downto 0);
	signal s_pcSrc 	: std_logic;
begin
	
	--Halt
	with i_Op select
		o_Halt <= 	'1' when "010100",
				'0' when others;

	--ALUsrc R
	with i_Funct select
		s_ALUsrc <= 	'-' when "001000",
				'0' when others;
	--ALUsrc
	with i_Op select
		o_ALUsrc <= 	'1' when "001000",
				'1' when "001001",
				'1' when "001100",
				'1' when "001111",
				'1' when "100011",
				'1' when "001110",
				'1' when "001101",
				'1' when "001010",
				'1' when "101011",
				'0' when "000100",
				'0' when "000101",
				'-' when "000010",
				'-' when "000011",
				'1' when "011111",
				s_ALUsrc when "000000",
				'0' when others;
	--sign extention
	with i_Op select
		o_SignExt <= 	'1' when "001000",
				'1' when "001001",
				'0' when "001100",
				'1' when "001111",
				'1' when "100011",
				'0' when "001110",
				'0' when "001101",
				'1' when "001010",
				'1' when "101011",
				'1' when "000100",
				'1' when "000101",
				'1' when "000010",
				'1' when "000011",
				'0' when "011111",
				'1' when "000000",
				'1' when others;
	--ALUop R
	with i_Funct select
		s_ALUop <= 	"00101" when "100000",--add
				"10101" when "100001",--addu
				"00111" when "100100",--and
				"01010" when "100111",--nor
				"01001" when "100110",--xor
				"01000" when "100101",--or
				"01011" when "101010",--slt
				"00000" when "000000",--sll
				"00010" when "000010",--srl
				"00011" when "000011",--sra
				"00110" when "100010",--sub
				"10110" when "100011",--subu
				"-----" when "001000",
				"00101" when others;
	--ALUop
	with i_Op select
		o_ALUop <= 	"00101" when "001000",--addi -> add
				"10101" when "001001",--addiu -> addu
				"00111" when "001100",--andi -> and
				"00100" when "001111",--lui
				"00101" when "100011",--lw -> add
				"01001" when "001110",--xori -> xor
				"01000" when "001101",--ori -> or
				"01011" when "001010",--slti ->slt
				"00101" when "101011",--sw -> add
				"01101" when "000100",--beq
				"01110" when "000101",--bne
				"-----" when "000010",
				"-----" when "000011",
				"01100" when "011111",
				s_ALUop when "000000",
				"00101" when others;


	--MemToReg R
	with i_Funct select
		s_MemToReg <= 	"--" when "001000",
				"00" when others;
	--MemToReg
	with i_Op select
		o_MemToReg <= 	"00" when "001000",
				"00" when "001001",
				"00" when "001100",
				"00" when "001111",
				"01" when "100011",
				"00" when "001110",
				"00" when "001101",
				"00" when "001010",
				"--" when "101011",
				"--" when "000100",
				"--" when "000101",
				"--" when "000010",
				"10" when "000011",
				"00" when "011111",
				s_MemToReg when "000000",
				"00" when others;

	--DMemWr R
	with i_Funct select
		s_s_DMemWr <= 	'0' when "001000",
				'0' when others;
	--DMemWr
	with i_Op select
		s_DMemWr <= 	'0' when "001000",
				'0' when "001001",
				'0' when "001100",
				'0' when "001111",
				'0' when "100011",
				'0' when "001110",
				'0' when "001101",
				'0' when "001010",
				'1' when "101011",
				'0' when "000100",
				'0' when "000101",
				'0' when "000010",
				'0' when "000011",
				'0' when "011111",
				s_s_DMemWr when "000000",
				'0' when others;
	--RegWr R
	with i_Funct select
		s_s_RegWr <= 	'0' when "001000",
				'1' when others;
	--RegWr
	with i_Op select
		s_RegWr <= 	'1' when "001000",
				'1' when "001001",
				'1' when "001100",
				'1' when "001111",
				'1' when "100011",
				'1' when "001110",
				'1' when "001101",
				'1' when "001010",
				'0' when "101011",
				'0' when "000100",
				'0' when "000101",
				'0' when "000010",
				'1' when "000011",
				'1' when "011111",
				s_s_RegWr when "000000",
				'0' when others;
	--branch R
	with i_Funct select
		s_branch <= 	'0' when "001000",
				'0' when others;
	--branch
	with i_Op select
		o_branch <= 	'0' when "001000",
				'0' when "001001",
				'0' when "001100",
				'0' when "001111",
				'0' when "100011",
				'0' when "001110",
				'0' when "001101",
				'0' when "001010",
				'0' when "101011",
				'1' when "000100",
				'1' when "000101",
				'0' when "000010",
				'0' when "000011",
				'0' when "011111",
				s_branch when "000000",
				'0' when others;
	--jump R
	with i_Funct select
		s_jump <= 	"10" when "001000",
				"00" when others;
	--jump
	with i_Op select
		o_jump <= 	"00" when "001000",
				"00" when "001001",
				"00" when "001100",
				"00" when "001111",
				"00" when "100011",
				"00" when "001110",
				"00" when "001101",
				"00" when "001010",
				"00" when "101011",
				"00" when "000100",
				"00" when "000101",
				"01" when "000010",
				"01" when "000011",
				"00" when "011111",
				s_jump when "000000",
				"00" when others;

	--RegDst R
	with i_Funct select
		s_RegDst <= 	"--" when "001000",
				"01" when others;
	--RegDst
	with i_Op select
		o_RegDst <= 	"00" when "001000",
				"00" when "001001",
				"00" when "001100",
				"00" when "001111",
				"00" when "100011",
				"00" when "001110",
				"00" when "001101",
				"00" when "001010",
				"--" when "101011",
				"--" when "000100",
				"--" when "000101",
				"--" when "000010",
				"10" when "000011",
				"01" when "011111",
				s_RegDst when "000000",
				"01" when others;
	--invEq
	with i_Op select 
		o_invEq <= 	'0' when "001000",
				'0' when "001001",
				'0' when "001100",
				'0' when "001111",
				'0' when "100011",
				'0' when "001110",
				'0' when "001101",
				'0' when "001010",
				'0' when "101011",
				'0' when "000100",
				'1' when "000101",
				'0' when "000010",
				'0' when "000011",
				'0' when "011111",
				'0' when "000000",
				'0' when others;

	--pcSrc R
	with i_Funct select
		s_pcSrc <= 	'1' when "001000",
				'0' when others;
	--pcSrc
	with i_Op select 
		o_pcSrc <= 	'0' when "001000",
				'0' when "001001",
				'0' when "001100",
				'0' when "001111",
				'0' when "100011",
				'0' when "001110",
				'0' when "001101",
				'0' when "001010",
				'0' when "101011",
				'1' when "000100",

				'1' when "000101",

				'1' when "000010",
				'1' when "000011",
				'0' when "011111",
				s_pcSrc when "000000",
				'0' when others;

	--DememRead
	with i_Op select 
		o_DmemRead <= 	'0' when "001000",
				'0' when "001001",
				'0' when "001100",
				'0' when "001111",
				'1' when "100011",
				'0' when "001110",
				'0' when "001101",
				'0' when "001010",
				'0' when "101011",
				'0' when "000100",

				'0' when "000101",

				'0' when "000010",
				'0' when "000011",
				'0' when "011111",
				'0' when "000000",
				'0' when others;



end dataflow;


