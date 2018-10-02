--  8 Bit Adder program
--  Uses Adder from: http://ghdl.readthedocs.io/en/latest/using/QuickStartGuide.html
--  Created By By: OV Shashank 14D070021

--  Objectives
--		- std_logic_vector type
--		- Generate Statement

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity adder_8Bit is
  -- `I0`, `I1`, and the carry-in `ci` are inputs of the adder.
  -- `S` is the sum output, `co` is the carry-out.
  port (
	I0, I1	: in std_logic_vector(7 downto 0);
  	ci		: in std_logic; 
  	S		: out std_logic_vector(7 downto 0); 
  	co		: out std_logic);
end adder_8Bit;

architecture structure of adder_8Bit is
	component fa is
	  -- `i0`, `i1`, and the carry-in `ci` are inputs of the adder.
	  -- `s` is the sum output, `co` is the carry-out.
	  port (
		i0, i1 : in std_logic; 
		ci : in std_logic; 
		s : out std_logic; 
		co : out std_logic);
	end component fa;
	
	signal carry: std_logic_vector(7 downto 0);
begin

	FA0: fa port map (
		i0 => I0(0), i1 => I1(0), ci => ci,
		s => S(0), co => carry(0));
	FA1: fa port map (
		i0 => I0(1), i1 => I1(1), ci => carry(0),
		s => S(1), co => carry(1));
	FA2: fa port map (
		i0 => I0(2), i1 => I1(2), ci => carry(1),
		s => S(2), co => carry(2));
	FA3: fa port map (
		i0 => I0(3), i1 => I1(3), ci => carry(2),
		s => S(3), co => carry(3));
	FA4: fa port map (
		i0 => I0(4), i1 => I1(4), ci => carry(3),
		s => S(4), co => carry(4));
	FA5: fa port map (
		i0 => I0(5), i1 => I1(5), ci => carry(4),
		s => S(5), co => carry(5));
	FA6: fa port map (
		i0 => I0(6), i1 => I1(6), ci => carry(5),
		s => S(6), co => carry(6));
	FA7: fa port map (
		i0 => I0(7), i1 => I1(7), ci => carry(6),
		s => S(7), co => carry(7));
	co <= carry(7);

end structure;

architecture looped of adder_8Bit is
	component fa is
	  -- `i0`, `i1`, and the carry-in `ci` are inputs of the adder.
	  -- `s` is the sum output, `co` is the carry-out.
	  port (
		i0, i1 : in std_logic; 
		ci : in std_logic; 
		s : out std_logic; 
		co : out std_logic);
	end component fa;
	
	signal carry: std_logic_vector(8 downto 0);
begin
	carry(0) <= ci;		-- For uniformity in the generate statement
	co <= carry(8);
	
	ADDERS: 
	for i in 0 to 7 generate
		ADDER: fa port map (
			i0 => I0(i), i1 => I1(i), ci => carry(i),
			s => S(i), co => carry(i + 1));
	end generate ADDERS;
	
end looped;

