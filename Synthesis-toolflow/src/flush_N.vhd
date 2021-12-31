-------------------------------------------------------------------------
-- Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- flush_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of flush pipeline update
-- 
--
-- NOTES:
-- 12/2/21
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity flush_N is
    generic(N : integer := 32);
    port(
        i_flush : in std_logic;
        i_D: in std_logic_vector(N-1 downto 0);
        andOut: out std_logic_vector(N-1 downto 0));
end flush_N;

architecture structural of flush_N is
    component invg is
        port(i_A          : in std_logic;
             o_F          : out std_logic);
    end component;
    
    component and2t1_N is
        generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_A         : in std_logic_vector(N-1 downto 0);
             i_B         : in std_logic_vector(N-1 downto 0);
             o_F         : out std_logic_vector(N-1 downto 0));
    end component;
    
    signal s_not_o : std_logic;
    signal s_AndN_i : std_logic_vector(N-1 downto 0);

    begin
        s_AndN_i <= (others => s_Not_o);
        flush_not: invg port map(i_flush, s_not_o);
        flush_and: and2t1_N generic map(N) port map(i_D, s_AndN_i, andOut);

    end structural;
