-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- full_add.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder using structural VHDL.
--
--
-- NOTES:
-- 9/3/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity full_add is
    port(i_C                  : in std_logic;
         i_A                  : in std_logic;
         i_B                  : in std_logic;
         o_S                  : out std_logic;
	 o_C		      : out std_logic);
end full_add;

--define architecture
architecture structural of full_add is
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

	-- 2 input xor gate
	component xorg2 is
		port(i_A          : in std_logic;
       		     i_B          : in std_logic;
       		     o_F          : out std_logic);
	end component;

	--intermidiate signals
	signal xor1_out, A1_out, A2_out : std_Logic;
begin
	xor1: xorg2 port map(i_A, i_B, xor1_out);
	xor2: xorg2 port map(xor1_out, i_C, o_S);
	a1: andg2 port map(xor1_out, i_C, A1_out);
	a2: andg2 port map(i_A, i_B, A2_out);
	o1: org2 port map(A1_out, A2_out, o_C);

end structural;
