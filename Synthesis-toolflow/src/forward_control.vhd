-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- forward_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of forward control unit
--
-- NOTES:
-- 11/27/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forward_control is
  port(i_Ex_Reg_Rs     	: in std_logic_vector(4 downto 0);
       i_Ex_Reg_Rt     	: in std_logic_vector(4 downto 0);
       i_Mem_RegWr      : in std_logic;
       i_Mem_Reg_Rd     : in std_logic_vector(4 downto 0);
       i_Wb_RegWr       : in std_logic;
       i_Wb_Reg_Rd      : in std_logic_vector(4 downto 0);
       o_forward_A	: out std_logic_vector(1 downto 0);
       o_forward_B	: out std_logic_vector(1 downto 0));	

end forward_control;

architecture behavioral of forward_control is

--signal s_forward_A : std_logic_vector(1 downto 0):= "00";
--signal s_forward_B : std_logic_vector(1 downto 0):= "00";

begin
	logic: process(i_Ex_Reg_Rs, i_Ex_Reg_Rt, i_Mem_RegWr, i_Mem_Reg_Rd, i_Wb_RegWr, i_Wb_Reg_Rd) is 
	begin 
		--Data in Mem
		if ((i_Mem_RegWr = '1') and (not(i_Mem_Reg_Rd = "00000"))
				--and(not( (i_Wb_RegWr = '1') and (not(i_Wb_Reg_Rd = "00000")) and(i_Wb_Reg_Rd = i_Ex_Reg_Rs) )) 
					and(i_Mem_Reg_Rd = i_Ex_Reg_Rs) ) then
			o_forward_A <= "10";
		else
			--Data in Wb
			if ((i_Wb_RegWr = '1') and (not(i_Wb_Reg_Rd = "00000")) 
				--and(not( (i_Mem_RegWr = '1') and (not(i_Mem_Reg_Rd = "00000")) and(i_Mem_Reg_Rd = i_Ex_Reg_Rs) ))  
					and(i_Wb_Reg_Rd = i_Ex_Reg_Rs) ) then
				o_forward_A <= "01";
			--NO Hazard
			else
				o_forward_A <= "00";
			end if;
		end if;
		
		--Data in Mem
		if ((i_Mem_RegWr = '1') and (not(i_Mem_Reg_Rd = "00000"))
				--and(not( (i_Wb_RegWr = '1') and (not(i_Wb_Reg_Rd = "00000")) and(i_Wb_Reg_Rd = i_Ex_Reg_Rt) )) 
					and(i_Mem_Reg_Rd = i_Ex_Reg_Rt) ) then
			o_forward_B <= "10";
		else
			--Data in Wb
			if ((i_Wb_RegWr = '1') and (not(i_Wb_Reg_Rd = "00000")) 
				--and(not( (i_Mem_RegWr = '1') and (not(i_Mem_Reg_Rd = "00000")) and(i_Mem_Reg_Rd = i_Ex_Reg_Rt) ))  
					and(i_Wb_Reg_Rd = i_Ex_Reg_Rt)) then
				o_forward_B <= "01";
			--NO Hazard
			else
				o_forward_B <= "00";
			end if;
		end if;


	end process logic;

end behavioral;
