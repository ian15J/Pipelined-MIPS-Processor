-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- id_forward_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of forward control unit for the id stage
--
-- NOTES:
-- 12/9/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity id_forward_control is
  port(i_Id_Branch      : in std_logic;
       i_Id_Jump     	: in std_logic_vector(1 downto 0);
       i_Id_Reg_Rs     	: in std_logic_vector(4 downto 0);
       i_Id_Reg_Rt     	: in std_logic_vector(4 downto 0);
       i_Ex_Reg_Rd     	: in std_logic_vector(4 downto 0);
       i_Mem_Reg_Rd     : in std_logic_vector(4 downto 0);
       i_Wb_Reg_Rd      : in std_logic_vector(4 downto 0);
       i_Ex_Reg_Wr	: in std_logic;
       i_Mem_Reg_Wr	: in std_logic;
       i_Wb_Reg_Wr	: in std_logic;
       o_forward_C	: out std_logic_vector(1 downto 0);
       o_forward_D	: out std_logic_vector(1 downto 0);
       o_forward_F	: out std_logic_vector(1 downto 0));

end id_forward_control;

architecture behavioral of id_forward_control is


begin
	logic: process(i_Id_Branch, i_Id_Jump, i_Id_Reg_Rs, i_Id_Reg_Rt, i_Mem_Reg_Rd, i_Wb_Reg_Rd, i_Ex_Reg_Rd, i_Ex_Reg_Wr, i_Mem_Reg_Wr, i_Wb_Reg_Wr) is 
	begin 

		if( ((i_Id_Branch = '1') or (i_Id_Jump = "10")) and (i_Ex_Reg_Wr = '1') and (not(i_Ex_Reg_Rd = "00000"))
			and(i_Ex_Reg_Rd = i_Id_Reg_Rs) ) then
			o_forward_C <= "11";
			o_forward_F <= "11";
		else
			--MEM
			if (((i_Id_Branch = '1') or (i_Id_Jump = "10")) and (i_Mem_Reg_Wr = '1') and (not(i_Mem_Reg_Rd = "00000")) 
				and(not( (not(i_Wb_Reg_Rd = "00000")) and(i_Wb_Reg_Rd = i_Id_Reg_Rs) and (i_Wb_Reg_Wr = '1') ))  
					and(i_Mem_Reg_Rd = i_Id_Reg_Rs) ) then
				o_forward_C <= "10";
				o_forward_F <= "10";
			--WB
			else 
				if (((i_Id_Branch = '1') or (i_Id_Jump = "10")) and (i_Wb_Reg_Wr = '1') and (not(i_Wb_Reg_Rd = "00000"))
					--and(not( (not(i_Mem_Reg_Rd = "00000")) and(i_Mem_Reg_Rd = i_Id_Reg_Rs) and (i_Mem_Reg_Wr = '1'))) 
						and(i_Wb_Reg_Rd = i_Id_Reg_Rs) ) then
					o_forward_C <= "01";
					o_forward_F <= "01";
				
				else
					o_forward_C <= "00";--NO Hazard
					o_forward_F <= "00";
				end if;
			end if;
		end if;

		
		if((i_Id_Branch = '1') and (i_Ex_Reg_Wr = '1') and (not(i_Ex_Reg_Rd = "00000"))
					and(i_Ex_Reg_Rd = i_Id_Reg_Rt)) then
			o_forward_D <= "11";
		else
			--MEM
			if ((i_Id_Branch = '1') and (i_Mem_Reg_Wr = '1') and (not(i_Mem_Reg_Rd = "00000")) 
				and(not( (not(i_Wb_Reg_Rd = "00000")) and(i_Wb_Reg_Rd = i_Id_Reg_Rt) and (i_Wb_Reg_Wr = '1')))  
					and(i_Mem_Reg_Rd = i_Id_Reg_Rt) ) then
				o_forward_D <= "10";
			--WB
			else 
				if ((i_Id_Branch = '1') and (i_Wb_Reg_Wr = '1') and (not(i_Wb_Reg_Rd = "00000"))
					--and(not( (not(i_Mem_Reg_Rd = "00000")) and(i_Mem_Reg_Rd = i_Id_Reg_Rt) and (i_Mem_Reg_Wr = '1'))) 
						and(i_Wb_Reg_Rd = i_Id_Reg_Rt) ) then
					o_forward_D <= "01";
				else
					o_forward_D <= "00";--NO Hazard
				end if;
			end if;
		end if;

	end process logic;

end behavioral;
