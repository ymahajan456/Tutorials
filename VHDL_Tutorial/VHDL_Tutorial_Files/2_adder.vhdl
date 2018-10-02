--  Full Adder program
--  Source: http://ghdl.readthedocs.io/en/latest/using/QuickStartGuide.html
--  Edited By: OV Shashank 14D070021
 

--  Objectives:
--		- Basic Full Adder Architecture
--		- About entities and ports
--		- Multiple architectures of one entity
--		- Concurrent Assignments

entity adder is
  -- `i0`, `i1`, and the carry-in `ci` are inputs of the adder.
  -- `s` is the sum output, `co` is the carry-out.
  port (
  	i0, i1 : in bit; 
  	ci : in bit; 
  	s : out bit; 
  	co : out bit);
end adder;

architecture structure of adder is
begin
  --  This full-adder architecture contains two concurrent assignments.
  --  Compute the sum.
  s <= i0 xor i1 xor ci;
  --  Compute the carry.
  co <= (i0 and i1) or (i0 and ci) or (i1 and ci);
end structure;

architecture faulty_sum of adder is
begin
  --  This full-adder architecture contains two concurrent assignments.
  --  Compute the sum.
  s <= (i0 xor i1) or ci;
  --  Compute the carry.
  co <= (i0 and i1) or (i0 and ci) or (i1 and ci);
end faulty_sum;

architecture faulty_carry of adder is
begin
  --  This full-adder architecture contains two concurrent assignments.
  --  Compute the sum.
  s <= i0 xor i1 xor ci;
  --  Compute the carry.
  co <= (i0 nand i1) or (i0 and ci) or (i1 and ci);
end faulty_carry;

--  Pitfalls
--		- Multiple Concurrent Assignments to the same signal