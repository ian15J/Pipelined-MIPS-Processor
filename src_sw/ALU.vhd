-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the ALU.
--
--
-- NOTES:
-- 10/9/21
-- 10/14/21 Ian Johnson Updated
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is 
  port(i_ALUop	     : in std_logic_vector(5-1 downto 0); --ALUopcode
       i_A	     : in std_logic_vector(32-1 downto 0); --ALU input A
       i_B 	     : in std_logic_vector(32-1 downto 0); --ALU input B
       i_shift	     : in std_logic_vector(5-1 downto 0); --shift amount
       i_repl        : in std_logic_vector(8-1 downto 0); --repl input
       o_OV	     : out std_logic; --overflow Flag
       o_Zero	     : out std_logic; --zero Flag
       o_Carry	     : out std_logic; --Carry Out
       o_ALUout	     : out std_logic_vector(32-1 downto 0)); --ALU output

end ALU;

architecture structural of ALU is

	component add_sub_N is
    	 generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    	  port(nAdd_Sub                 : in std_logic;
	       	i_A             	: in std_logic_vector(N-1 downto 0);
	 	i_B         		: in std_logic_vector(N-1 downto 0);
         	o_S                 	: out std_logic_vector(N-1 downto 0);
	 	o_C                 	: out std_logic;
	 	o_OV                	: out std_logic);
	end component;

	component and2t1_N is
	  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	  port(i_A         : in std_logic_vector(N-1 downto 0);
	       i_B         : in std_logic_vector(N-1 downto 0);
	       o_F         : out std_logic_vector(N-1 downto 0));

	end component;

	component andg2 is
	    port(i_A          : in std_logic;
		 i_B          : in std_logic;
		 o_F          : out std_logic);

	  end component;

	component or2t1_N is
	  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	  port(i_A         : in std_logic_vector(N-1 downto 0);
	       i_B         : in std_logic_vector(N-1 downto 0);
	       o_F         : out std_logic_vector(N-1 downto 0));

	end component;

	component nor32t1 is
	  port(i_A         : in std_logic_vector(32-1 downto 0);
	       o_F         : out std_logic);

	end component;

	component xor2t1_N is
	  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
	  port(i_A         : in std_logic_vector(N-1 downto 0);
	       i_B         : in std_logic_vector(N-1 downto 0);
	       o_F         : out std_logic_vector(N-1 downto 0));
	end component;

	component xorg2 is
	  port(i_A          : in std_logic;
	       i_B          : in std_logic;
	       o_F          : out std_logic);
	end component;

	component ALU_Control is 
	  port(i_ALUop       : in std_logic_vector(5-1 downto 0); 	-- input opcode
	       o_hasOV	     : out std_logic; --wheither ALU produced an overflow
	       o_shiftSrc    : out std_logic; --wheither Shifter gets shift amount or 16
	       o_shiftLR     : out std_logic; --shifter L/R control
	       o_shiftAr     : out std_logic; --shift aritmitic
	       o_unSigned    : out std_logic; --wheither instruction is unsigned or not
	       o_addSub      : out std_logic; --wheither add or subtract
	       o_invZero     : out std_logic; --wheither bne or beq
	       o_isNor       : out std_logic; --wheither nor
	       o_ALUMuxCtl   : out std_logic_vector(3-1 downto 0)); --output mux control

	end component;

	component mux8t1 is
	    generic(N : integer := 32);
	    port(i_S                  : in std_logic_vector(3-1 downto 0);
		 i_D0                 : in std_logic_vector(N-1 downto 0);
		 i_D1                 : in std_logic_vector(N-1 downto 0);
		 i_D2                 : in std_logic_vector(N-1 downto 0);
		 i_D3                 : in std_logic_vector(N-1 downto 0);
		 i_D4                 : in std_logic_vector(N-1 downto 0);
		 i_D5                 : in std_logic_vector(N-1 downto 0);
		 i_D6                 : in std_logic_vector(N-1 downto 0);
		 i_D7                 : in std_logic_vector(N-1 downto 0);
		 o_O                  : out std_logic_vector(N-1 downto 0));
	end component;

	component mux2t1_N is
	  generic(N : integer := 16);
	  port(i_S          : in std_logic;
	       i_D0         : in std_logic_vector(N-1 downto 0);
	       i_D1         : in std_logic_vector(N-1 downto 0);
	       o_O          : out std_logic_vector(N-1 downto 0));

	end component;
	
	component slt_N is
	  generic(N : integer := 32);
	  port(i_unSign    : in std_logic;
	       i_Sub       : in std_logic_vector(N-1 downto 0);
	       i_A         : in std_logic_vector(N-1 downto 0);
	       i_B         : in std_logic_vector(N-1 downto 0);
	       o_F         : out std_logic_vector(N-1 downto 0));

	end component;

	component barrel_shifter is
	    port(i_shift                  : in std_logic_vector(5-1 downto 0);   		--ShiftAmount
		 i_A                	  : in std_logic_vector(31 downto 0);    	        --Input
		 i_shiftLR                : in std_logic;  			 		--LeftRight
		 i_ar                	  : in std_logic;                       		--ArithLog
		 o_F                	  : out std_logic_vector(32-1 downto 0)); 		--Output

	end component;

	component repl is
	  port(i_repl      : in std_logic_vector(8-1 downto 0);
	       o_F         : out std_logic_vector(32-1 downto 0));

	end component;

	--control signals
	signal s_hasOV		: std_logic; --wheither ALU produced an overflow
	signal s_shiftSrc	: std_logic; --wheither Shifter gets shift amount or 16
	signal s_shiftLR    	: std_logic; --shifter L/R control
	signal s_shiftAr     	: std_logic; --shift aritmitic
        signal s_unSigned       : std_logic; --wheither instruction is unsigned or not
	signal s_addSub      	: std_logic; --wheither add or subtract
	signal s_invZero     	: std_logic; --wheither bne or beq
	signal s_isNor       	: std_logic; --wheither nor
	signal s_ALUMuxCtl   	: std_logic_vector(3-1 downto 0); --output mux control

	--add/sub intermidiate
	signal s_iAddSub_OV_out : std_logic;
	signal s_zero 		: std_logic;
	--add/sub final
	signal s_AddSub_out   	: std_logic_vector(32-1 downto 0);

	--or intermidiate
	signal s_isNorMaster   	: std_logic_vector(32-1 downto 0);
	signal s_orUnit_out 	: std_logic_vector(32-1 downto 0);
	--or/nor final
	signal s_orToNor_out 	: std_logic_vector(32-1 downto 0);

	--and final
	signal s_andUnit_out 	: std_logic_vector(32-1 downto 0);

	--xor final
	signal s_xorUnit_out 	: std_logic_vector(32-1 downto 0);
	
	--shifter intermidiate
	signal s_lui 		: std_logic_vector(5-1 downto 0):= "10000";
	signal s_shiftInput 	: std_logic_vector(5-1 downto 0);
	signal s_shiftNumInput 	: std_logic_vector(5-1 downto 0);
	--shifter final
	signal s_shiftUnit_out 	: std_logic_vector(32-1 downto 0);

	--repl final
	signal s_replUnit_out 	: std_logic_vector(32-1 downto 0);

	--slt final
	signal s_sltUnit_out 	: std_logic_vector(32-1 downto 0);
	
	--undefined
	signal undefined : std_logic_vector(32-1 downto 0):= (others => '-');

