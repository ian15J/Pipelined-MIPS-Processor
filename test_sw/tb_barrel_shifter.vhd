-------------------------------------------------------------------------
-- Yohan Bopearatchy
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a barrel shifter
--
-- NOTES:
-- 10/14/21
--
-- Updated:
-- 10/18/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_barrel_shifter is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_barrel_shifter;

architecture mixed of tb_barrel_shifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component barrel_shifter is
    port(i_shift                  : in std_logic_vector(5-1 downto 0);   		--Input
	 i_A                	  : in std_logic_vector(31 downto 0);    	        --ShiftAmount
         i_shiftLR                : in std_logic;  			 		--LeftRight
	 i_ar                	  : in std_logic;                       		--ArithLog
	 o_F                	  : out std_logic_vector(32-1 downto 0)); 		--Output
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_shift 		: std_logic_vector(5-1 downto 0);
signal s_A   		: std_logic_vector(31 downto 0);
signal s_shiftLR   	: std_logic;  -- 0=>Left Shift; 1=>Right Shift
signal s_ar   		: std_logic;
signal s_F   		: std_logic_vector(32-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.

  DUT0: barrel_shifter port map(s_shift, s_A, s_shiftLR, s_ar, s_F);

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
	s_shift		<= "00000";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '0';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x000FF000

    -- Test case 2:
	s_shift		<= "00001";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '0';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x001FE000

    -- Test case 3:
	s_shift		<= "00010";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '0';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x003FC000

    -- Test case 4:
	s_shift		<= "00100";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '0';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x00FF0000

    -- Test case 5:
	s_shift		<= "11111";
	s_A   		<= x"800FF001";
	s_shiftLR 	<= '0';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x80000000

    -- Test case 6:
	s_shift		<= "00000";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '1';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x000FF000

    -- Test case 7:
	s_shift		<= "00001";
	s_A   		<= x"000FF000";
	s_shiftLR 	<= '1';
	s_ar		<= '1';
    wait for gCLK_HPER*2;
    --o_F = 0x0007F800

    -- Test case 8:
	s_shift		<= "00001";
	s_A   		<= x"800FF000";
	s_shiftLR 	<= '1';
	s_ar		<= '1';
    wait for gCLK_HPER*2;
    --o_F = 0xC007F800

    -- Test case 9:
	s_shift		<= "11111";
	s_A   		<= x"800FF001";
	s_shiftLR 	<= '1';
	s_ar		<= '0';
    wait for gCLK_HPER*2;
    --o_F = 0x00000001

    -- Test case 10:
	s_shift		<= "11111";
	s_A   		<= x"800FF001";
	s_shiftLR 	<= '1';
	s_ar		<= '1';
    wait for gCLK_HPER*2;
    --o_F = 0xFFFFFFFF

  end process;

end mixed;
