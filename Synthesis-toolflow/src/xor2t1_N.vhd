-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- xor2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a N bit xor gate used in the ALU
--
--
-- NOTES:
-- 10/12/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity xor2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F         : out std_logic_vector(N-1 downto 0));

end xor2t1_N;

architecture structural of xor2t1_N is

  component xorg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);

  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_xor: for i in 0 to N-1 generate

    xor0: xorg2 port map(i_A(i), i_B(i), o_F(i));

  end generate G_NBit_xor;
  
end structural;
