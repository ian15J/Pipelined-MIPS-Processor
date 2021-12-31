-------------------------------------------------------------------------
-- Bailey Gorlewski
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_pipeline_update.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of hardware pipeline update
-- 
--
--
-- NOTES:
-- 12/2/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pipeline_update is
    generic(gCLK_HPER   : time := 10 ns);
end tb_pipeline_update;

architecture behavior of tb_pipeline_update is
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component regIF_ID is
        port(i_CLK        	: in std_logic; -- Clock input
             i_RST        	: in std_logic; -- Reset input
             i_WE		: in std_logic; -- Write Enable
             i_flush		: in std_logic;	-- flush
             i_stall		: in std_logic; -- stall
             if_Inst         	: in std_logic_vector(31 downto 0); --Instruction signal from IF stage
             if_Pc4           : in std_logic_vector(31 downto 0); --PC+4 signal from IF stage
             o_id_Inst        : out std_logic_vector(31 downto 0); --Instruction signal to ID stage
             o_id_Pc4		: out std_logic_vector(31 downto 0)); --PC+4 signal to ID stage
    end component;

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


    signal s_IF_flush : std_logic ; 
    signal s_IF_stall : std_logic;
    signal s_ID_flush : std_logic;
    signal S_ID_stall : std_logic;
    signal s_EX_flush : std_logic;
    signal s_EX_stall : std_logic;
    signal s_MEM_flush : std_logic;
    signal S_MEM_stall : std_logic;
    signal s_CLK: std_logic;
    signal s_WE: std_logic;
    signal s_RST: std_logic;
    signal s_if_Inst : std_logic_vector(31 downto 0) := (others => '0');
    signal s_if_Pc4 : std_logic_vector(31 downto 0); 
    signal s_o_id_Inst:  std_logic_vector(31 downto 0):= (others => '0') ; 
    signal s_o_id_Pc4 :  std_logic_vector(31 downto 0):= (others => '0'); 

    signal s_id_MemtoReg	:  std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_id_RegWrite	:  std_logic; 
    signal s_id_DMemWr		:  std_logic; 
    signal s_id_ALUSrc		:  std_logic; 
    signal s_id_RegDst		:  std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_id_Halt		:  std_logic; 
    signal s_id_DmemRead	:  std_logic;	
    signal s_id_ALUOp		:  std_logic_vector(4 downto 0):= (others => '0'); 
    signal s_id_ReadReg0	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_id_ReadReg1	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_id_ImmExt		:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_ex_MemtoReg	:  std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_o_ex_RegWrite	:  std_logic; 
    signal s_o_ex_DMemWr	:  std_logic; 
    signal s_o_ex_ALUSrc	:  std_logic; 
    signal s_o_ex_RegDst	:  std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_o_ex_Halt		:  std_logic; 
    signal s_o_ex_DmemRead	:  std_logic; 
    signal s_o_ex_ALUOp		:  std_logic_vector(4 downto 0):= (others => '0'); 
    signal s_o_ex_Pc8		:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_ex_ReadReg0	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_ex_ReadReg1	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_ex_ImmExt	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_ex_Inst		:  std_logic_vector(31 downto 0):= (others => '0'); 

    
    signal s_ex_Reg_Rd		:  std_logic_vector(4 downto 0):= (others => '0'); 
    signal s_o_mem_MemtoReg		:  std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_o_mem_Reg_Rd		: std_logic_vector(4 downto 0):= (others => '0'); 
    signal s_o_mem_RegWrite		:  std_logic; 
    signal s_o_mem_DMemWr		:  std_logic; 
    signal s_o_mem_Halt		:  std_logic; 
    signal s_o_mem_DmemRead		:  std_logic;
    signal s_o_mem_Pc8		:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_mem_ALUOut		:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_mem_ReadReg1		:  std_logic_vector(31 downto 0):= (others => '0'); 

    

    signal s_o_wb_MemtoReg	: std_logic_vector(1 downto 0):= (others => '0'); 
    signal s_o_wb_Reg_Rd	:  std_logic_vector(4 downto 0):= (others => '0'); 
    signal s_o_wb_RegWrite	:  std_logic; 
    signal s_o_wb_Halt		:  std_logic; 
    signal s_o_wb_Pc8		:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_wb_DMemOut	:  std_logic_vector(31 downto 0):= (others => '0'); 
    signal s_o_wb_ALUOut	:  std_logic_vector(31 downto 0):= (others => '0'); 
    
    signal s_Dmem_out : std_logic_vector(31 downto 0):= (others => '0');
    


    begin
        s_ex_Reg_Rd <= s_if_Inst(20 downto 16);
        s_Dmem_out <= x"11111111";

        regIFID: regIF_ID port map(s_CLK, s_RST, s_WE, s_IF_flush, s_IF_stall, s_if_Inst, s_if_Pc4, s_o_id_Inst, s_o_id_Pc4);

        regIDEX: regID_EX port map(s_CLK, s_RST, s_WE, s_ID_flush, s_ID_stall, s_id_MemtoReg, s_id_RegWrite, s_id_DMemWr, s_id_ALUSrc,
                                   s_id_RegDst, s_id_Halt, s_id_DmemRead, s_id_ALUOp, s_o_id_Pc4, s_id_ReadReg0, s_id_ReadReg1, s_id_ImmExt,
                                   s_o_id_Inst, s_o_ex_MemtoReg, s_o_ex_RegWrite, s_o_ex_DMemWr, s_o_ex_ALUSrc, s_o_ex_RegDst, s_o_ex_Halt,
                                   s_o_ex_DmemRead, s_o_ex_ALUOp, s_o_ex_Pc8, s_o_ex_ReadReg0, s_o_ex_ReadReg1, s_o_ex_ImmExt, s_o_ex_Inst);

        regEXMEM: regEX_MEM port map(s_CLK, s_RST, s_WE, s_EX_flush, s_EX_stall, s_o_ex_MemtoReg, s_ex_Reg_Rd, s_o_ex_RegWrite, s_o_ex_DMemWr,  
                                     s_o_ex_Halt, s_o_ex_DmemRead, s_o_ex_Pc8, x"10101010", s_o_ex_ReadReg1, s_o_mem_MemtoReg, s_o_mem_Reg_Rd,
                                     s_o_mem_RegWrite, s_o_mem_DMemWr, s_o_mem_Halt, s_o_mem_DmemRead, s_o_mem_Pc8, s_o_mem_ALUOut, s_o_mem_ReadReg1);		
    
        regMEMWB: regMEM_WB port map(s_CLK, s_RST, s_WE, s_MEM_flush,s_MEM_stall, s_o_mem_MemtoReg, s_o_mem_Reg_Rd, s_o_mem_RegWrite, s_o_mem_Halt, s_o_mem_Pc8,
                                        s_Dmem_out, s_o_mem_ALUOut, s_o_wb_MemtoReg, s_o_wb_Reg_Rd, s_o_wb_RegWrite, s_o_wb_Halt, s_o_wb_Pc8, s_o_wb_DMemOut, s_o_wb_ALUOut);

        P_CLK: process
        begin
          s_CLK <= '0';
          wait for gCLK_HPER;
          s_CLK <= '1';
          wait for gCLK_HPER;
        end process;

        P_TB: process
        begin
            -- Test case 1 -No flushes or stalls 
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;

            -- Test case 2 -- Flush IF register 
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '1';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_IF_flush <= '0';

	    wait for cCLK_PER;
    
	   -- Test case 3 -- Flush ID register 
	    s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '1';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_ID_flush <= '0';
	    wait for cCLK_PER;
    
	   -- Test case 4 -- Flush EX register 
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '1';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_EX_flush <= '0';
	    wait for cCLK_PER;
    

	   -- Test case 5 -- Flush MEM register 
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '1';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_MEM_flush <= '0';
	    wait for cCLK_PER;
      
	  -- Test case 6 -- Values can inserted every cycle
	        s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
	    s_id_ImmExt <= x"11111111";
	    wait for cCLK_PER;
	    s_id_ImmExt <= x"FFFFFFFF";
	    wait for cCLK_PER;
	    s_id_ImmExt <= x"00000000";
	    wait for cCLK_PER;
	    s_id_ImmExt <= x"22222222";
        wait for cCLK_PER;
        
       
        -- Test case 7 -- Stall IF stage
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_IF_stall <= '1';
            s_if_Inst <= x"FFFFFFFF";
            wait for cCLK_PER;
            s_IF_stall <= '0';
            wait for cCLK_PER;
          

        -- Test case 8 -- Stall ID stage
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            S_ID_stall <= '1';
            s_id_ImmExt <= x"11111111";
            wait for cCLK_PER;
            S_ID_stall <= '0';
            wait for cCLK_PER;
       

        -- Test case 9 -- Stall EX stage
             s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            s_EX_stall <= '1';
            s_o_ex_ReadReg1 <=  x"1F1F1F1F";
            wait for cCLK_PER;
            s_EX_stall <= '0';
            wait for cCLK_PER;

        -- Test case 10 -- Stall mem stage
            s_WE <= '1';
            s_RST <= '0';
            s_IF_flush <= '0';
            s_IF_stall <= '0';
            s_if_Inst <= x"10101010";
            s_if_Pc4 <= x"10101010";
            s_ID_flush <= '0';
            S_ID_stall <= '0';
            s_EX_flush <= '0';
            s_EX_stall <= '0';
            s_MEM_flush <= '0';
            S_MEM_stall <= '0';
            s_id_MemtoReg <= "10";
            s_id_RegWrite <= '1';
            s_id_DMemWr <= '1';
            s_id_ALUSrc <= '1';
            s_id_RegDst <= "10";
            s_id_Halt <= '0';
            s_id_DmemRead <= '1';
            s_id_ALUOp <= "11111";
            s_id_ReadReg0 <= x"10101010";
            s_id_ReadReg1 <= x"10101010";
            s_id_ImmExt <= x"00000000";
            wait for cCLK_PER;
            S_MEM_stall <= '1';
            s_Dmem_out <= x"F1F1F1F1";
            wait for cCLK_PER;
            S_MEM_stall <= '0';
        wait;
        end process;
      	



end behavior;
