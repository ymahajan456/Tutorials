--  Contrived Example: Adder w/ Ready-Ready Handshake Testbench
--  Created By By: OV Shashank 14D070021

--  Objectives
--		- Testing Ready-Ready Handshake
--		- Testing FSM in VHDL
--		- Advanced Wait Statements

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all ;
use ieee.std_logic_textio.all; -- to compile add option --ieee=synopsys

entity adder_handshake_tb is
end entity;

architecture testbench of adder_handshake_tb is
	
	component adder_handshake is
		port(
			-- clk: clock, reset: Reset Signal
			clk, reset					: in std_logic;
			input_ready, output_ack		: in std_logic;
			device_ready, output_ready	: out std_logic;
			A, B						: in std_logic_vector(7 downto 0);
			S							: out std_logic_vector(7 downto 0));
	end component;
	
	signal clk, reset, input_ready, output_ack, device_ready, output_ready: std_logic := '0';
	signal A, B, S: std_logic_vector(7 downto 0) := (others => '0') ;
	
begin
	DUT :  adder_handshake
		port map (clk => clk, reset => reset, input_ready => input_ready,
		output_ack => output_ack, device_ready => device_ready, output_ready => output_ready,
		A => A, B => B, S => S);
		
	-- process to generate clock
	clock :process
	begin
		wait for 50 ns;
		clk <= not clk;
	end process;
	
	--main process
	main : process		
	begin
		--RESET the FSM
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
			
		wait until (device_ready = '1');	--Wait for adder to finish previous operation
		output_ack <= '0';	--do not accept output
		wait until (clk'event and clk = '1');	--wait for clock rise
		
		wait for 5 ns;
		--Give the inputs
		A <= "10101010";
		B <= "01010101";
		input_ready <= '1';
		
		wait until (output_ready = '1');	--wait for division to complete
		wait for 5 ns;
		
		input_ready <= '0';	--set input ready to '0'
		output_ack <= '1';	--accept the output

		assert false report "Test completed"  severity note;
		--  Wait forever; this will finish the simulation.
		wait;
	end process;
end architecture;