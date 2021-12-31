-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- full_add_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder with N bits using structural VHDL.
--
-- NOTES:
-- 9/3/21
-- 10/7/21 updated Ian Johnson
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity full_add_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32. with overflow flag
    port(i_C                 : in std_logic;
	 i_A                 : in std_logic_vector(N-1 downto 0);
	 i_B                 : in std_logic_vector(N-1 downto 0);
         o_S                 : out std_logic_vector(N-1 downto 0);
	 o_C                 : out std_logic;
	 o_OV                : out std_logic);
end full_add_N;

--define architecture
architecture structural of full_add_N is
	-- full adder
	component full_add is
		port(i_C                  : in std_logic;
         	     i_A                  : in std_logic;
         	     i_B                  : in std_logic;
         	     o_S                  : out std_logic;
	 	     o_C		  : out std_logic);
	end component;
	--xor gate
	component xorg2 is
	 	port(i_A     : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

	end component;

	--intermidiate signals
	signal c_carry : std_logic_vector(N downto 0);
begin
	c_carry(0) <= i_C;
	G_NBit_full_add: for i in 0 to N-1 generate
		fa1: full_add port map(i_C => c_carry(i),
         	     		       i_A => i_A(i),
         	    		       i_B => i_B(i),
         	     		       o_S => o_S(i),
	 	     		       o_C => c_carry(i+1));
	end generate G_NBit_full_add;
	xor0: xorg2 port map(c_carry(N), c_carry(N-1), o_OV);
	o_C <= c_carry(N);
	
end structural;
