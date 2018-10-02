--  Contrived Example: Adder w/ Ready-Ready Handshake
--  Created By By: OV Shashank 14D070021

--  Objectives
--		- Ready-Ready Handshake
--		- FSM in VHDL
--		- Case Statement

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_handshake is
	port(
		-- clk: clock, reset: Reset Signal
		clk, reset					: in std_logic;
		input_ready, output_ack		: in std_logic;
		device_ready, output_ready	: out std_logic;
		A, B						: in std_logic_vector(7 downto 0);
		S							: out std_logic_vector(7 downto 0));
end entity;

architecture rtl of adder_handshake is
	
	component reg is
			-- data_width: Size of the register
		generic (data_width : integer := 16);
		port(
			-- clk: clock, ena: Register Enable Signal, clr: Clear Signal
			clk, ena, clr	: in std_logic;
			Din				: in std_logic_vector(data_width-1 downto 0);
			Dout			: out std_logic_vector(data_width-1 downto 0));
	end component;

	component adder_8Bit is
	-- `I0`, `I1`, and the carry-in `ci` are inputs of the adder.
	-- `S` is the sum output, `co` is the carry-out.
		port (
			I0, I1	: in std_logic_vector(7 downto 0);
			ci		: in std_logic; 
			S		: out std_logic_vector(7 downto 0); 
			co		: out std_logic);
	end component adder_8Bit;

	
	-- Control Signals: Enable for Registers
	signal SA, SB, SS: std_logic;
	-- Input and Outputs of the Adder Block
	signal A_Add, B_Add, S_Add: std_logic_vector(7 downto 0);
	
	type state is (idle, working, ready);	--states
	signal Q, nQ: state;	--present and next state
begin

	input_regA: reg 
		generic map(data_width => 8)
		port map(clk => clk, clr => reset, ena => SA, Din => A, Dout => A_Add);

	input_regB: reg 
		generic map(data_width => 8)
		port map(clk => clk, clr => reset, ena => SB, Din => B, Dout => B_Add);
		
	output_regS: reg 
		generic map(data_width => 8)
		port map(clk => clk, clr => reset, ena => SS, Din => S_Add, Dout => S);
		
	adder: adder_8Bit 
		port map(I0 => A_Add, I1 => B_Add, ci => '0',
			S => S_Add, co => open);
		
	process(clk)	--delay process
	begin
		if(clk'event and clk='1') then
			Q <= nQ;
		end if;
	end process;
	
	process(Q, reset, input_ready, output_ack)
	begin
		-- Following are sequential assignments of default values
		device_ready <= '0';
		output_ready <= '0';
		SA <= '0'; SB <= '0'; SS <= '0';
		nQ <= Q;
		
		if (reset = '1') then
			nQ <= idle;
		else 
			case Q is
				when idle =>
					device_ready <= '1';
					if (input_ready = '1') then
						nQ <= working;
						SA <= '1'; SB <= '1';
					end if;
				
				when working =>
					SS <= '1';
					nQ <= ready;
				
				when ready =>
					output_ready <= '1';
					if (output_ack = '1') then
						nQ <= idle;
					end if;
				when others =>
					nQ <= idle;
			end case;
		end if;
	end process;

end architecture rtl;