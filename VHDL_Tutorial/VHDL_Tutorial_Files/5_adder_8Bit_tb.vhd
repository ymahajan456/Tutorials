-- Testbench for Full Adder
-- Created by Yogesh Mahajan 14D070022

-- Objectives:
--		- Reading from file
--		- Function for printing std_logic
--		- While loop 

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.all;

-- Test Bench Entity (Top Level Entity)
entity adder_8Bit_tb is
end entity;

architecture test of adder_8Bit_tb is

    -- This function converts "std_logic_vector" to "string" for printing the vector in output
    function vec_to_str(x:std_logic_vector) return String is
        variable L : Line;
        variable W : String(1 to x'length) :=(others => ' ');
        begin
        write(L,x);
        W(L.all'range) := L.all;
        Deallocate(L);
        return W;
    end vec_to_str;
    
    -- This function returns string without null character
    function to_string(x: string) return string is
        variable ret_val: string(1 to x'length);
        alias lx : string (1 to x'length) is x;
    begin  
        ret_val := lx;
        return(ret_val);
    end to_string;

    -- Interface Signals
    signal i0, i1, s : std_logic_vector(7 downto 0) := (others=>'0');
    signal ci, co : std_logic := '0';

    begin
        
    sim_process : process
        file f_in : text open read_mode is "5_adder_8bit_test_data.txt";        -- Input file
        file f_out : text open write_mode is "5_adder_8bit_test_output.txt";    -- Output File
        variable test_buffer, error_report : line;
        variable fail_count, test_count : integer := 0;
        variable i0_test, i1_test, s_test : std_logic_vector(7 downto 0);
        variable ci_test, co_test : std_logic;
        variable test_time : time := 0 ps;

        begin
        while not endfile(f_in) loop
            readline(f_in, test_buffer);
            read(test_buffer, i0_test);
            read(test_buffer, i1_test);
            read(test_buffer, ci_test);
            read(test_buffer, s_test);
            read(test_buffer, co_test);
            test_count := test_count + 1;

            i0 <= i0_test;
            i1 <= i1_test;
            ci <= ci_test;
            test_time := now;
            
            wait for 1 ns;

            if not(s = s_test) or not(co = co_test) then
                fail_count := fail_count + 1;
                assert false report "Incorrect Output for test no. " & integer'image(test_count) severity error;
                write(error_report, to_string("Incorrect output for test no "));
                write(error_report, test_count);
                write(error_report, to_string(" at time "));
                write(error_report, test_time);
                writeline(f_out, error_report);
                write(error_report, to_string("i0: "));
                write(error_report, i0_test);
                write(error_report, to_string(" i1: "));
                write(error_report, i1_test);
                write(error_report, to_string(" ci: "));
                write(error_report, ci_test);
                write(error_report, to_string(" Correct s: "));
                write(error_report, s_test);
                write(error_report, to_string(" Correct co: "));
                write(error_report, co_test);
                write(error_report, to_string(" s: "));
                write(error_report, s);
                write(error_report, to_string(" co: "));
                write(error_report, co);
                writeline(f_out, error_report);
            end if;
        end loop;
        
        if(fail_count = 0) then
            write(error_report, to_string("Test completed without failures"));
            writeline(f_out, error_report);
        end if;

        assert false report "Test completed with " & integer'image(fail_count) & " failures out of " & integer'image(test_count) severity error;

        wait;
    end process;

    fa_dut : entity adder_8Bit (looped) port map (i0 ,i1, ci, s, co);
end architecture;