begin
	--ALU control signals, sets control signals
	Control0: ALU_Control port map (i_ALUop, s_hasOV, s_shiftSrc, s_shiftLR, s_shiftAr, s_unSigned, s_addSub, s_invZero, s_isNor, s_ALUMuxCtl);
	
	--Add/Sub unit, sets OV, zero, and s_AddSub_out
	AddSub0: add_sub_N generic map (32) port map (s_addSub, i_A, i_B, s_AddSub_out, o_Carry, s_iAddSub_OV_out);
	OvAnd0: andg2 port map (s_hasOV, s_iAddSub_OV_out, o_OV);
	zeroNor0: nor32t1 port map (s_AddSub_out, s_zero);
	zeroXor0: xorg2 port map (s_zero, s_invZero, o_zero);

	--And unit, sets s_andUnit_out
	andUnit0: and2t1_N generic map (32) port map(i_A, i_B, s_andUnit_out);
	
	--Or/Nor unit, sets s_orToNor_out
	OrUnit0: or2t1_N generic map (32) port map(i_A, i_B, s_orUnit_out);
	s_isNorMaster <= (others => s_isNor);
	orAndNorUnit0: xor2t1_N generic map (32) port map (s_orUnit_out, s_isNorMaster, s_orToNor_out);

	--Xor unit, sets s_xorUnit_out
	XorUnit0: xor2t1_N generic map (32) port map (i_A, i_B, s_xorUnit_out);
	
	--Shifter unit sets, s_shiftUnit_out
	shiftMux1: mux2t1_N generic map (5) port map (s_shiftSrc, i_shift, s_lui, s_shiftInput);
	barrelShifter0: barrel_shifter port map (s_shiftInput, i_B, s_shiftLR, s_shiftAr, s_shiftUnit_out);

	--repl unit sets, s_replUnit_out
	replicate0: repl port map (i_repl, s_replUnit_out);

	--slt unit sets, s_sltUnit_out
	slt0: slt_N generic map (32) port map (s_unSigned, s_AddSub_out, i_A, i_B, s_sltUnit_out);

	--final MUX sets o_ALUout
	outMux0: mux8t1 generic map (32) port map (s_ALUMuxCtl, s_shiftUnit_out, undefined, s_AddSub_out, s_andUnit_out, 								s_orToNor_out, s_xorUnit_out, s_sltUnit_out, s_replUnit_out, o_ALUout);

end structural;

