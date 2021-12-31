-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_decoder5t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 5:32 decoder
--
-- NOTES:
-- 9/16/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder5t32 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_decoder5t32;

architecture behavior of tb_decoder5t32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component decoder5t32
    port(i_EN	    : in std_logic; --enable
         i_S          : in std_logic_vector(5-1 downto 0);-- decoder select
         o_Q          : out std_logic_vector(32-1 downto 0));-- decoder output
  end component;

  -- Temporary signals
  signal s_CLK : std_logic;
  signal s_EN  : std_logic;
  signal s_S   : std_logic_vector(5-1 downto 0):= (others => '0');
  signal s_Q   : std_logic_vector(32-1 downto 0):= (others => '0');

begin

  DUT: decoder5t32 port map(s_EN, s_S, s_Q);

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
    -- Test enable should be 0x00000000
    s_EN <= '0';
    s_S   <= "00001";
    wait for cCLK_PER;
    -- Test "00000" should be 0x00000001
    s_EN <= '1';
    s_S   <= "00000";
    wait for cCLK_PER;
    -- Test "00001" should be 0x00000002
    s_EN <= '1';
    s_S   <= "00001";
    wait for cCLK_PER;
    -- Test "00010" should be 0x00000004
    s_EN <= '1';
    s_S   <= "00010";
    wait for cCLK_PER;
    -- Test "01010" should be 0x00000400
    s_EN <= '1';
    s_S   <= "01010";
    wait for cCLK_PER;
    -- Test "11111" should be 0x80000000
    s_EN <= '1';
    s_S   <= "11111";
    wait for cCLK_PER;
    -- Test enable again should be 0x00000000
    s_EN <= '0';
    s_S   <= "11111";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
