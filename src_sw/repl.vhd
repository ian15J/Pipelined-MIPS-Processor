-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- repl.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a repl component used for the repl instruction
--
--
-- NOTES:
-- 10/16/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity repl is
  port(i_repl      : in std_logic_vector(8-1 downto 0);
       o_F         : out std_logic_vector(32-1 downto 0));

end repl;

architecture dataflow of repl is


begin

  o_F <= i_repl & i_repl & i_repl & i_repl;
  
end dataflow;
