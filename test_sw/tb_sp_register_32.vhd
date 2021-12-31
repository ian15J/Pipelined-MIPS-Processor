-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_sp_register_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 32 bit register
--
-- NOTES:
-- 11/4/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_sp_register_32 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_sp_register_32;

architecture behavior of tb_sp_register_32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component sp_register_32
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(32-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(32-1 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the reg component.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_D : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_Q : std_logic_vector(32-1 downto 0):= (others => '0');

begin

  DUT: sp_register_32 port map(s_CLK, s_RST, s_WE, s_D, s_Q);

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
    -- Reset the FF
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= x"00000000";
    wait for cCLK_PER;

    -- Store 0x"0F0F0F0F"
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"0F0F0F0F";
    wait for cCLK_PER;  

    -- Keep 0x"0F0F0F0F"
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= x"00000000";
    wait for cCLK_PER;  

    -- Store 0x"00000000"    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"00000000";
    wait for cCLK_PER;  

    -- Keep '0'
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= x"FFFFFFFF";
    wait for cCLK_PER;  

    wait;
  end process;
  
end behavior;
