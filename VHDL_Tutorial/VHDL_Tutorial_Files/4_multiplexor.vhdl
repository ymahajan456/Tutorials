--  Multiplexor
--  Base: https://www.tutorialspoint.com/vlsi_design/vhdl_programming_for_combinational_circuits.htm
--  Expanded By: OV Shashank 14D070021
 
--  Objectives:
--		- Alternate Representations for Multiplexer
--		- When-Else Statements
--		- If-Else Statements

library ieee; 
use ieee.std_logic_1164.all;
  
entity mux is
	port(
	S		: in std_logic;
	D0, D1	: in std_logic;
	Y		: out std_logic);
end entity mux;
  
architecture rtl of mux is
begin 
	Y <= (not S and D0) or 
		 (S and D1);
end architecture rtl;

architecture when_else of mux is
begin
	y <= D0 when (S = '0') else D1;
end architecture when_else;

architecture using_process of mux is
begin
	multiplexor: process(S, D0, D1)
	begin
		if (S = '0') then
			Y <= D0;
		else
			Y <= D1;
		end if;
	end process;
end architecture using_process;

--  Pitfalls
--		- Ending When Else or if else with when statement or else if statement
--		- Always end with 'else' in both cases to avoid latches