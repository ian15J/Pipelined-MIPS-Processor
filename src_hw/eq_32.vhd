-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- eq_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of equals logic
--
-- NOTES:
-- 11/27/21 - Ian Johnson
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity eq_32 is
    port(i_invEq : in std_logic; 			--Whether to invert the output or no
	 i_D0 : in std_logic_vector(31 downto 0);	--Value 1
         i_D1: in std_logic_vector(31 downto 0); 	--Value 2
	 o_eq: out std_logic);				--output 1 if D0 = D1

end eq_32;


architecture structural of eq_32 is

	component xor2t1_N is
	  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	  port(i_A         : in std_logic_vector(N-1 downto 0);
	       i_B         : in std_logic_vector(N-1 downto 0);
	       o_F         : out std_logic_vector(N-1 downto 0));

	end component;

	component nor32t1 is
	  port(i_A         : in std_logic_vector(32-1 downto 0);
	       o_F         : out std_logic);

	end component;

	component xorg2 is
	    port(i_A          : in std_logic;
		 i_B          : in std_logic;
		 o_F          : out std_logic);

	end component;

	signal xor_out : std_logic_vector(31 downto 0);
	signal s_eq : std_logic;
    
    begin

	Xor0: xor2t1_N generic map(32) port map (i_D0, i_D1, xor_out);
	nor0: nor32t1 port map (xor_out, s_eq);
	Xor1: xorg2 port map (s_eq, i_invEq, o_eq);

end structural;
