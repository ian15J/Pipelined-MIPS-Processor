-------------------------------------------------------------------------
-- Yohan Bopearatchy
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
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regIF_ID is
  port(i_CLK        	: in std_logic; -- Clock input
       i_RST        	: in std_logic; -- Reset input
       i_WE		: in std_logic; -- Write Enable
       if_Inst         	: in std_logic_vector(31 downto 0); --Instruction signal from IF stage
       if_Pc4           : in std_logic_vector(31 downto 0); --PC+4 signal from IF stage
       o_id_Inst        : out std_logic_vector(31 downto 0); --Instruction signal to ID stage
       o_id_Pc4		: out std_logic_vector(31 downto 0)); --PC+4 signal to ID stage

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

begin
  IF_ID_Inst_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, if_Inst, o_id_Inst);
  IF_ID_Pc4_reg: register_N generic map(32) port map(i_CLK, i_RST, i_WE, if_PC4, o_id_Pc4);
  

end structural;
