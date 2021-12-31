-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- mux8t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 8:1 MUX
--
--
-- NOTES:
-- 10/14/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux8t1 is
    generic(N : integer := 32);
    port(i_S                  : in std_logic_vector(3-1 downto 0);
         i_D0                 : in std_logic_vector(N-1 downto 0);
         i_D1                 : in std_logic_vector(N-1 downto 0);
         i_D2                 : in std_logic_vector(N-1 downto 0);
         i_D3                 : in std_logic_vector(N-1 downto 0);
         i_D4                 : in std_logic_vector(N-1 downto 0);
         i_D5                 : in std_logic_vector(N-1 downto 0);
         i_D6                 : in std_logic_vector(N-1 downto 0);
         i_D7                 : in std_logic_vector(N-1 downto 0);
         o_O                  : out std_logic_vector(N-1 downto 0));
end mux8t1;

--define architecture
architecture dataflow of mux8t1 is
	
begin
	with i_S select
	  o_O <= 	i_D0 when "000",
			i_D1 when "001",
			i_D2 when "010",
			i_D3 when "011",
			i_D4 when "100",
			i_D5 when "101",
			i_D6 when "110",
			i_D7 when "111",
			i_D0 when others;
	
end dataflow;
