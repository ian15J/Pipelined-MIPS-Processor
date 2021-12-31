-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_nor32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 32 bit to 1 nor gate
--
-- NOTES:
-- 10/12/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_nor32t1 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_nor32t1;

architecture behavior of tb_nor32t1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component nor32t1 is
    port(i_A         : in std_logic_vector(32-1 downto 0);
         o_F         : out std_logic);

  end component;

  signal s_CLK : std_logic;

  -- Temporary signals
  signal s_A   : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_F   : std_logic;

begin

  DUT: nor32t1 port map(s_A, s_F);

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

    s_A <= x"00000000";
    wait for cCLK_PER;
    --s_F should be 1

    s_A <= x"01001010";
    wait for cCLK_PER;
    --s_F should be 0

    s_A <= x"00000000";
    wait for cCLK_PER;
    --s_F should be 1

    s_A <= x"00FFFFFF";
    wait for cCLK_PER;
    --s_F should be 0

    s_A <= x"FFF0FFF0";
    wait for cCLK_PER;
    --s_F should be 0

    wait;
  end process;
  
end behavior;
