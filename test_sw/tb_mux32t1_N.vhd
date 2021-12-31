-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 31:1 mux with N bit data lines
--
-- NOTES:
-- 9/16/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32t1_N is
  generic(gCLK_HPER   : time := 50 ns);
end tb_mux32t1_N;

architecture behavior of tb_mux32t1_N is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


 component mux32t1_N
  generic(N : integer := 32);
  port(i_S          : in std_logic_vector(5-1 downto 0);-- mux select
       i_D0	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D1	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D2	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D3	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D4	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D5	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D6	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D7	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D8	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D9	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D10	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D11	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D12	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D13	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D14	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D15	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D16	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D17	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D18	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D19	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D20	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D21	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D22	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D23	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D24	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D25	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D26	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D27	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D28	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D29	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D30	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       i_D31	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
       o_Q          : out std_logic_vector(N-1 downto 0));-- mux output
 end component;

  -- Temporary signals
  type i_arr is array(31 downto 0)of std_logic_vector(31 downto 0);
  signal s_CLK : std_logic;
  signal s_S : std_logic_vector(5-1 downto 0):= (others => '0');
  signal s_D : i_arr := (others => (others => '0'));
  signal s_Q : std_logic_vector(32-1 downto 0):= (others => '0');

begin

  DUT: mux32t1_N generic map(32) port map(s_S, s_D(0), s_D(1), s_D(2), s_D(3), s_D(4), s_D(5), s_D(6), s_D(7), 
					  s_D(8), s_D(9), s_D(10), s_D(11), s_D(12), s_D(13), s_D(14), s_D(15), s_D(16),
					  s_D(17), s_D(18), s_D(19), s_D(20), s_D(21), s_D(22), s_D(23), s_D(24), s_D(25),
					  s_D(26), s_D(27), s_D(28), s_D(29), s_D(30), s_D(31), s_Q);

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
    -- Test s_D0 should be 0x00000000
    s_S   <= "00000";
    wait for cCLK_PER;
    -- Test s_D1 should be 0x000000F0
    s_D(1) <= x"000000F0";
    s_S   <= "00001";
    wait for cCLK_PER;
    -- Test s_D2 should be 0xFFFFFFFF
    s_D(2) <= x"FFFFFFFF";
    s_S   <= "00010";
    wait for cCLK_PER;
    -- Test s_D1 again should be 0x000000F0
    s_S   <= "00001";
    wait for cCLK_PER;
    -- Test "11111" should be 0xFFF00FFF
    s_D(31) <= x"FFF00FFF";
    s_S   <= "11111";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
