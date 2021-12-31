-------------------------------------------------------------------------
-- Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- flush_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of flush pipeline update
-- 
--
-- NOTES:
-- 12/2/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity flush_1 is
    port(
        i_flush : in std_logic;
        i_D: in std_logic;
        andOut: out std_logic);
end flush_1;

architecture structural of flush_1 is
    component invg is
        port(i_A          : in std_logic;
             o_F          : out std_logic);
    end component;
    
    component andg2 is
        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
    end component;
    
    signal s_not_o : std_logic;

    begin
        flush_not: invg port map(i_flush, s_not_o);
        flush_and: andg2 port map(i_D, s_not_o, andOut);

    end structural;
