--  Generic Register
--  Created By By: OV Shashank 14D070021

--  Objectives
--		- Introduction to Sequential Logic
--		- Using Clocks and Clock Events
--		- 'others' statement
--		- Generic Variables

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
		-- data_width: Size of the register
	generic (data_width : integer := 16);
	port(
		-- clk: clock, ena: Register Enable Signal, clr: Clear Signal
		clk, ena, clr	: in std_logic;
		Din				: in std_logic_vector(data_width-1 downto 0);
		Dout			: out std_logic_vector(data_width-1 downto 0));
end entity;

architecture behaviour of reg is
begin

	process(clk, clr)
	begin
		-- At clock rising edge
		if(clk'event and clk = '1') then
			if (ena = '1') then
				Dout <= Din;
			end if;
			if(clr = '1') then
				Dout <= (others => '0');
			end if;
		end if;
	end process;

end architecture behaviour;