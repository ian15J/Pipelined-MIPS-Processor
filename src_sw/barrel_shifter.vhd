-------------------------------------------------------------------------
-- Yohan Bopearatchy
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a barrel shifter to change the amount of bits shifted
--
-- NOTES:
-- 10/14/21
--
-- Updated:
-- 10/21/21
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity barrel_shifter is
    port(i_shift                  : in std_logic_vector(5-1 downto 0);   		--ShiftAmount
	 i_A                	  : in std_logic_vector(31 downto 0);    	        --Input
         i_shiftLR                : in std_logic;  			 		--LeftRight
	 i_ar                	  : in std_logic;                       		--ArithLog
	 o_F                	  : out std_logic_vector(32-1 downto 0)); 		--Output

end barrel_shifter;

architecture struct of barrel_shifter is

	component mux2t1_N is
	  generic(N : integer := 16);
	  port(i_S          : in std_logic;
	       i_D0         : in std_logic_vector(N-1 downto 0);
	       i_D1         : in std_logic_vector(N-1 downto 0);
	       o_O          : out std_logic_vector(N-1 downto 0));

	end component;

	component mux2t1 is
    		port(i_S                  : in std_logic;
         	     i_D0                 : in std_logic;
         	     i_D1                 : in std_logic;
         	     o_O                  : out std_logic);
	end component;

	signal sl_mux0_out, sl_mux1_out, sl_mux2_out, sl_mux3_out, sl_mux4_out	    :std_logic_vector(31 downto 0);	
	signal sr_mux0_out, sr_mux1_out, sr_mux2_out, sr_mux3_out, sr_mux4_out	    :std_logic_vector(31 downto 0);
	signal s_fill								    :std_logic;
	signal s_fill2								    :std_logic_vector(1 downto 0);
	signal s_fill4								    :std_logic_vector(3 downto 0);
	signal s_fill8								    :std_logic_vector(7 downto 0);
	signal s_fill16								    :std_logic_vector(15 downto 0);
	signal sl_mux0_in, sl_mux1_in, sl_mux2_in, sl_mux3_in, sl_mux4_in	    :std_logic_vector(31 downto 0);
	signal sr_mux0_in, sr_mux1_in, sr_mux2_in, sr_mux3_in, sr_mux4_in	    :std_logic_vector(31 downto 0);

begin
	sl_mux0_in <= i_A(30 downto 0) & '0';
	muxL0: mux2t1_N generic map(32) port map(i_shift(0), i_A, sl_mux0_in, sl_mux0_out);    
	sl_mux1_in <= sl_mux0_out(29 downto 0) & "00";
	muxL1: mux2t1_N generic map(32) port map(i_shift(1), sl_mux0_out, sl_mux1_in, sl_mux1_out);
	sl_mux2_in <= sl_mux1_out(27 downto 0) & x"0";
	muxL2: mux2t1_N generic map(32) port map(i_shift(2), sl_mux1_out, sl_mux2_in, sl_mux2_out);
	sl_mux3_in <= sl_mux2_out(23 downto 0) & x"00";
	muxL3: mux2t1_N generic map(32) port map(i_shift(3), sl_mux2_out, sl_mux3_in, sl_mux3_out);
	sl_mux4_in <= sl_mux3_out(15 downto 0) & x"0000";
	muxL4: mux2t1_N generic map(32) port map(i_shift(4), sl_mux3_out, sl_mux4_in, sl_mux4_out);

	muxF0: mux2t1 port map(i_ar, '0', i_A(31), s_fill);
	s_fill2  <= (others => s_fill);
	s_fill4  <= (others => s_fill);
	s_fill8  <= (others => s_fill);
	s_fill16 <= (others => s_fill);

	sr_mux0_in <= s_fill & i_A(31 downto 1);
	muxR0: mux2t1_N generic map(32) port map(i_shift(0), i_A, sr_mux0_in, sr_mux0_out);   
	sr_mux1_in <=  s_fill2 & sr_mux0_out(31 downto 2);
	muxR1: mux2t1_N generic map(32) port map(i_shift(1), sr_mux0_out, sr_mux1_in, sr_mux1_out);
	sr_mux2_in <= s_fill4 & sr_mux1_out(31 downto 4);
	muxR2: mux2t1_N generic map(32) port map(i_shift(2), sr_mux1_out, sr_mux2_in, sr_mux2_out);
	sr_mux3_in <= s_fill8 & sr_mux2_out(31 downto 8);
	muxR3: mux2t1_N generic map(32) port map(i_shift(3), sr_mux2_out, sr_mux3_in, sr_mux3_out);
	sr_mux4_in <= s_fill16 & sr_mux3_out(31 downto 16);
	muxR4: mux2t1_N generic map(32) port map(i_shift(4), sr_mux3_out, sr_mux4_in, sr_mux4_out);

	muxFinal: mux2t1_N generic map(32) port map(i_shiftLR, sl_mux4_out, sr_mux4_out, o_F);
end struct;


