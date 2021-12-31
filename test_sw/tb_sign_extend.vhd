-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_sign_extend.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a sign extender
--
-- NOTES:
-- 9/30/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_sign_extend is
  generic(gCLK_HPER   : time := 50 ns);
end tb_sign_extend;

architecture behavior of tb_sign_extend is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


 component sign_extend is 
  port(i_sign     : in std_logic;-- sign control
       i_imm      : in std_logic_vector(16-1 downto 0);-- immediate input
       o_ext      : out std_logic_vector(32-1 downto 0));-- extended output

end component;

  -- Temporary signals
  signal s_CLK : std_logic;
  signal s_sign : std_logic := '0';
  signal s_imm : std_logic_vector(16-1 downto 0):= (others => '0');
  signal s_ext : std_logic_vector(32-1 downto 0):= (others => '0');

begin

  DUT: sign_extend port map(s_sign, s_imm, s_ext);

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
    -- Test sign 0 on 0x0000
    s_sign <= '0';
    s_imm <= x"0000";
    -- should be 0x00000000
    wait for cCLK_PER;
    -- Test sign 0 on 0x0110
    s_sign <= '0';
    s_imm <= x"0110";
    -- should be 0x00000110
    wait for cCLK_PER;
    -- Test sign 1 on 0x0110
    s_sign <= '1';
    s_imm <= x"0110";
    -- should be 0x00000110
    wait for cCLK_PER;
    -- Test sign 1 on 0xFFFF
    s_sign <= '1';
    s_imm <= x"FFFF";
    -- should be 0xFFFFFFFF
    wait for cCLK_PER;
    -- Test sign 1 on 0x8000
    s_sign <= '1';
    s_imm <= x"8000";
    -- should be 0xFFFF8000
    wait for cCLK_PER;
    wait;
  end process;
  
end behavior;
