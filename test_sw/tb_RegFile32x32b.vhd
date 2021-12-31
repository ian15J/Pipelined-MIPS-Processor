-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_RegFile32x32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 32 register file with 32 bit data lines
--
-- NOTES:
-- 9/17/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_RegFile32x32b is
  generic(gCLK_HPER   : time := 50 ns);
end tb_RegFile32x32b;

architecture behavior of tb_RegFile32x32b is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component RegFile32x32b
    port(i_rs : in std_logic_vector(4 downto 0); --read register 0
	 i_rt : in std_logic_vector(4 downto 0); --read register 1
	 i_rd : in std_logic_vector(4 downto 0); --write register
	 i_ld : in std_logic_vector(31 downto 0); --load data
	 i_CLK : in std_logic; --CLOCK
	 i_WE : in std_logic; --Write Enable
	 i_CLR : in std_logic; --CLEAR '1' is clear, '0' is hold
	 o_RD0 : out std_logic_vector(31 downto 0); --load data
	 o_RD1 : out std_logic_vector(31 downto 0)); --load data
  end component;

  -- Temporary signals
  signal s_rs : std_logic_vector(4 downto 0):= (others => '0'); --read register 0
  signal s_rt : std_logic_vector(4 downto 0):= (others => '0'); --read register 1
  signal s_rd : std_logic_vector(4 downto 0):= (others => '0'); --write register
  signal s_ld : std_logic_vector(31 downto 0):= (others => '0'); --load data
  signal s_WE : std_logic  :='0'; --Write Enable
  signal s_CLR : std_logic :='0'; --CLEAR '1' is clear, '0' is hold
  signal s_RD0 : std_logic_vector(31 downto 0):= (others => '0'); --load data
  signal s_RD1 : std_logic_vector(31 downto 0):= (others => '0'); --load data
  signal s_CLK : std_logic; --CLOCK

begin

  DUT: RegFile32x32b port map(s_rs, s_rt, s_rd, s_ld, s_CLK, s_WE, s_CLR, s_RD0, s_RD1);

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

    -- Reset RegFile
	 s_rs <= "00000";  --read reg 0
	 s_rt <= "00001";  --read reg 1
	 s_rd <= "00000";  --write reg 0
	 s_ld <= x"FFFFFFFF";--test load
	 s_WE <= '0';     --don't write
	 s_CLR <= '1';	  --clear RegFile
    --s_RD0(reg0) and s_RD1(reg1) should be 0x00000000
    wait for cCLK_PER;
    -- test $zero holds constant 0x00000000 RegFile
	 s_rs <= "00000";  --read reg 0
	 s_rt <= "00001";  --read reg 1
	 s_rd <= "00000";  --write reg 0
	 s_ld <= x"FFFFFFFF";--test load
	 s_WE <= '1';      -- write
	 s_CLR <= '0';	  -- dont't clear
    --s_RD0(reg0) and s_RD1(reg1) should remain 0x00000000
    wait for cCLK_PER;
    -- test RegFile updates val
	 s_rs <= "00001";  --read reg 1
	 s_rt <= "00010";  --read reg 2
	 s_rd <= "00001";  --write reg 1
	 s_ld <= x"FFFFFFFF";--test load
	 s_WE <= '1';      --write
	 s_CLR <= '0';	  --don't clear
    --s_RD0(reg1) should be 0xFFFFFFFF and s_RD1(reg2) should be 0x00000000
    wait for cCLK_PER;
    -- test RegFile holds val
	 s_rs <= "00001";  --read reg 1
	 s_rt <= "00010";  --read reg 2
	 s_rd <= "00001";  --write reg 1
	 s_ld <= x"0F0F0F0F";--test load
	 s_WE <= '0';      --don't write
	 s_CLR <= '0';	  --don't clear
    --s_RD0(reg1) should hold at 0xFFFFFFFF and s_RD1(reg2) should hold at 0x00000000
    wait for cCLK_PER;
    -- test RegFile updates val without reading the register
	 s_rs <= "00001";  --read reg 1
	 s_rt <= "00000";  --read reg 0
	 s_rd <= "00010";  --write reg 1
	 s_ld <= x"0F0F0F0F";--test load
	 s_WE <= '1';      --write
	 s_CLR <= '0';	  --don't clear
    --s_RD0(reg1) should be 0xFFFFFFFF and s_RD1(reg0) should be 0x00000000
    wait for cCLK_PER;
    -- test read works before clock pulse with writing
	 s_rs <= "00001";  --read reg 1
	 s_rt <= "00010";  --read reg 0
	 s_rd <= "00010";  --write reg 1
	 s_ld <= x"F0F0F0F0";--test load
	 s_WE <= '1';      --don't write
	 s_CLR <= '0';	  --don't clear
    --s_RD0(reg1) should be 0xFFFFFFFF and s_RD1(reg2) should be 0x0F0F0F0F before rising edge of clock pulse and then 0x0F0F0F0F
    wait for cCLK_PER;
    -- Reset RegFile
	 s_rs <= "00001";  --read reg 1
	 s_rt <= "00010";  --read reg 2
	 s_rd <= "00001";  --write reg 1
	 s_ld <= x"F0F0F0F0";--test load
	 s_WE <= '0';      --don't write
	 s_CLR <= '1';	  --clear RegFile
    --s_RD0(reg1) and s_RD1(reg2) should be reset to 0x00000000 before rising edge of clock pulse
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
