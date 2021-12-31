-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- slt_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a slt component, where it determines if A was less than B in the ALU
--
-- NOTES:
-- 10/16/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity slt_N is
  generic(N : integer := 32);
  port(i_unSign    : in std_logic;
       i_Sub       : in std_logic_vector(N-1 downto 0);
       i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F         : out std_logic_vector(N-1 downto 0));

end slt_N;

architecture dataflow of slt_N is

signal zero : std_logic_vector(N-2 downto 0) := (others => '0');
signal test : std_logic_vector(2-1 downto 0) := (others => '0');

begin
	test <= i_A(N-1) & i_B(N-1);
	with test select
		o_F <= zero & (i_Sub(N-1)) 		when "00",
		       zero & (('0') xor i_unSign) 	when "01",
		       zero & (('1') xor i_unSign) 	when "10",
		       zero & (i_Sub(N-1)) 		when "11",
		       zero & '0'			when others;
 
end dataflow;
