-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- invg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an inverter with N bits using structural VHDL.
--
-- NOTES:
-- 9/3/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity invg_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_A                 : in std_logic_vector(N-1 downto 0);
         o_F                 : out std_logic_vector(N-1 downto 0));
end invg_N;

--define architecture
architecture structural of invg_N is
	-- 1 input Not gate
	component invg is
		port(i_A          : in std_logic;
       		     o_F          : out std_logic);
	end component;

	--intermidiate signals
begin
	G_NBit_INVG: for i in 0 to N-1 generate
		invg1: invg port map (i_A => i_A(i), --ith index of A hooked up to instance of an inverter
			 	      o_F => o_F(i));
	end generate G_NBit_INVG;

end structural;
