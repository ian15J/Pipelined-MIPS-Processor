-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- ALU_Control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a control unit for the ALU, changing ALUop into control signals
--
--
-- NOTES:
-- 10/9/21
-- 10/21/21 Updated Ian Johnson
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_Control is 
  port(i_ALUop       : in std_logic_vector(5-1 downto 0); 	-- input opcode
       o_hasOV	     : out std_logic; --wheither ALU produced an overflow
       o_shiftSrc    : out std_logic; --wheither Shifter gets shift amount or 16
       o_shiftLR     : out std_logic; --shifter L/R control
       o_shiftAr     : out std_logic; --shift aritmitic
       o_unSigned    : out std_logic; --wheither instruction is unsigned or not
       o_addSub      : out std_logic; --wheither add or subtract
       o_invZero     : out std_logic; --wheither bne or beq
       o_isNor       : out std_logic; --wheither nor
       o_ALUMuxCtl   : out std_logic_vector(3-1 downto 0)); --output mux control

end ALU_Control;

architecture dataflow of ALU_Control is

	signal s_master  : std_logic_vector(11-1 downto 0);

begin

	with i_ALUop select
		s_master <= 	"00000-0-000" when "00000", --sll
				"00100-0-000" when "00010", --srl
				"00110-0-000" when "00011", --sra
				"01000-0-000" when "00100", --lui
				"1---000-010" when "00101", --add
				"1---010-010" when "00110", --sub
				"0---0-0-011" when "00111", --and
				"0---0-00100" when "01000", --or
				"0---0-0-101" when "01001", --xor
				"0---0-01100" when "01010", --nor
				"0---010-110" when "01011", --slt
				"0---0-0-111" when "01100", --repl.qb
				"0---010-010" when "01101", --beq
				"0---011-010" when "01110", --bne
				"0---100-010" when "10101", --addu
				"0---110-010" when "10110", --subu
				"0---110-110" when "11011", --sltu
				"0---000-010" when others;
	o_hasOV <= s_master(10);
	o_shiftSrc <= s_master(9);
	o_shiftLR <= s_master(8);
	o_shiftAr <= s_master(7);
	o_unSigned <= s_master(6);
	o_addSub <= s_master(5);
	o_invZero <= s_master(4);
	o_isNor <= s_master(3);
	o_ALUMuxCtl <= s_master(2 downto 0);

end dataflow;


