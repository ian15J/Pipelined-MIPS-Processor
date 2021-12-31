-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N bit register
--
--
-- NOTES:
-- 9/16/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     		-- Clock input
       i_RST        : in std_logic;    			-- Reset input
       i_WE         : in std_logic;     		-- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);-- Data value input Nbit
       o_Q          : out std_logic_vector(N-1 downto 0));-- Data value output Nbit

end register_N;

architecture structural of register_N is

  component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

begin

  G_N_Register: for i in 0 to N-1 generate

    r1: dffg port map(i_CLK, i_RST, i_WE, i_D(i), o_Q(i));

  end generate G_N_Register;

end structural;


