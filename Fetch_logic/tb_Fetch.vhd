-------------------------------------------------------------------------
-- Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_Fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the test bench for fetch logic
--
-- NOTES:
-- 10/28/21 - Bailey G 
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Fetch is
    generic(gCLK_HPER   : time := 50 ns);
  end tb_Fetch;

architecture behavior of tb_Fetch is 
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component Fetch is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        o_instruction: out std_logic_vector(31 downto 0);
        o_add4: out std_logic_vector(31 downto 0));
    end component;

    signal s_CLK, s_RST : std_logic;
    signal s_instruction, s_add4 : std_logic_vector(31 downto 0) := (others => '0');
    
    begin
        DUT: Fetch port map(s_CLK, s_RST, s_instruction, s_add4);

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
            s_RST <= '1';
        wait for cCLK_PER;
            s_RST <= '0';
        wait for cCLK_PER;
        
        wait;
        end process;
  end behavior;
            
