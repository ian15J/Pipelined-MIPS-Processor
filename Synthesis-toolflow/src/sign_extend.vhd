-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- sign_extend.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a sign extender
--
--
-- NOTES:
-- 9/30/21
-- 10/7/21 updated Ian Johnson
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extend is 
  port(i_sign     : in std_logic;-- sign control
       i_imm      : in std_logic_vector(16-1 downto 0);-- immediate input
       o_ext      : out std_logic_vector(32-1 downto 0));-- extended output

end sign_extend;

architecture structural of sign_extend is
	component andg2 is

	  port(i_A          : in std_logic;
	       i_B          : in std_logic;
	       o_F          : out std_logic);

	end component;
	--mux
	component mux2t1_N is
  	 generic(N : integer := 16);
  	  port(i_S     : in std_logic;
       	  i_D0         : in std_logic_vector(N-1 downto 0);
          i_D1         : in std_logic_vector(N-1 downto 0);
          o_O          : out std_logic_vector(N-1 downto 0));

	end component;
	signal zero : std_logic_vector(16-1 downto 0):= (others => '0');
	signal sign : std_logic_vector(16-1 downto 0);
	signal mux_out : std_logic_vector(16-1 downto 0);
begin
	sign <= (others => i_imm(15));
	mux0: mux2t1_N generic map(16)port map(i_sign, zero, sign, mux_out);
	o_ext <= mux_out & i_imm;

end structural;


