--  Hello world program
--  Source: http://ghdl.readthedocs.io/en/latest/using/QuickStartGuide.html
--  Edited By: OV Shashank 14D070021

--  This is a comment 
--  Objectives:
--		- Running ghdl (analysis and simulation)
--		- About entity

use std.textio.all; -- Imports the standard textio package.

--  Defines a design entity, without any ports.
entity hello_world is
end hello_world;

architecture behaviour of hello_world is
begin
  process
    variable l : line;
  begin
    write (l, String'("Hello world!"));
    writeline (output, l);
    wait;
  end process;
end behaviour;
