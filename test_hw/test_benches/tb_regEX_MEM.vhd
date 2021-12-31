-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_forward_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for forward_control logic
--
-- NOTES:
-- 12/2/21
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_forward_control is
  generic(gCLK_HPER   : time := 20 ns);
end tb_forward_control;

architecture behavior of tb_forward_control is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component forward_control is
	  port(i_Ex_Reg_Rs     	: in std_logic_vector(4 downto 0);
	       i_Ex_Reg_Rt     	: in std_logic_vector(4 downto 0);
	       i_Mem_RegWr      : in std_logic;
	       i_Mem_Reg_Rd     : in std_logic_vector(4 downto 0);
	       i_Wb_RegWr       : in std_logic;
	       i_Wb_Reg_Rd      : in std_logic_vector(4 downto 0);
	       o_forward_A	: out std_logic_vector(1 downto 0);
	       o_forward_B	: out std_logic_vector(1 downto 0));	

  end component;

  -- Temporary signals to connect to the reg component.
  signal s_CLK : std_logic;
  signal s_Ex_Reg_Rs	: std_logic_vector(4 downto 0):= (others => '0');
  signal s_Ex_Reg_Rt	: std_logic_vector(4 downto 0):= (others => '0');
  signal s_Mem_Reg_Rd	: std_logic_vector(4 downto 0):= (others => '0');
  signal s_Wb_Reg_Rd	: std_logic_vector(4 downto 0):= (others => '0');
  signal s_forward_A	: std_logic_vector(1 downto 0);
  signal s_forward_B	: std_logic_vector(1 downto 0);
  signal s_Mem_RegWr	: std_logic;
  signal s_Wb_RegWr	: std_logic;

begin

  DUT: forward_control 
  port map (s_Ex_Reg_Rs, s_Ex_Reg_Rt, s_Mem_RegWr, s_Mem_Reg_Rd, s_Wb_RegWr, s_Wb_Reg_Rd, s_forward_A, s_forward_B);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
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
   --No Forward
   s_Ex_Reg_Rs <="00000";
   s_Ex_Reg_Rt <="00000";
   s_Mem_Reg_Rd <= "00000";
   s_Mem_RegWr <= '0';
   s_Wb_Reg_Rd <= "00000";
   s_Wb_RegWr <= '0';
    wait for cCLK_PER;
  --  o_forward_A = "00", o_forward_B = "00"


    wait;
  end process;
  
end behavior;
