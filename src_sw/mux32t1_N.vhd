-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32:1 mux with N bit bus
--
--
-- NOTES:
-- 9/16/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_N is 
  generic(N : integer := 32);
  port(i_S          : in std_logic_vector(5-1 downto 0);-- mux select
       i_D0	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D1	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D2	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D3	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D4	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D5	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D6	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D7	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D8	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D9	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D10	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D11	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D12	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D13	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D14	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D15	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D16	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D17	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D18	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D19	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D20	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D21	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D22	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D23	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D24	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D25	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D26	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D27	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D28	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D29	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D30	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D31	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       o_Q          : out std_logic_vector(N-1 downto 0));-- mux output

end mux32t1_N;

architecture dataflow of mux32t1_N is

begin

	with i_S select
		o_Q <= i_D0 when "00000",
		       i_D1 when "00001",
		       i_D2 when "00010",
		       i_D3 when "00011",
		       i_D4 when "00100",
		       i_D5 when "00101",
		       i_D6 when "00110",
		       i_D7 when "00111",
		       i_D8 when "01000",
		       i_D9 when "01001",
		       i_D10 when "01010",
		       i_D11 when "01011",
		       i_D12 when "01100",
		       i_D13 when "01101",
		       i_D14 when "01110",
		       i_D15 when "01111",
		       i_D16 when "10000",
		       i_D17 when "10001",
		       i_D18 when "10010",
		       i_D19 when "10011",
		       i_D20 when "10100",
		       i_D21 when "10101",
		       i_D22 when "10110",
		       i_D23 when "10111",
		       i_D24 when "11000",
		       i_D25 when "11001",
		       i_D26 when "11010",
		       i_D27 when "11011",
		       i_D28 when "11100",
		       i_D29 when "11101",
		       i_D30 when "11110",
		       i_D31 when "11111",
		       i_D0 when others;

end dataflow;


