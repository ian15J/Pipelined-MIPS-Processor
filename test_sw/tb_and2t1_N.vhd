-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_and2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a N bit and gate
--
-- NOTES:
-- 10/12/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_and2t1_N is
  generic(gCLK_HPER   : time := 50 ns);
end tb_and2t1_N;

architecture behavior of tb_and2t1_N is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component and2t1_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_A         : in std_logic_vector(N-1 downto 0);
         i_B         : in std_logic_vector(N-1 downto 0);
         o_F         : out std_logic_vector(N-1 downto 0));

  end component;

  signal s_CLK : std_logic;

  -- Temporary signals
  signal s_A   : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_B   : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_F   : std_logic_vector(32-1 downto 0);

begin

  DUT: and2t1_N generic map (32) port map(s_A, s_B, s_F);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    --s_F should be 0x0000 0000
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_F should be 0x0000 0000
    s_A <= x"01001010";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_F should be 0x0000 0000
    s_A <= x"00000000";
    s_B <= x"FFFFFFFF";
    wait for cCLK_PER;
    --s_F should be 0x0000 0101
    s_A <= x"00FFFFFF";
    s_B <= x"7F000101";
    wait for cCLK_PER;
    --s_F should be 0x7650 3210
    s_A <= x"FFF0FFF0";
    s_B <= x"76543210";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
