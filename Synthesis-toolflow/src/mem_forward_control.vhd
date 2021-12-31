-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- mem_forward_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of forward control unit for the dmem
--
-- NOTES:
-- 12/9/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mem_forward_control is
  port(i_mem_DMemWr     : in std_logic;
       i_Mem_Reg_Rd     : in std_logic_vector(4 downto 0);
       i_Wb_Reg_Rd      : in std_logic_vector(4 downto 0);
       i_Wb_RegWr	: in std_logic;
       o_forward_E	: out std_logic);	

end mem_forward_control;

architecture behavioral of mem_forward_control is


begin
	logic: process(i_mem_DMemWr, i_Mem_Reg_Rd, i_Wb_Reg_Rd, i_Wb_RegWr) is 
	begin 

		if ((i_mem_DMemWr = '1') and (not(i_Mem_Reg_Rd = "00000")) and (i_Wb_RegWr = '1')
				and(i_Mem_Reg_Rd = i_Wb_Reg_Rd) ) then
			o_forward_E <= '1';
	
		else 
			o_forward_E <= '0';
		end if;

	end process logic;

end behavioral;
