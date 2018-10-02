--  Tristate Buffer
--  Created By By: OV Shashank 14D070021

--  Objectives
--		- Using High 'Z'
--		- 'others' statement

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tristate is
		-- data_width: Size of the buffer
	generic (data_width : integer := 16);
	port(
		-- ena: Output Enable Signal
		ena				: in std_logic;
		Din				: in std_logic_vector(data_width-1 downto 0);
		Dout			: out std_logic_vector(data_width-1 downto 0));
end entity;

architecture structure of reg is
begin

	Dout <= Din when (ena = '1') else (others => 'Z');

end architecture structure;