library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;

entity tbWallace8X8 is
end entity;

architecture behav of tbWallace8X8 is
    function vec_to_str(x:std_logic_vector) return String is
        variable L : Line;
        variable W : String(1 to x'length) :=(others => ' ');
        begin
        write(L,x);
        W(L.all'range) := L.all;
        Deallocate(L);
        return W;
    end vec_to_str;

    function to_string(x: string) return string is
        variable ret_val: string(1 to x'length);
        alias lx : string (1 to x'length) is x;
        begin
        ret_val := lx;
        return(ret_val);
    end to_string;

    component wallace8X8 is
        port (
            A, B : in std_logic_vector(7 downto 0);
            M : out std_logic_vector(15 downto 0));
    end component;

    signal A, B : std_logic_vector(7 downto 0) := (others => '0');
    signal M : std_logic_vector(15 downto 0) := (others => '0');
    signal clk : std_logic := '0';

    begin

    timeout_clock : process
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
    end process;
    
    sim_process : process
        file f : text open read_mode is "wallace8X8TB.txt";
        file o : text open write_mode is "oWallace8X8.txt";
        variable L, EL1, EL2 : line;
        variable Fail, count : integer := 0;
        variable Check : integer := 0;
        variable rdA, rdB, minA, minB, maxA, maxB : std_logic_vector(7 downto 0) := (others => '0');
        variable rdM, minM, maxM : std_logic_vector(15 downto 0) := (others => '0');
        variable T,Tmax, TmaxActual, TminActual : time := 0 ps;
        variable Tmin : time := 20 ns;
    begin
        while not endfile(f) loop
            readline(f, L);
            read(L, rdA);
            read(L, rdB);
            read(L, rdM);
            count := count + 1;

            wait until clk = '1';
            A <= rdA;
            B <= rdB;
            T := now;

            wait until (M xor rdM) = "0000000000000000" or (clk = '0');
            T := now - T;
            if (M xor rdM) = "0000000000000000" then
                Check := Check + 1;
                if (T > Tmax) then
                    Tmax := T;
                    TmaxActual := now;
                    maxA := rdA;
                    maxB := rdB;
                    maxM := rdM;
                elsif (T < Tmin) then
                    Tmin := T;
                    minA := rdA;
                    minB := rdB;
                    minM := rdM;
                    TminActual := now;
                end if;
            else
                Fail := Fail + 1;
                assert false report "Wrong" severity note;
                write(EL1,to_string("Error in Input no "));
                write(EL1, count);
                writeline(o, EL1);
                write(EL2,to_string(" output "));
                write(EL2,vec_to_str(M));
                writeline(o,EL2);
            end if;

            wait until clk = '0';
            A <= "UUUUUUUU";
            B <= "UUUUUUUU";
        end loop;

        if (Fail = 0) then
            write(EL1, to_string("Minimum Time: "));
            write(EL1, Tmin);
            write(EL2, to_string("A: "));
            write(EL2, vec_to_str(minA));
            write(EL2, to_string(" B: "));
            write(EL2, vec_to_str(minB));
            write(EL2, to_string(" M: "));
            write(EL2, vec_to_str(minM));
            write(EL2, to_string(" At time: "));
            write(EL2, TminActual);
            writeline(o, EL1);
            writeline(o,EL2);
            write(EL1, to_string("Maximum Time: "));
            write(EL1, Tmax);
            write(EL2, to_string("A: "));
            write(EL2, vec_to_str(maxA));
            write(EL2, to_string(" B: "));
            write(EL2, vec_to_str(maxB));
            write(EL2, to_string(" M: "));
            write(EL2, vec_to_str(maxM));
            write(EL2, to_string(" At time: "));
            write(EL2, TmaxActual);
            writeline(o, EL1);
            writeline(o,EL2);
        end if;

        assert false report "Total Checked " & integer'image(count) & " failures " & integer'image(Fail) severity error;

        wait;
    end process;

    dut : wallace8X8 port map(A, B, M);
end architecture;
        


