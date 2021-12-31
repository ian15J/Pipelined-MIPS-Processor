-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_eq.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for eq.vhd
--
-- NOTES:
-- 12/9/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_eq is
  generic(gCLK_HPER   : time := 20 ns);
end tb_eq;

architecture behavior of tb_eq is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component eq_32 is
    port(i_invEq : in std_logic; 			--Whether to invert the output or no
	 i_D0 : in std_logic_vector(31 downto 0);	--Value 1
         i_D1: in std_logic_vector(31 downto 0); 	--Value 2
	 o_eq: out std_logic);				--output 1 if D0 = D1

end component;

  -- Temporary signals to connect to the reg component.
  signal s_CLK : std_logic;
  signal s_invEq: std_logic;
  signal s_D0, s_D1 : std_logic_vector(31 downto 0);
  signal s_eq : std_logic;
  

begin

  DUT: eq_32 
  port map (s_invEq, s_D0, s_D1, s_eq);

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
   
    s_invEq <= '0';
    s_D0 <= x"00000000";
    s_D1 <= x"00000000";
    wait for cCLK_PER;
    s_invEq <= '0';
    s_D0 <= x"00000000";
    s_D1 <= x"00000001";
    wait for cCLK_PER;
    s_invEq <= '1';
    s_D0 <= x"00000000";
    s_D1 <= x"00000000";
    wait for cCLK_PER;
    s_invEq <= '1';
    s_D0 <= x"00000000";
    s_D1 <= x"00000001";
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;
