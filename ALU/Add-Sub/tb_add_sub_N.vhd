-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_add_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the add_sub_N unit.
--              
-- 09/03/2021
-- 10/7/21 updated Ian Johnson
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_add_sub_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_add_sub_N;

architecture mixed of tb_add_sub_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component add_sub_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(nAdd_Sub                 : in std_logic;
	 i_A                	  : in std_logic_vector(N-1 downto 0);
	 i_B               	  : in std_logic_vector(N-1 downto 0);
         o_S                 	  : out std_logic_vector(N-1 downto 0);
	 o_C                 	  : out std_logic;
	 o_OV                 	  : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal nAdd_Sub : std_logic := '0';
signal i_A   : std_logic_vector(31 downto 0) := (others => '0');
signal i_B   : std_logic_vector(31 downto 0) := (others => '0');
signal o_S   : std_logic_vector(31 downto 0);
signal o_C   : std_logic;
signal o_OV   : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.

  DUT0: add_sub_N generic map (32) port map(nAdd_Sub,i_A,i_B,o_S,o_C, o_OV);

  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    nAdd_Sub <= '0';

    i_A <= x"00000000"; --i_A = 0x00000000

    i_B <= x"00000001"; --i_B = 0x00000001
    wait for gCLK_HPER*2;
    --0x00000000 + 0x00000001 = 0x00000001
    --o_S should be 0x00000001, o_C = 0

    -- Test case 2:
    nAdd_Sub <= '0';

    i_A <= x"0F001000"; --i_A = 0x0F001000

    i_B <= x"0100F000"; --i_B = 0x0100F000
    wait for gCLK_HPER*2;
    --0x0F001000 + 0x0100F000 = 0x10010000
    --o_S should be 0x10010000, o_C = 0

    -- Test case 3:
    nAdd_Sub <= '0';

    i_A <= x"FFFFFFFF"; --i_A = 0xFFFFFFFF

    i_B <= x"00000001"; --i_B = 0x00000001
    wait for gCLK_HPER*2;
    --0xFFFFFFFF + 0x00000001 = 0x00000000
    -- -1 + 1 = 0
    --o_S should be 0x00000000, o_C = 1

    -- Test case 4:
    nAdd_Sub <= '1';

    i_A <= x"00001000"; --i_A = 0x00001000

    i_B <= x"00000001"; --i_B = 0x00000001
    wait for gCLK_HPER*2;
    --0x00001000 - 0x00000001 = 0x00000FFF
    --o_S should be 0x00000FFF, o_C = 1

-- Test case 5:
    nAdd_Sub <= '1';

    i_A <= x"FFFFFFFF"; --i_A = 0xFFFFFFFF

    i_B <= x"00000001"; --i_B = 0x00000001 	
    wait for gCLK_HPER*2;
    --0xFFFFFFFF - 0x00000001 = 0xFFFFFFF0
    -- -1 - 1 = -2
    --o_S should be 0xFFFFFFFE, o_C = 1
  end process;

end mixed;
