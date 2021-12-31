-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- mux4t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 4:1 with N bit MUX
--
--
-- NOTES:
-- 10/28/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1_N is
    generic(N : integer := 32);
    port(i_S                  : in std_logic_vector(2-1 downto 0);
         i_D0                 : in std_logic_vector(N-1 downto 0);
         i_D1                 : in std_logic_vector(N-1 downto 0);
         i_D2                 : in std_logic_vector(N-1 downto 0);
         i_D3                 : in std_logic_vector(N-1 downto 0);
         o_O                  : out std_logic_vector(N-1 downto 0));
end mux4t1_N;

--define architecture
architecture dataflow of mux4t1_N is
	
begin
	with i_S select
	  o_O <= 	i_D0 when "00",
			i_D1 when "01",
			i_D2 when "10",
			i_D3 when "11",
			i_D0 when others;
end dataflow;
