-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the ALU
--
-- NOTES:
-- 10/14/21
-- 10/16/21 Updated Ian Johnson
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns);
end tb_ALU;

architecture behavior of tb_ALU is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


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

  signal s_CLK : std_logic;
  -- Temporary signals
  signal s_ALUop : std_logic_vector(5-1 downto 0):= (others => '0');
  signal s_A	 : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_B	 : std_logic_vector(32-1 downto 0):= (others => '0');
  signal s_shift : std_logic_vector(5-1 downto 0):= (others => '0');
  signal s_repl	 : std_logic_vector(8-1 downto 0):= (others => '0');
  signal s_OV	 : std_logic;
  signal s_Zero	 : std_logic;
  signal s_Carry : std_logic;
  signal s_ALUout: std_logic_vector(32-1 downto 0);	


begin

  DUT: ALU port map(s_ALUop, s_A, s_B, s_shift, s_repl, s_OV, s_Zero, s_Carry, s_ALUout);

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
    --Test ADD
    s_ALUop <= "00101";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000
    --s_OV should be 0
    --s_Zero = 1

    --Test ADD
    s_ALUop <= "00101";
    s_A <= x"0F010001";
    s_B <= x"F0010010";
    wait for cCLK_PER;
    --s_ALUout = 0xFF020011
    --s_zero should be -
    --s_OV should be 0

    --Test ADD
    s_ALUop <= "00101";
    s_A <= x"FFFFFFFF";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0xFFFFFFFF
    --s_OV should be 0

    --Test ADD
    s_ALUop <= "00101";
    s_A <= x"7FFFFFFF";
    s_B <= x"40000001";
    wait for cCLK_PER;
    --s_ALUout = 0xC0000000
    --s_OV should be 1

    --Test ADDU
    s_ALUop <= "10101";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000
    --s_OV should be 0
    --s_Zero = 1

    --Test ADDU
    s_ALUop <= "10101";
    s_A <= x"0F010001";
    s_B <= x"F0010010";
    wait for cCLK_PER;
    --s_ALUout = 0xFF020011
    --s_OV should be 0

    --Test ADDU
    s_ALUop <= "10101";
    s_A <= x"FFFFFFFF";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0xFFFFFFFF
    --s_OV should be 0

    --Test ADDU
    s_ALUop <= "10101";
    s_A <= x"7FFFFFFF";
    s_B <= x"40000001";
    wait for cCLK_PER;
    --s_ALUout = 0xC0000000
    --s_OV should be 0

    --Test SUB
    s_ALUop <= "00110";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000
    --s_OV should be 0
    --s_Zero = 1

    --Test SUB
    s_ALUop <= "00110";
    s_A <= x"FFFFFFFF"; --FFFFFFFF
    s_B <= x"00000001"; --FFFFFFFF
    wait for cCLK_PER;  --FFFFFFFE
    --s_ALUout = 0xFFFFFFFE
    --s_OV should be 0

    --Test SUB
    s_ALUop <= "00110";
    s_A <= x"FFFFFFFE"; --FFFFFFFE
    s_B <= x"7FFFFFFF"; --80000001
    wait for cCLK_PER;  --7FFFFFFF
    --s_ALUout = 0x7FFFFFFF
    --s_OV should be 1

    --Test SUBU
    s_ALUop <= "10110";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000
    --s_OV should be 0
    --s_Zero = 1

    --Test SUBU
    s_ALUop <= "10110";
    s_A <= x"FFFFFFFF"; --FFFFFFFF
    s_B <= x"00000001"; --FFFFFFFF
    wait for cCLK_PER;  --FFFFFFFE
    --s_ALUout = 0xFFFFFFFE
    --s_OV should be 0

    --Test SUBU
    s_ALUop <= "10110";
    s_A <= x"FFFFFFFE"; --FFFFFFFE
    s_B <= x"7FFFFFFF"; --80000001
    wait for cCLK_PER;  --7FFFFFFF
    --s_ALUout = 0x7FFFFFFF
    --s_OV should be 0

    --Test AND
    s_ALUop <= "00111";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test AND
    s_ALUop <= "00111";
    s_A <= x"FFFFFFFF";
    s_B <= x"76543210";
    wait for cCLK_PER;
    --s_ALUout = 0x76543210

    --Test AND
    s_ALUop <= "00111";
    s_A <= x"76543210";
    s_B <= x"F0F0F170";
    wait for cCLK_PER;
    --s_ALUout = 0x70503010
    --s_OV should be 0

    --Test OR
    s_ALUop <= "01000";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test OR
    s_ALUop <= "01000";
    s_A <= x"00FFFFFF";
    s_B <= x"7F000101";
    wait for cCLK_PER;
    --s_ALUout = 0x7FFFFFFF

    --Test OR
    s_ALUop <= "01000";
    s_A <= x"FFF0FFF0";
    s_B <= x"76543210";
    wait for cCLK_PER;
    --s_ALUout = 0xFFF4FFF0
    --s_OV should be 0

    --Test XOR
    s_ALUop <= "01001";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test XOR
    s_ALUop <= "01001";
    s_A <= x"00FFFFFF";
    s_B <= x"7F000101";
    wait for cCLK_PER;
    --s_ALUout = 0x7FFFFEFE

    --Test XOR
    s_ALUop <= "01001";
    s_A <= x"FFF0FFF0";
    s_B <= x"76543210";
    wait for cCLK_PER;
    --s_ALUout = 0x89A4CDE0
    --s_OV should be 0

    --Test NOR
    s_ALUop <= "01010";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0xFFFFFFFF

    --Test NOR
    s_ALUop <= "01010";
    s_A <= x"00FFFFFF";
    s_B <= x"7F000101";
    wait for cCLK_PER;
    --s_ALUout = 0x80000000

    --Test NOR
    s_ALUop <= "01010";
    s_A <= x"FFF0FFF0";
    s_B <= x"76543210";
    wait for cCLK_PER;
    --s_ALUout = 0x000B000F
    --s_OV should be 0

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT pos - pos
    s_ALUop <= "01011";
    s_A <= x"00000001";--(1)
    s_B <= x"0000000a";--(10)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"0000000A";--(10)
    s_B <= x"00000001";--(1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT neg - neg
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"FFFFFFFF";--(-1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"00000000";--(0)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLT pos -neg
    s_ALUop <= "01011";
    s_A <= x"0000000A";--(10)
    s_B <= x"FFFFFFFF";--(-1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"0000000A";--(10)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"0000000A";--(10)
    s_B <= x"00000000";--(0)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLT neg - pos
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"0000000A";--(10)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"00000004";--(4)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLT
    s_ALUop <= "01011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"00000000";
    s_B <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU pos - pos
    s_ALUop <= "11011";
    s_A <= x"00000001";--(1)
    s_B <= x"0000000A";--(10)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"0000000A";--(10)
    s_B <= x"00000001";--(1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU neg - neg
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"FFFFFFFF";--(-1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"00000000";--(0)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU pos -neg
    s_ALUop <= "11011";
    s_A <= x"0000000A";--(10)
    s_B <= x"FFFFFFFF";--(-1)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"0000000A";--(10)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"0000000A";--(10)
    s_B <= x"00000000";--(0)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU neg - pos
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFF";--(-1)
    s_B <= x"0000000A";--(10)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"00000004";--(4)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test SLTU
    s_ALUop <= "11011";
    s_A <= x"FFFFFFFE";--(-2)
    s_B <= x"FFFFFFFE";--(-2)
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test REPL.qb
    s_ALUop <= "01100";
    s_repl <= x"00";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test REPL.qb
    s_ALUop <= "01100";
    s_repl <= x"1F";
    wait for cCLK_PER;
    --s_ALUout = 0x1F1F1F1F

    --Test REPL.qb
    s_ALUop <= "01100";
    s_repl <= x"48";
    wait for cCLK_PER;
    --s_ALUout = 0x48484848

    --Test Sll
    s_ALUop <= "00000";
    s_A <= x"80001001";
    s_shift <= "00000";
    wait for cCLK_PER;
    --s_ALUout = 0x80001001

    --Test Sll
    s_ALUop <= "00000";
    s_A <= x"80001001";
    s_shift <= "00100";
    wait for cCLK_PER;
    --s_ALUout = 0x00010010

    --Test Sll
    s_ALUop <= "00000";
    s_A <= x"80001001";
    s_shift <= "11111";
    wait for cCLK_PER;
    --s_ALUout = 0x80000000

    --Test Srl
    s_ALUop <= "00010";
    s_A <= x"80001001";
    s_shift <= "00000";
    wait for cCLK_PER;
    --s_ALUout = 0x80001001

    --Test Srl
    s_ALUop <= "00010";
    s_A <= x"80001001";
    s_shift <= "00100";
    wait for cCLK_PER;
    --s_ALUout = 0x08000100

    --Test Srl
    s_ALUop <= "00010";
    s_A <= x"80001001";
    s_shift <= "11111";
    wait for cCLK_PER;
    --s_ALUout = 0x00000001

    --Test Sra
    s_ALUop <= "00011";
    s_A <= x"80001001";
    s_shift <= "00000";
    wait for cCLK_PER;
    --s_ALUout = 0x80001001

    --Test Sra
    s_ALUop <= "00011";
    s_A <= x"80001001";
    s_shift <= "00100";
    wait for cCLK_PER;
    --s_ALUout = 0xF8000100

    --Test Sra
    s_ALUop <= "00011";
    s_A <= x"40001001";
    s_shift <= "00100";
    wait for cCLK_PER;
    --s_ALUout = 0x040000100

    --Test Sra
    s_ALUop <= "00011";
    s_A <= x"80001001";
    s_shift <= "11111";
    wait for cCLK_PER;
    --s_ALUout = 0xFFFFFFFF

    --Test Sra
    s_ALUop <= "00011";
    s_A <= x"40001001";
    s_shift <= "11111";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test Lui
    s_ALUop <= "00100";
    s_A <= x"40001001";
    wait for cCLK_PER;
    --s_ALUout = 0x10010000

    --Test Lui
    s_ALUop <= "00100";
    s_A <= x"00000000";
    wait for cCLK_PER;
    --s_ALUout = 0x00000000

    --Test Lui
    s_ALUop <= "00100";
    s_A <= x"FFFFFFFF";
    wait for cCLK_PER;
    --s_ALUout = 0xFFFF0000

    wait;
  end process;
  
end behavior;
