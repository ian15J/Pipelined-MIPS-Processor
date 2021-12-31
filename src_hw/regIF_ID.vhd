-------------------------------------------------------------------------
-- Yohan Bopearatchy & Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- regIF_ID.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of IF to ID pipeline registers
-- 
--
--
-- NOTES:
-- 11/11/21
-- 12/2/21 - Added Flush/Stall
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regIF_ID is
	port(i_CLK        	: in std_logic; -- Clock input
	     i_RST        	: in std_logic; -- Reset input
	     i_WE		: in std_logic; -- Write Enable
	     i_flush		: in std_logic;	-- flush
	     i_stall		: in std_logic; -- stall
	     if_Inst         	: in std_logic_vector(31 downto 0); --Instruction signal from IF stage
	     if_Pc4           	: in std_logic_vector(31 downto 0); --PC+4 signal from IF stage
	     if_Pc           	: in std_logic_vector(31 downto 0);
	     o_id_Inst        	: out std_logic_vector(31 downto 0); --Instruction signal to ID stage
	     o_id_Pc4		: out std_logic_vector(31 downto 0); --PC+4 signal to ID stage
	     o_id_Pc           : out std_logic_vector(31 downto 0));

	end regIF_ID;

architecture structural of regIF_ID is

  component dffg is
    port(i_CLK        : in std_logic;     -- Clock input
    i_RST        : in std_logic;     -- Reset input
    i_WE         : in std_logic;     -- Write enable input
    i_D          : in std_logic;     -- Data value input
    o_Q          : out std_logic);   -- Data value output
  end component;
  component register_N is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;     		-- Clock input
       i_RST        : in std_logic;    			-- Reset input
       i_WE         : in std_logic;     		-- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);-- Data value input Nbit
       o_Q          : out std_logic_vector(N-1 downto 0));-- Data value output Nbit
  end component;

  component andg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
end component;

component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);
end component;

component flush_N is
  generic(N : integer := 32);
    port(
        i_flush : in std_logic;
        i_D: in std_logic_vector(N-1 downto 0);
        andOut: out std_logic_vector(N-1 downto 0));
end component;


signal s_And_o : std_logic;
signal s_Not_o : std_logic;
signal s_InstFlush_o : std_logic_vector(31 downto 0);
signal s_Pc4Flush_o  : std_logic_vector(31 downto 0);
signal s_PcFlush_o  : std_logic_vector(31 downto 0);


begin
  Inst_flush: flush_N generic map(32) port map(i_flush, if_Inst, s_InstFlush_o);
  PC4_flush: flush_N generic map(32) port map(i_flush, if_Pc4, s_PC4Flush_o);
  PC_flush: flush_N generic map(32) port map(i_flush, if_Pc, s_PCFlush_o);
  IF_Not_stall: invg port map(i_stall, s_Not_o);
  IF_And_stall: andg2 port map(i_WE, s_Not_o, s_And_o);
  IF_ID_Inst_reg: register_N generic map(32) port map(i_CLK, i_RST, s_And_o, s_InstFlush_o, o_id_Inst);
  IF_ID_Pc4_reg: register_N generic map(32) port map(i_CLK, i_RST, s_And_o, s_PC4Flush_o, o_id_Pc4);
  IF_ID_Pc_reg: register_N generic map(32) port map(i_CLK, i_RST, s_And_o, s_PCFlush_o, o_id_Pc);
  

end structural;
