-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_flush_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for flush_1
--
-- NOTES:
-- 12/9/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_flush_1 is
  generic(gCLK_HPER   : time := 20 ns);
end tb_flush_1;

architecture behavior of tb_flush_1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component flush_1 is
	  port(
		i_flush : in std_logic;
		i_D: in std_logic;
		andOut: out std_logic);	

  end component;

  -- Temporary signals to connect to the reg component.
  signal s_CLK, s_flush, s_D, s_andOut: std_logic;
  

begin

  DUT: flush_1 
  port map (s_flush, s_D, s_andOut);

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
   
    s_flush <= '0';
    s_D <= '0';
    wait for cCLK_PER;
    s_flush <= '0';
    s_D <= '1';
    wait for cCLK_PER;
    s_flush <= '1';
    s_D <= '0';
    wait for cCLK_PER;
    s_flush <= '1';
    s_D <= '1';
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;
