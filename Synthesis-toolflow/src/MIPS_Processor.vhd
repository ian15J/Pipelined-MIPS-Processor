-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- : this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

	component control_unit is 
	   port(i_Op       : in std_logic_vector(6-1 downto 0); 	-- input opcode
	       i_Funct    : in std_logic_vector(6-1 downto 0);	-- input function
	       o_Halt	  : out std_logic;			-- Halt signal
	       o_ALUsrc   : out std_logic;			-- output for ALU source, 0 for B, 1 for Imm
	       o_SignExt  : out std_logic;			-- output for imm sign extend, 0 for zero-extend, 1 for sign-extend
	       o_ALUop	  : out std_logic_vector(5-1 downto 0);	-- output for ALU opcode
	       o_MemToReg : out std_logic_vector(2-1 downto 0); -- output whether reg writes ALU, Dmem, PC, or repl.qb
	       s_DMemWr   : out std_logic;			-- whether dmem writes or not
	       s_RegWr	  : out std_logic;			-- whether RegFile writes or not
	       o_branch   : out std_logic;			-- whether branch instruction or not
	       o_jump     : out std_logic_vector(2-1 downto 0);	-- whether jump instruction or not
	       o_RegDst   : out std_logic_vector(2-1 downto 0); -- output whether RegFile dest input is rt, rd, or 31
	       o_invEq	  : out std_logic;			-- output whether beq or bne for conditional logic
	       o_pcSrc    : out std_logic;			-- output whether PC gets PC+4 or new address
	       o_DmemRead : out std_logic);			-- output if dmem is read from

	end component;

	component hazard_control is
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

	end component;

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
	component id_forward_control is
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

	end component;

	component mem_forward_control is
		  port(i_mem_DMemWr     : in std_logic;
		       i_Mem_Reg_Rd     : in std_logic_vector(4 downto 0);
		       i_Wb_Reg_Rd      : in std_logic_vector(4 downto 0);
		       i_Wb_RegWr	: in std_logic;
		       o_forward_E	: out std_logic);	

	end component;

	component ALU is 
	  port(i_ALUop	     : in std_logic_vector(5-1 downto 0); --ALUopcode
	       i_A	     : in std_logic_vector(32-1 downto 0); --ALU input A
	       i_B 	     : in std_logic_vector(32-1 downto 0); --ALU input B
	       i_shift	     : in std_logic_vector(5-1 downto 0); --shift amount
	       i_repl        : in std_logic_vector(8-1 downto 0); --repl input
	       o_OV	     : out std_logic; --overflow Flag
	       o_Zero	     : out std_logic; --zero Flag
	       o_Carry	     : out std_logic; --Carry Out
	       o_ALUout	     : out std_logic_vector(32-1 downto 0)); --ALU output

	end component;

	component RegFile32x32b is
	    port(i_rs : in std_logic_vector(4 downto 0); --read register 0
		 i_rt : in std_logic_vector(4 downto 0); --read register 1
		 i_rd : in std_logic_vector(4 downto 0); --write register
		 i_ld : in std_logic_vector(31 downto 0); --load data
		 i_CLK : in std_logic; --CLOCK
		 i_WE : in std_logic; --Write Enable
		 i_CLR : in std_logic; --CLEAR '1' is clear, '0' is hold
		 o_RD0 : out std_logic_vector(31 downto 0); --load data
		 o_RD1 : out std_logic_vector(31 downto 0)); --load data
	end component;


	component mux4t1_N is
	    generic(N : integer := 32);
	    port(i_S                  : in std_logic_vector(2-1 downto 0);
		 i_D0                 : in std_logic_vector(N-1 downto 0);
		 i_D1                 : in std_logic_vector(N-1 downto 0);
		 i_D2                 : in std_logic_vector(N-1 downto 0);
		 i_D3                 : in std_logic_vector(N-1 downto 0);
		 o_O                  : out std_logic_vector(N-1 downto 0));
	end component;

	component mux2t1_N is
	  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
	  port(i_S          : in std_logic;
	       i_D0         : in std_logic_vector(N-1 downto 0);
	       i_D1         : in std_logic_vector(N-1 downto 0);
	       o_O          : out std_logic_vector(N-1 downto 0));
	end component;

	component sign_extend is 
	  port(i_sign     : in std_logic;-- sign control
	       i_imm      : in std_logic_vector(16-1 downto 0);-- immediate input
	       o_ext      : out std_logic_vector(32-1 downto 0));-- extended output

	end component;

	component invg is
	  port(i_A          : in std_logic;
	       o_F          : out std_logic);
	end component;

	component pc_register_32 is
		  port(i_CLK        : in std_logic;     		-- Clock input
		       i_RST        : in std_logic;    			-- Reset input
		       i_WE         : in std_logic;     		-- Write enable input
		       i_D          : in std_logic_vector(32-1 downto 0);-- Data value input Nbit
		       o_Q          : out std_logic_vector(32-1 downto 0));-- Data value output Nbit
	end component;

	component full_add_N is
		generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32. with overflow flag
		port(i_C                 : in std_logic;
		 i_A                 : in std_logic_vector(N-1 downto 0);
		 i_B                 : in std_logic_vector(N-1 downto 0);
		 o_S                 : out std_logic_vector(N-1 downto 0);
		 o_C                 : out std_logic;
		 o_OV                : out std_logic);
	    end component;

	component Fetch is
	    port(i_Pc4 : in std_logic_vector(31 downto 0); 	--Pc + 4
		 i_Pc : in std_logic_vector(31 downto 0); 	--Pc
		 i_immExt : in std_logic_vector(31 downto 0);	--ImmExt
		 i_eq: in std_logic; 				--input from equals logic
		 i_jump: in std_logic_vector(1 downto 0); 	--Jump control
		 i_branch: in std_logic; 			--Branch conrol
		 i_JumpR: in std_logic_vector(31 downto 0);	--RegRead0
		 i_inst: in std_logic_vector(31 downto 0);
		 o_newAddr: out std_logic_vector(31 downto 0));
	end component;

	component eq_32 is
	    port(i_invEq : in std_logic; 			--Whether to invert the output or no
		 i_D0 : in std_logic_vector(31 downto 0);	--Value 1
		 i_D1: in std_logic_vector(31 downto 0); 	--Value 2
		 o_eq: out std_logic);				--output 1 if D0 = D1

	end component;

	--Global Signals
	signal undefined : std_logic_vector(31 downto 0);
	signal s_InvCLK : std_logic;

	--IF signals
	signal s_if_newPc : std_logic_vector(31 downto 0);
	signal s_if_Pc4 : std_logic_vector(31 downto 0);
        --signal s_if_Pc : std_logic_vector(31 downto 0);
	signal s_if_C : std_logic;
	signal s_if_OV : std_logic;
	signal s_PcWr : std_logic;

	signal s_IF_ID_Flush : std_logic;
	signal s_IF_ID_Stall : std_logic;

	component regIF_ID is
		port(i_CLK        	: in std_logic; -- Clock input
       		     i_RST        	: in std_logic; -- Reset input
       		     i_WE		: in std_logic; -- Write Enable
       		     i_flush		: in std_logic;	-- flush
       		     i_stall		: in std_logic; -- stall
       		     if_Inst         	: in std_logic_vector(31 downto 0); --Instruction signal from IF stage
       		     if_Pc4           	: in std_logic_vector(31 downto 0); --PC+4 signal from IF stage
		     if_Pc           	: in std_logic_vector(31 downto 0);
       		     o_id_Inst        	: out std_logic_vector(31 downto 0); --Instruction signal to ID stage
       		     o_id_Pc4		: out std_logic_vector(31 downto 0); --PC+4 signal to ID stage
		     o_id_Pc            : out std_logic_vector(31 downto 0));
	end component;

	--ID signals
	signal s_id_branch : std_logic;
	signal s_id_jump : std_logic_vector(2-1 downto 0);
	signal s_id_signExt : std_logic;
	signal s_id_PcSrc : std_logic;
	signal s_id_invEq : std_logic;
	signal s_id_jumpAddr : std_logic_vector(31 downto 0);
	signal s_id_Eq : std_logic;

	signal s_id_DmemRead : std_logic;
	signal s_id_MemtoReg : std_logic_vector(1 downto 0);
	signal s_id_RegWrite : std_logic;
	signal s_id_DMemWr : std_logic;
	signal s_id_ALUSrc : std_logic;
	signal s_id_RegDst : std_logic_vector(1 downto 0);
	signal s_id_Halt : std_logic;
	signal s_id_ALUOp : std_logic_vector(4 downto 0);
	signal s_id_ReadReg0 : std_logic_vector(31 downto 0);
	signal s_id_ReadReg1 : std_logic_vector(31 downto 0);
	signal s_id_ImmExt : std_logic_vector(31 downto 0);
	signal s_id_Inst : std_logic_vector(31 downto 0);
	signal s_id_Pc4 : std_logic_vector(31 downto 0);
        signal s_id_Pc : std_logic_vector(31 downto 0);
	signal s_id_Forward_C : std_logic_vector(1 downto 0);
	signal s_id_Forward_D : std_logic_vector(1 downto 0);
	signal s_id_Forward_F : std_logic_vector(1 downto 0);
	signal s_id_Forward_C_out : std_logic_vector(31 downto 0);
	signal s_id_Forward_D_out : std_logic_vector(31 downto 0);
	signal s_id_Forward_F_out : std_logic_vector(31 downto 0);

	signal s_ID_EX_Flush : std_logic;
	signal s_ID_EX_Stall : std_logic;

	component regID_EX is
		port(i_CLK		: in std_logic; --Clock
		     i_RST		: in std_logic; --Reset
		     i_WE		: in std_logic; --Write enable
       	 	     i_flush		: in std_logic;	-- flush
       		     i_stall		: in std_logic; -- stall
		     id_MemtoReg	: in std_logic_vector(1 downto 0); --MemtoReg control signal from ID stage
		     id_RegWrite	: in std_logic; --RegWrite control signal from ID stage
		     id_DMemWr		: in std_logic; --Dmem write back signal from ID stage
		     id_ALUSrc		: in std_logic; --ALU source control signal from ID stage
		     id_RegDst		: in std_logic_vector(1 downto 0); --Register destination control signal from ID stage
		     id_Halt		: in std_logic; --Halt signal from ID stage
		     id_DmemRead	: in std_logic;	--DmemRead from ID stage
		     id_ALUOp		: in std_logic_vector(4 downto 0); --ALU Op output signal from ID stage
		     if_Pc4		: in std_logic_vector(31 downto 0); --PC + 4 from IF stage
		     id_ReadReg0	: in std_logic_vector(31 downto 0); --Read register0 output signal from ID stage
		     id_ReadReg1	: in std_logic_vector(31 downto 0); --Read register1 output signal from ID stage
		     id_ImmExt		: in std_logic_vector(31 downto 0); --Immediate Extend output signal from ID stage
		     id_Inst		: in std_logic_vector(31 downto 0); --Instruction signal from ID stage
		     o_ex_MemtoReg	: out std_logic_vector(1 downto 0); --MemtoReg control signal to EX stage
		     o_ex_RegWrite	: out std_logic; --RegWrite control signal to EX stage
		     o_ex_DMemWr	: out std_logic; --Dmem write back signal to EX stage
		     o_ex_ALUSrc	: out std_logic; --ALU source control signal to EX stage
		     o_ex_RegDst	: out std_logic_vector(1 downto 0); --Register destination control signal to EX stage
		     o_ex_Halt		: out std_logic; --Halt signal to EX stage
		     o_ex_DmemRead	: out std_logic; --DmemRead to EX stage
		     o_ex_ALUOp		: out std_logic_vector(4 downto 0); --ALU Op output signal to EX stage
		     o_ex_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to EX stage
		     o_ex_ReadReg0	: out std_logic_vector(31 downto 0); --Read register0 output signal to EX stage
		     o_ex_ReadReg1	: out std_logic_vector(31 downto 0); --Read register1 output signal to EX stage
		     o_ex_ImmExt	: out std_logic_vector(31 downto 0); --Immediate Extend output signal to EX stage
		     o_ex_Inst		: out std_logic_vector(31 downto 0)); --Instruction signal to EX stage
	end component;
	
	--EX signals
	signal s_ex_Zero : std_logic;
	signal s_ex_Carryout : std_logic;
	signal s_ex_ALUSrc_out : std_logic_vector(31 downto 0);
	signal s_ex_RegDest_out : std_logic_vector(4 downto 0);
	signal s_ex_Forward_A : std_logic_vector(1 downto 0);
	signal s_ex_Forward_B : std_logic_vector(1 downto 0);
	signal s_ex_Forward_A_out : std_logic_vector(31 downto 0);
	signal s_ex_Forward_B_out : std_logic_vector(31 downto 0);

	signal s_ex_DmemRead : std_logic;
	signal s_ex_MemtoReg : std_logic_vector(1 downto 0);
	signal s_ex_RegWrite : std_logic;
	signal s_ex_DMemWr : std_logic;
	signal s_ex_ALUSrc : std_logic;
	signal s_ex_RegDst : std_logic_vector(1 downto 0);
	signal s_ex_Halt : std_logic;
	signal s_ex_ALUOp : std_logic_vector(4 downto 0);
	signal s_ex_ALUOut : std_logic_vector(31 downto 0);
	signal s_ex_ReadReg0 : std_logic_vector(31 downto 0);
	signal s_ex_ReadReg1 : std_logic_vector(31 downto 0);
	signal s_ex_ImmExt : std_logic_vector(31 downto 0);
	signal s_ex_Inst : std_logic_vector(31 downto 0);
	signal s_ex_Pc8 : std_logic_vector(31 downto 0);

	signal s_EX_MEM_Flush : std_logic;
	signal s_EX_MEM_Stall : std_logic;


	component regEX_MEM is
		port(i_CLK			: in std_logic; --Clock
			i_RST			: in std_logic; --Reset
			i_WE			: in std_logic; --Write enable
			i_flush			: in std_logic;	-- flush
	      		i_stall			: in std_logic; -- stall
			ex_MemtoReg		: in std_logic_vector(1 downto 0); --MemtoReg control signal from EX stage
			ex_Reg_Rd		: in std_logic_vector(4 downto 0); --Reg_Rd signal from EX stage
			ex_RegWrite		: in std_logic; --RegWrite control signal from EX stage
			ex_DMemWr		: in std_logic; --Dmem write back signal from EX stage
			ex_Halt			: in std_logic; --Halt signal from EX stage
			ex_DmemRead		: in std_logic;
			ex_Pc8			: in std_logic_vector(31 downto 0); --PC + 8 from EX stage
			ex_ALUOut		: in std_logic_vector(31 downto 0); --ALU output from EX stage
			ex_ReadReg1		: in std_logic_vector(31 downto 0); --Register output from EX stage
			o_mem_MemtoReg		: out std_logic_vector(1 downto 0); --MemtoReg control signal to MEM stage
			o_mem_Reg_Rd		: out std_logic_vector(4 downto 0); --Reg_Rd signal to MEM stage
			o_mem_RegWrite		: out std_logic; --RegWrite control signal to MEM stage
			o_mem_DMemWr		: out std_logic; --Dmem write back signal to MEM stage
			o_mem_Halt		: out std_logic; --Halt signal to MEM stage
			o_mem_DmemRead		: out std_logic;
		   	o_mem_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to MEM stage
			o_mem_ALUOut		: out std_logic_vector(31 downto 0); --ALU output signal to MEM stage
			o_mem_ReadReg1		: out std_logic_vector(31 downto 0)); --Register output signal to MEM stage
	end component;

	--MEM siganls
	signal s_mem_DmemRead : std_logic;
	signal s_mem_MemtoReg : std_logic_vector(1 downto 0);
	signal s_mem_Reg_Rd : std_logic_vector(4 downto 0);
	signal s_mem_RegWrite : std_logic;
	signal s_mem_DMemWr : std_logic;
	signal s_mem_Halt : std_logic;
	signal s_mem_DMemOut : std_logic_vector(31 downto 0);
	signal s_mem_ALUOut : std_logic_vector(31 downto 0);
	signal s_mem_ReadReg1 : std_logic_vector(31 downto 0);
	signal s_mem_Pc8 : std_logic_vector(31 downto 0);
	signal s_mem_Forward_E : std_logic;
	signal s_mem_Forward_E_out : std_logic_vector(31 downto 0);

	signal s_MEM_WB_Flush : std_logic;
	signal s_MEM_WB_Stall : std_logic;

	component regMEM_WB is
		port(i_CLK		: in std_logic; --Clock
		     i_RST		: in std_logic; --Reset
		     i_WE		: in std_logic; --Write enable
       		     i_flush		: in std_logic;	-- flush
       		     i_stall		: in std_logic; -- stall
		     mem_MemtoReg	: in std_logic_vector(1 downto 0); --MemtoReg control signal from MEM stage
		     mem_Reg_Rd		: in std_logic_vector(4 downto 0); --Reg_Rd signal from MEM stage
		     mem_RegWrite	: in std_logic; --RegWrite control signal from MEM stage
 		     mem_Halt		: in std_logic; --Halt signal from MEM stage
		     mem_Pc8		: in std_logic_vector(31 downto 0); --PC + 8 from EX stage
		     mem_DMemOut	: in std_logic_vector(31 downto 0); --Dmem output from MEM stage
		     mem_ALUOut		: in std_logic_vector(31 downto 0); --ALU output from MEM stage
		     o_wb_MemtoReg	: out std_logic_vector(1 downto 0); --MemtoReg control signal to WB stage
		     o_wb_Reg_Rd	: out std_logic_vector(4 downto 0); --Reg_Rd signal to WB stage
		     o_wb_RegWrite	: out std_logic; --RegWrite control signal to WB stage
		     o_wb_Halt		: out std_logic; --Halt signal to WB stage
		     o_wb_Pc8		: out std_logic_vector(31 downto 0); --PC + 8 to EX stage
		     o_wb_DMemOut	: out std_logic_vector(31 downto 0); --Dmem output signal to WB stage
		     o_wb_ALUOut	: out std_logic_vector(31 downto 0)); --ALU output signal to WB stage
	end component;

	--WB signals
	signal s_wb_Pc8 : std_logic_vector(31 downto 0);	
	signal s_wb_MemtoReg : std_logic_vector(1 downto 0);
	signal s_wb_RegWrite : std_logic;
	signal s_wb_DMemOut : std_logic_vector(31 downto 0);
	signal s_wb_ALUOut : std_logic_vector(31 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Implement the rest of your processor below this comment! 

  --Pipeline Stages
  --------------------------IF Stage--------------------------
  
  --PC Fetch Logic
  PCMux0: mux2t1_N generic map (32) port map(s_id_PcSrc, s_if_Pc4, s_id_jumpAddr, s_if_newPc);
  PC: pc_register_32 port map(iCLK, iRST, s_PcWr, s_if_newPc, s_NextInstAddr);
  Add_4: full_add_N generic map (32) port map('0', s_NextInstAddr, x"00000004", s_if_Pc4, s_if_C, s_if_OV); 

  --Imem Goes Here, defined above


  IF_ID_stage: regIF_ID port map(iCLK, iRST, '1', s_IF_ID_Flush, s_IF_ID_Stall, s_Inst, s_if_Pc4, s_NextInstAddr, s_id_Inst, s_id_Pc4, s_id_Pc);
  --------------------------ID Statge--------------------------

  --: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  --Control Logic
  ControlLogic0: control_unit port map (s_id_Inst(31 downto 26), s_id_Inst(5 downto 0), s_id_Halt, s_id_ALUSrc, s_id_SignExt, s_id_ALUOp, s_id_MemtoReg, s_id_DMemWr, s_id_RegWrite, s_id_branch, s_id_jump, s_id_RegDst, s_id_invEq, s_id_PcSrc, s_id_DmemRead);

  --Hazard Detection
  HazardDetectionUnit: hazard_control port map(s_id_Inst, s_ex_Inst(20 downto 16), s_ex_RegDest_out, s_mem_Reg_Rd, s_RegWrAddr, s_ex_DmemRead, s_mem_DmemRead, s_id_branch, s_id_Eq, s_id_jump, s_PcWr, s_IF_ID_Flush, s_IF_ID_Stall, s_ID_EX_Flush, s_ID_EX_Stall, s_EX_MEM_Flush, s_EX_MEM_Stall, s_MEM_WB_Flush, s_MEM_WB_Stall);

  --InvClock
    InvCLK: invg port map(iCLK, s_InvCLK);

  --RegFile
  RegFile0: RegFile32x32b port map(s_id_Inst(25 downto 21), s_id_Inst(20 downto 16), s_RegWrAddr, s_RegWrData, s_InvCLK, s_RegWr, iRST, s_id_ReadReg0, s_id_ReadReg1);

  --SignExt
  signExt0: sign_extend port map (s_id_SignExt, s_id_Inst(15 downto 0), s_id_immExt);

--id Forward logic
  IdForwardControlUnit: id_forward_control port map(s_id_branch, s_id_jump, s_id_Inst(25 downto 21), s_id_Inst(20 downto 16), s_ex_RegDest_out, s_mem_Reg_Rd, s_RegWrAddr, s_ex_RegWrite, s_mem_RegWrite, s_RegWr, s_id_Forward_C, s_id_Forward_D, s_id_Forward_F);

--ForwardC/D MUX
  ForwardMux_C: mux4t1_N generic map (32) port map (s_id_Forward_C, s_id_ReadReg0, s_RegWrData, s_mem_ALUOut, s_ex_ALUOut, s_id_Forward_C_out);
  ForwardMux_D: mux4t1_N generic map (32) port map (s_id_Forward_D, s_id_ReadReg1, s_RegWrData, s_mem_ALUOut, s_ex_ALUOut, s_id_Forward_D_out);
  ForwardMux_F: mux4t1_N generic map (32) port map (s_id_Forward_F, s_id_ReadReg0, s_RegWrData, s_mem_Pc8, s_ex_Pc8, s_id_Forward_F_out);

  --Eq Logic
  Eq0: eq_32 port map (s_id_invEq, s_id_Forward_C_out, s_id_Forward_D_out, s_id_Eq);

  --Branch and Jump Logic
  fetch0: Fetch port map (s_if_Pc4, s_id_Pc4, s_id_immExt, s_id_Eq, s_id_jump, s_id_branch, s_id_Forward_F_out, s_id_Inst, s_id_jumpAddr);
--s_if_Pc4

  ID_EX_stage: regID_EX port map(iCLK, iRST, '1', s_ID_EX_Flush, s_ID_EX_Stall, s_id_MemtoReg, s_id_RegWrite, s_id_DMemWr, s_id_ALUSrc, s_id_RegDst, s_id_Halt, s_id_DmemRead, s_id_ALUOp, s_id_Pc4, s_id_ReadReg0, s_id_ReadReg1, s_id_immExt, s_id_Inst, s_ex_MemtoReg, s_ex_RegWrite, s_ex_DMemWr, s_ex_ALUSrc, s_ex_RegDst, s_ex_Halt, s_ex_DmemRead, s_ex_ALUOp, s_ex_Pc8, s_ex_ReadReg0, s_ex_ReadReg1, s_ex_ImmExt, s_ex_Inst);
  --------------------------EX Stage--------------------------

  --ALUsrc
  --aluSrcMux0: mux2t1_N generic map (32) port map (s_ex_ALUSrc, s_ex_ReadReg1, s_ex_immExt, s_ex_ALUSrc_out);
    aluSrcMux0: mux2t1_N generic map (32) port map (s_ex_ALUSrc, s_ex_Forward_B_out, s_ex_immExt, s_ex_ALUSrc_out);

  --ForwardA/B MUX
  ForwardMux_A: mux4t1_N generic map (32) port map (s_ex_Forward_A, s_ex_ReadReg0, s_RegWrData, s_mem_ALUOut, undefined, s_ex_Forward_A_out);
  --ForwardMux_B: mux4t1_N generic map (32) port map (s_ex_Forward_B, s_ex_ALUSrc_out, s_RegWrData, s_mem_ALUOut, undefined, s_ex_Forward_B_out);
    ForwardMux_B: mux4t1_N generic map (32) port map (s_ex_Forward_B, s_ex_ReadReg1, s_RegWrData, s_mem_ALUOut, undefined, s_ex_Forward_B_out);

  --: Ensure that s_Ovfl is connected to the overflow output of your ALU
  --ALU
  --ALU0: ALU port map(s_ex_ALUOp, s_ex_Forward_A_out, s_ex_Forward_B_out, s_ex_Inst(10 downto 6), s_ex_Inst(23 downto 16), s_Ovfl, s_ex_Zero, s_ex_Carryout, s_ex_ALUOut);
    ALU0: ALU port map(s_ex_ALUOp, s_ex_Forward_A_out, s_ex_ALUSrc_out, s_ex_Inst(10 downto 6), s_ex_Inst(23 downto 16), s_Ovfl, s_ex_Zero, s_ex_Carryout, s_ex_ALUOut);

  oALUOut <=  s_ex_ALUOut;

  regDestMux0: mux4t1_N generic map (5) port map (s_ex_RegDst, s_ex_Inst(20 downto 16), s_ex_Inst(15 downto 11), "11111", "-----", s_ex_RegDest_out);

  ForwardControlUnit: forward_control port map(s_ex_Inst(25 downto 21), s_ex_Inst(20 downto 16), s_mem_RegWrite, s_mem_Reg_Rd, s_RegWr, s_RegWrAddr, s_ex_Forward_A, s_ex_Forward_B);

  EX_MEM_stage: regEX_MEM port map(iCLK, iRST, '1', s_EX_MEM_Flush, s_EX_MEM_Stall, s_ex_MemtoReg, s_ex_RegDest_out, s_ex_RegWrite, s_ex_DMemWr, s_ex_Halt, s_ex_DmemRead, s_ex_Pc8, s_ex_ALUOut, s_ex_Forward_B_out, s_mem_MemtoReg, s_mem_Reg_Rd, s_mem_RegWrite, s_mem_DMemWr, s_mem_Halt, s_mem_DmemRead, s_mem_Pc8, s_mem_ALUOut, s_mem_ReadReg1);
  --------------------------MEM Stage--------------------------

  s_DMemAddr <= s_mem_ALUOut;
  s_DMemData <= s_mem_Forward_E_out;
  s_DMemWr <= s_mem_DMemWr;
  --Dmem Goes Here, defined above

  --mem Forward logic
  memForwardControlUnit: mem_forward_control port map(s_mem_DMemWr, s_mem_Reg_Rd, s_RegWrAddr, s_RegWr, s_mem_Forward_E);

 --Forward E mux
    ForwardMux_E: mux2t1_N generic map (32) port map (s_mem_Forward_E, s_mem_ReadReg1, s_RegWrData, s_mem_Forward_E_out);

  MEM_WB_stage: regMEM_WB port map(iCLK, iRST, '1', s_MEM_WB_Flush, s_MEM_WB_Stall, s_mem_MemtoReg, s_mem_Reg_Rd, s_mem_RegWrite, s_mem_Halt, s_mem_Pc8, s_DMemOut, s_mem_ALUOut, s_wb_MemtoReg, s_RegWrAddr, s_RegWr, s_Halt, s_wb_Pc8, s_wb_DMemOut, s_wb_ALUOut);
  --------------------------WB Stage--------------------------

  memToRegMux0: mux4t1_N generic map (32) port map (s_wb_MemtoReg, s_wb_ALUOut, s_wb_DMemOut, s_wb_PC8, undefined, s_RegWrData);

 
end structure;


