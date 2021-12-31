-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb2_add_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the second testbench for the add_sub_N unit.
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
entity tb2_add_sub_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb2_add_sub_N;

architecture mixed of tb2_add_sub_N is

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
signal i_A   : std_logic_vector(3 downto 0) := (others => '0');
signal i_B   : std_logic_vector(3 downto 0) := (others => '0');
signal o_S   : std_logic_vector(3 downto 0);
signal o_C   : std_logic;
signal o_OV   : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.

  DUT0: add_sub_N generic map (4) port map(nAdd_Sub,i_A,i_B,o_S,o_C, o_OV);

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

    i_A <= x"6"; --i_A = 0x6 0b0110

    i_B <= x"7"; --i_B = 0x7 0b0111  1101
    wait for gCLK_HPER*2;
    -- 6+7 = overflow
    --o_S should be 0xD, o_C = 0

    -- Test case 2:
    nAdd_Sub <= '1';

    i_A <= x"6"; --i_A = 0x6
			 
    i_B <= x"7"; --i_B = 0x7 
    wait for gCLK_HPER*2;
    --6-7 = -1
    --o_S should be 0xF, o_C = 0

    -- Test case 3:
    nAdd_Sub <= '0';

    i_A <= x"9"; --i_A = 0xF 0b1001

    i_B <= x"4"; --i_B = 0x4 0b0100 1101 
    wait for gCLK_HPER*2;
    -- -7 + 4 = -3
    --o_S should be 0xD, o_C = 0

    -- Test case 4:
    nAdd_Sub <= '1';

    i_A <= x"9"; --i_A = 0x9 0b1001

    i_B <= x"1"; --i_B = 0x1 0b0001  1 1000
    wait for gCLK_HPER*2;
    -- -7 - 1 = -8
    --o_S should be 0x8, o_C = 1

    -- Test case 5:
    nAdd_Sub <= '1';

    i_A <= x"9"; --i_A = 0x9 0b0 1001

    i_B <= x"2"; --i_B = 0x1 0b0010  1 1110 0111
    wait for gCLK_HPER*2;
    -- -7 - 2 = overflow
    --o_S should be 0x7, o_C = 1

    -- Test case 6:
    nAdd_Sub <= '1';

    i_A <= x"8"; --i_A = 0x8 0b0 1000

    i_B <= x"8"; --i_B = 0x8 0b1000  1 0000
    wait for gCLK_HPER*2;
    -- -4 - -4 = 0 OV = 0
    --o_S should be 0x0, o_C = 1

    -- Test case 7:
    nAdd_Sub <= '1';
    i_A <= x"0"; --i_A = 0x0 0b0 0000
    i_B <= x"8"; --i_B = 0x8 0b1000  0 1000
    wait for gCLK_HPER*2;
    -- 0 - -4 = -4 OV = 1
    --o_S should be 0x8, o_C = 0

  end process;

end mixed;
