-------------------------------------------------------------------------
-- Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- Fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of fetch logic
--
-- NOTES:
-- 10/14/21 - Bailey G
-- 10/21/21 - Bailey G 
-- 10/28/21 - Basic Fetch completed
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Fetch is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_immExt : in std_logic_vector(31 downto 0);
        o_add4: out std_logic_vector(31 downto 0);
        i_zero: in std_logic; --Input from ALU Zero
        i_jump: in std_logic_vector(1 downto 0); --Jump control
        i_branch: in std_logic; --Branch conrol
        i_JumpR: in std_logic_vector(31 downto 0);
        o_PC: out std_logic_vector(31 downto 0);
	i_inst: in std_logic_vector(31 downto 0));

end Fetch;


architecture structural of Fetch is
    component pc_register_32 is
	  port(i_CLK        : in std_logic;     		-- Clock input
	       i_RST        : in std_logic;    			-- Reset input
	       i_WE         : in std_logic;     		-- Write enable input
	       i_D          : in std_logic_vector(32-1 downto 0);-- Data value input Nbit
	       o_Q          : out std_logic_vector(32-1 downto 0));-- Data value output Nbit
    end component;

    component full_add_N is
        generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32. with overflow flag
        port(i_C                 : in std_logic;
         i_A                 : in std_logic_vector(N-1 downto 0);
         i_B                 : in std_logic_vector(N-1 downto 0);
         o_S                 : out std_logic_vector(N-1 downto 0);
         o_C                 : out std_logic;
         o_OV                : out std_logic);
    end component;

    component andg2 is 
        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
    end component;

    component mux4t1_N is
        generic(N : integer := 32);
        port(i_S                  : in std_logic_vector(2-1 downto 0);
             i_D0                 : in std_logic_vector(N-1 downto 0);
             i_D1                 : in std_logic_vector(N-1 downto 0);
             i_D2                 : in std_logic_vector(N-1 downto 0);
             i_D3                 : in std_logic_vector(N-1 downto 0);
             o_O                  : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    signal s_WE   : std_logic:= '1';        
    signal o_A   : std_logic_vector(31 downto 0);
    signal s_PC   : std_logic_vector(31 downto 0);
    signal undefined   : std_logic_vector(31 downto 0):= (others => '-');
    signal s_C : std_logic := '-';
    signal s_OV : std_logic := '-';
    signal s_JAI : std_logic_vector(31 downto 0) := (others => '0');
    signal s_JAO : std_logic_vector(31 downto 0) := (others => '0');
    signal s_AndOut : std_logic;
    signal s_JAMuxOut : std_logic_vector(31 downto 0);
    signal shiftleft : std_logic_vector(31 downto 0);
    signal JumpMuxOut : std_logic_vector(31 downto 0);
    signal s_Add4 : std_logic_vector(31 downto 0);
    signal s_PCMuxOut : std_logic_vector(31 downto 0);

    begin
	--PCMux: mux2t1_N generic map (32) port map  (i_rst, JumpMuxOut, x"00400000", s_PCMuxOut);         
	
        --PC: register_N generic map (32) port map(i_clk, '0', s_WE, s_PCMuxOut, s_PC);
	PC: pc_register_32 port map(i_clk, i_rst, s_WE, JumpMuxOut, s_PC);
        o_PC <= s_PC;

        Add_4: full_add_N generic map (32) port map('0', s_PC, x"00000004", s_Add4, s_C, s_OV); 
      
	o_Add4 <= s_Add4;
	s_JAI <= i_immExt(29 downto 0) & "00";

        JumpAdd: full_add_N generic map (32) port map('0', s_Add4, s_JAI, s_JAO,  s_C, s_OV);

        Andg: andg2 port map(i_zero, i_branch, s_AndOut);

        JAMux: mux2t1_N generic map (32) port map(s_AndOut, s_Add4, s_JAO, s_JAMuxOut);
    
        -- 0000 00       11 1111 0000 0000 0000 0000 0001 
        -- 0000 00     1111 1100 0000 0000 0000 0000 0100
        --        1100 1000 0000 0000 0000 0000 0000 0100
        --        1100 1111 1111 0000 0000 0000 0000 0100
        shiftleft <= s_Add4(31 downto 28) & i_inst(25 downto 0) & "00";

        JumpMux: mux4t1_N generic map (32) port map(i_jump, s_JAMuxOut, shiftleft, i_JumpR, undefined, JumpMuxOut);

end structural;
