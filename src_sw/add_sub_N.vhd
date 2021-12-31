-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- add_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a add/sub unit with N bits using structural VHDL. With overflow flag
--
-- NOTES:
-- 9/3/21
-- 10/7/21 updated Ian Johnson
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity add_sub_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(nAdd_Sub                 : in std_logic;
	 i_A                	  : in std_logic_vector(N-1 downto 0);
	 i_B               	  : in std_logic_vector(N-1 downto 0);
         o_S                 	  : out std_logic_vector(N-1 downto 0);
	 o_C                 	  : out std_logic;
	 o_OV                	  : out std_logic);
end add_sub_N;

--define architecture
architecture structural of add_sub_N is
	-- full adder with N bits
	component full_add_N is
		generic(N : integer := 16);
		port(i_C                 : in std_logic;
		     i_A                 : in std_logic_vector(N-1 downto 0);
	 	     i_B                 : in std_logic_vector(N-1 downto 0);
        	     o_S                 : out std_logic_vector(N-1 downto 0);
	 	     o_C                 : out std_logic;
	 	     o_OV                : out std_logic);
	end component;
	--mux with N bits
	component mux2t1_N is
 		 generic(N : integer := 16);
  		 port(i_S     : in std_logic;
     		 i_D0         : in std_logic_vector(N-1 downto 0);
     		 i_D1         : in std_logic_vector(N-1 downto 0);
     		 o_O          : out std_logic_vector(N-1 downto 0));

	end component;
	--inverter with N bits
	component invg_N is
		generic(N : integer := 16);
    		port(i_A                 : in std_logic_vector(N-1 downto 0);
         	     o_F                 : out std_logic_vector(N-1 downto 0));
	end component;
	--intermidiate signals
	signal mux1_out, invg1_out : std_logic_vector(N-1 downto 0);
begin
	i1: invg_N generic map (N) port map (i_B, invg1_out);
	mux1: mux2t1_N generic map (N) port map (nAdd_Sub, i_B, invg1_out, mux1_out);
	add1: full_add_N generic map (N) port map (nAdd_Sub, i_A, mux1_out, o_S, o_C, o_OV);

end structural;
