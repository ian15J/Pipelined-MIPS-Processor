-------------------------------------------------------------------------
-- Ian Johnson
-- Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- RegFile32x32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Register File with 32 registers holding 32 bits
--
--
-- NOTES:
-- 9/16/21
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--define ports
entity RegFile32x32b is
    port(i_rs : in std_logic_vector(4 downto 0); --read register 0
	 i_rt : in std_logic_vector(4 downto 0); --read register 1
	 i_rd : in std_logic_vector(4 downto 0); --write register
	 i_ld : in std_logic_vector(31 downto 0); --load data
	 i_CLK : in std_logic; --CLOCK
	 i_WE : in std_logic; --Write Enable
	 i_CLR : in std_logic; --CLEAR '1' is clear, '0' is hold
	 o_RD0 : out std_logic_vector(31 downto 0); --load data
	 o_RD1 : out std_logic_vector(31 downto 0)); --load data
end RegFile32x32b;

--define architecture
architecture structural of RegFile32x32b is
	-- register
	component register_N is
  	  generic(N : integer := 32);
  	  port(i_CLK        : in std_logic;     			-- Clock input
      	       i_RST        : in std_logic;    			-- Reset input
     	       i_WE         : in std_logic;     			-- Write enable input
     	       i_D          : in std_logic_vector(N-1 downto 0);	-- Data value input Nbit
     	       o_Q          : out std_logic_vector(N-1 downto 0));-- Data value output Nbit
 
	end component;

	component sp_register_32 is
	  port(i_CLK        : in std_logic;     		-- Clock input
	       i_RST        : in std_logic;    			-- Reset input
	       i_WE         : in std_logic;     		-- Write enable input
	       i_D          : in std_logic_vector(32-1 downto 0);-- Data value input Nbit
	       o_Q          : out std_logic_vector(32-1 downto 0));-- Data value output Nbit

	end component;

	component gp_register_32 is
	  port(i_CLK        : in std_logic;     		-- Clock input
	       i_RST        : in std_logic;    			-- Reset input
	       i_WE         : in std_logic;     		-- Write enable input
	       i_D          : in std_logic_vector(32-1 downto 0);-- Data value input Nbit
	       o_Q          : out std_logic_vector(32-1 downto 0));-- Data value output Nbit

	end component;

	-- decoder
	component decoder5t32 is 
	  port(i_EN	    : in std_logic; 			--enable
	       i_S          : in std_logic_vector(5-1 downto 0);-- decoder select
	       o_Q          : out std_logic_vector(32-1 downto 0));-- decoder output

	end component;

	-- mux
	component mux32t1_N is 
	  generic(N : integer := 32);
	  port(i_S          : in std_logic_vector(5-1 downto 0);-- mux select
	       i_D0	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D1	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D2	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D3	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D4	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D5	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D6	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D7	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D8	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D9	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D10	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D11	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D12	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D13	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D14	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D15	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D16	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D17	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D18	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D19	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D20	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D21	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D22	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D23	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D24	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D25	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D26	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D27	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D28	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D29	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D30	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       i_D31	    : in std_logic_vector(N-1 downto 0); --input signals, N bits wide
	       o_Q          : out std_logic_vector(N-1 downto 0));-- mux output

	end component;

	--intermidiate signals
	signal dec1_out : std_logic_vector(31 downto 0); 
	signal reg0_out,reg1_out,reg2_out,reg3_out,reg4_out,reg5_out,reg6_out,reg7_out,reg8_out,
		reg9_out,reg10_out,reg11_out,reg12_out,reg13_out,reg14_out,reg15_out,reg16_out,reg17_out,
		reg18_out,reg19_out,reg20_out,reg21_out,reg22_out,reg23_out,reg24_out,reg25_out,reg26_out,
		reg27_out,reg28_out,reg29_out,reg30_out,reg31_out : std_logic_vector(31 downto 0);
begin
	dec1: decoder5t32 port map(i_WE, i_rd, dec1_out);

	reg0: register_N generic map (32) port map(i_CLK, '1', dec1_out(0), i_ld, reg0_out); --$zero should be 0x00000000 always, so clear is high
	reg1: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(1), i_ld, reg1_out);
	reg2: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(2), i_ld, reg2_out);
	reg3: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(3), i_ld, reg3_out);
	reg4: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(4), i_ld, reg4_out);
	reg5: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(5), i_ld, reg5_out);
	reg6: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(6), i_ld, reg6_out);
	reg7: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(7), i_ld, reg7_out);
	reg8: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(8), i_ld, reg8_out);
	reg9: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(9), i_ld, reg9_out);
	reg10: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(10), i_ld, reg10_out);
	reg11: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(11), i_ld, reg11_out);
	reg12: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(12), i_ld, reg12_out);
	reg13: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(13), i_ld, reg13_out);
	reg14: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(14), i_ld, reg14_out);
	reg15: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(15), i_ld, reg15_out);
	reg16: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(16), i_ld, reg16_out);
	reg17: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(17), i_ld, reg17_out);
	reg18: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(18), i_ld, reg18_out);
	reg19: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(19), i_ld, reg19_out);
	reg20: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(20), i_ld, reg20_out);
	reg21: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(21), i_ld, reg21_out);
	reg22: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(22), i_ld, reg22_out);
	reg23: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(23), i_ld, reg23_out);
	reg24: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(24), i_ld, reg24_out);
	reg25: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(25), i_ld, reg25_out);
	reg26: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(26), i_ld, reg26_out);
	reg27: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(27), i_ld, reg27_out);
	reg28: gp_register_32 port map(i_CLK, i_CLR, dec1_out(28), i_ld, reg28_out);
	reg29: sp_register_32 port map(i_CLK, i_CLR, dec1_out(29), i_ld, reg29_out);
	reg30: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(30), i_ld, reg30_out);
	reg31: register_N generic map (32) port map(i_CLK, i_CLR, dec1_out(31), i_ld, reg31_out);


	mux0: mux32t1_N generic map (32) port map(i_rs, reg0_out,reg1_out,reg2_out,reg3_out,reg4_out,reg5_out,reg6_out,reg7_out,
		reg8_out,reg9_out,reg10_out,reg11_out,reg12_out,reg13_out,reg14_out,reg15_out,reg16_out,reg17_out,
		reg18_out,reg19_out,reg20_out,reg21_out,reg22_out,reg23_out,reg24_out,reg25_out,reg26_out,
		reg27_out,reg28_out,reg29_out,reg30_out,reg31_out, o_RD0);
	mux1: mux32t1_N generic map (32) port map(i_rt, reg0_out,reg1_out,reg2_out,reg3_out,reg4_out,reg5_out,reg6_out,reg7_out,
		reg8_out,reg9_out,reg10_out,reg11_out,reg12_out,reg13_out,reg14_out,reg15_out,reg16_out,reg17_out,
		reg18_out,reg19_out,reg20_out,reg21_out,reg22_out,reg23_out,reg24_out,reg25_out,reg26_out,
		reg27_out,reg28_out,reg29_out,reg30_out,reg31_out, o_RD1);

end structural;
