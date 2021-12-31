-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1
-- Mux using structural VHDL.
--
--
-- NOTES:
-- 9/2/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
end mux2t1;

--define architecture
architecture structural of mux2t1 is
	-- 2 input Or gate
	component org2 is
		port(i_A          : in std_logic;
		     i_B          : in std_logic;
       		     o_F          : out std_logic);
	end component;
	
	-- 2 input And gate
	component andg2 is
		port(i_A          : in std_logic;
       		     i_B          : in std_logic;
       		     o_F          : out std_logic);
	end component;

	-- 1 input Not gate
	component invg is
		port(i_A          : in std_logic;
       		     o_F          : out std_logic);
	end component;

	--intermidiate signals
	signal A1_out, A2_out, not1_out : std_Logic;
begin
	n1: invg port map(i_S, not1_out);
	a1: andg2 port map(not1_out, i_D0, A1_out);
	a2: andg2 port map(i_S, i_D1, A2_out);
	o1: org2 port map(A1_out, A2_out, o_O);

end structural;
