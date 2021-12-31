-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- hazard_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of hazard detection unit
--
-- NOTES:
-- 11/27/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_control is
  port(i_Id_Inst        : in std_logic_vector(31 downto 0);
       i_Ex_Reg_Rt      : in std_logic_vector(4 downto 0);
       i_Ex_Reg_Rd      : in std_logic_vector(4 downto 0);
       i_MEM_Reg_Rd     : in std_logic_vector(4 downto 0);
       i_WB_Reg_Rd      : in std_logic_vector(4 downto 0);
       i_Ex_DmemRead	: in std_logic;
       i_Mem_DmemRead	: in std_logic;
       i_id_Branch	: in std_logic;
       i_id_eq		: in std_logic;
       i_id_Jump        : in std_logic_vector(1 downto 0);
       o_PcWr		: out std_logic;
       o_IF_ID_Flush	: out std_logic;
       o_IF_ID_Stall	: out std_logic;
       o_ID_EX_Flush	: out std_logic;
       o_ID_EX_Stall	: out std_logic;
       o_EX_MEM_Flush	: out std_logic;
       o_EX_MEM_Stall	: out std_logic;
       o_MEM_WB_Flush	: out std_logic;
       o_MEM_WB_Stall	: out std_logic);	

end hazard_control;

architecture structural of hazard_control is


begin
	logic: process(i_Id_Inst, i_Ex_Reg_Rt, i_Ex_Reg_Rd, i_MEM_Reg_Rd, i_WB_Reg_Rd, i_Ex_DmemRead, i_id_Branch, i_id_eq, i_id_Jump, i_Mem_DmemRead) is 	
	begin
		
		if( ((i_Ex_DmemRead = '1') and ((i_Ex_Reg_Rt = i_Id_Inst(25 downto 21)) or (i_Ex_Reg_Rt = i_Id_Inst(20 downto 16)) )) 
			or((i_id_Branch = '1')  and ( ((i_Ex_DmemRead = '1') and ((i_Ex_Reg_Rt = i_Id_Inst(25 downto 21)) or (i_Ex_Reg_Rt = i_Id_Inst(20 downto 16)) ))  
				or ((i_Mem_DmemRead = '1') and ((i_MEM_Reg_Rd = i_Id_Inst(25 downto 21)) or (i_MEM_Reg_Rd = i_Id_Inst(20 downto 16)) ))
				)) 
			) then

--
			--stall
			o_PcWr <= '0';
			o_IF_ID_Stall <= '1';
			--flush ex
			o_ID_EX_Flush <= '1';

		else
			if( ((i_id_Branch = '1') and (i_id_eq = '1')) or (not(i_id_Jump = "00")))then
				--don't stall
				o_PcWr <= '1';
				--flush
				o_IF_ID_Flush <='1';
				
			else
			--no stall or flush
			o_PcWr <= '1';
			o_IF_ID_Stall 	<= '0';
			o_ID_EX_Stall 	<= '0';
			o_EX_MEM_Stall	<= '0';
			o_MEM_WB_Stall 	<= '0';

			o_IF_ID_Flush 	<= '0';
			o_ID_EX_Flush 	<= '0';
			o_EX_MEM_Flush	<= '0';
			o_MEM_WB_Flush 	<= '0';
			end if;
		end if;


	end process logic;


end structural;
