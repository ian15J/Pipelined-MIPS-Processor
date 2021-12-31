-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_repl..vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the repl component
--
-- NOTES:
-- 10/16/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_repl is
  generic(gCLK_HPER   : time := 50 ns);
end tb_repl;

architecture behavior of tb_repl is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component repl is
    port(i_repl      : in std_logic_vector(8-1 downto 0);
         o_F         : out std_logic_vector(32-1 downto 0));

  end component;

  signal s_CLK : std_logic;

  -- Temporary signals
  signal s_repl   : std_logic_vector(8-1 downto 0):= (others => '0');
  signal s_F   : std_logic_vector(32-1 downto 0);

begin

  DUT: repl  port map(s_repl, s_F);

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

    s_repl <= x"00";
    wait for cCLK_PER;
    --s_F <= 0x00000000
    s_repl <= x"04";
    wait for cCLK_PER;
    --s_F <= 0x04040404
    s_repl <= x"51";
    wait for cCLK_PER;
    --s_F <= 0x51515151
    s_repl <= x"FF";
    wait for cCLK_PER;
    --s_F <= 0xFFFFFFFF
    

    wait;
  end process;
  
end behavior;
