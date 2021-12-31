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
-- 11/27/21 - Ian J Fetch update
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Fetch is
    port(i_Pc4 : in std_logic_vector(31 downto 0); 	--Pc + 4
	 i_immExt : in std_logic_vector(31 downto 0);	--ImmExt
         i_eq: in std_logic; 				--input from equals logic
         i_jump: in std_logic_vector(1 downto 0); 	--Jump control
         i_branch: in std_logic; 			--Branch conrol
         i_JumpR: in std_logic_vector(31 downto 0);	--RegRead0
	 i_inst: in std_logic_vector(31 downto 0);
	 o_newAddr: out std_logic_vector(31 downto 0));

end Fetch;


architecture structural of Fetch is
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

    signal undefined   : std_logic_vector(31 downto 0):= (others => '-');
    signal s_C : std_logic := '-';
    signal s_OV : std_logic := '-';
    signal s_ShiftedImm : std_logic_vector(31 downto 0) := (others => '0');
    signal s_BranchAddr : std_logic_vector(31 downto 0) := (others => '0');

    signal s_AndOut : std_logic;
    signal s_newBranchAddr : std_logic_vector(31 downto 0);

    signal s_JumpAddr : std_logic_vector(31 downto 0);

    begin
	s_ShiftedImm <= i_immExt(29 downto 0) & "00";
 	JumpAdd: full_add_N generic map (32) port map('0', i_Pc4, s_ShiftedImm, s_BranchAddr,  s_C, s_OV);

  	Andg: andg2 port map(i_eq, i_branch, s_AndOut);
  	BranchAddrMux: mux2t1_N generic map (32) port map(s_AndOut, i_Pc4, s_BranchAddr, s_newBranchAddr);

  	s_JumpAddr <= i_Pc4(31 downto 28) & i_inst(25 downto 0) & "00";
  	newAddrMux: mux4t1_N generic map (32) port map(i_jump, s_newBranchAddr, s_JumpAddr, i_JumpR, undefined, o_newAddr);

end structural;
