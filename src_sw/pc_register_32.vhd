-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- pc_register_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit register
--
--
-- NOTES:
-- 11/4/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity pc_register_32 is
  port(i_CLK        : in std_logic;     		-- Clock input
       i_RST        : in std_logic;    			-- Reset input
       i_WE         : in std_logic;     		-- Write enable input
       i_D          : in std_logic_vector(32-1 downto 0);-- Data value input Nbit
       o_Q          : out std_logic_vector(32-1 downto 0));-- Data value output Nbit

end pc_register_32;

architecture structural of pc_register_32 is

  component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

  component mux2t1_N is
	  generic(N : integer := 16); 
	  port(i_S          : in std_logic;
	       i_D0         : in std_logic_vector(N-1 downto 0);
	       i_D1         : in std_logic_vector(N-1 downto 0);
	       o_O          : out std_logic_vector(N-1 downto 0));
  end component;
  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

  signal s_load : std_logic_vector(32-1 downto 0);
  signal s_We : std_logic;
begin
  resetMux0: mux2t1_N generic map (32) port map (i_RST, i_D, x"00400000", s_load);
  writeMux0: mux2t1 port map (i_RST, i_WE, '1', s_We);

  G_N_Register: for i in 0 to 32-1 generate

    r1: dffg port map(i_CLK, '0', s_We, s_load(i), o_Q(i));

  end generate G_N_Register;

end structural;


