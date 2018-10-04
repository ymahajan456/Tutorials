library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity wallace8X8 is
    port (
        A, B : in std_logic_vector(7 downto 0);
        M : out std_logic_vector(15 downto 0));
end entity;

architecture behav of wallace8X8 is
    
    type stage is array (natural range <>) of std_logic_vector(14 downto 0);
    
    signal S0 : stage(7 downto 0);
    signal S1 : stage(5 downto 0);
    signal S2 : stage(3 downto 0);
    signal S3 : stage(2 downto 0);
    signal S4 : stage(1 downto 0);

    begin

    -- Partial Products  (S0)
    AND0 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(0),
    C(7 downto 0) => S0(0)(7 downto 0));
    AND1 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(1),
    C(7) => S0(0)(8), C(6 downto 0) => S0(1)(7 downto 1));
    AND2 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(2),
    C(7) => S0(0)(9), C(6) => S0(1)(8), C(5 downto 0) => S0(2)(7 downto 2));
    AND3 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(3),
    C(7) => S0(0)(10), C(6) => S0(1)(9), C(5) => S0(2)(8), C(4 downto 0) => S0(3)(7 downto 3));
    AND4 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(4),
    C(7) => S0(0)(11), C(6) => S0(1)(10), C(5) => S0(2)(9), C(4) => S0(3)(8), C(3 downto 0) => S0(4)(7 downto 4));
    AND5 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(5),
    C(7) => S0(0)(12), C(6) => S0(1)(11), C(5) => S0(2)(10), C(4) => S0(3)(9), C(3) => S0(4)(8), C(2 downto 0) => S0(5)(7 downto 5));
    AND6 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(6),
    C(7) => S0(0)(13), C(6) => S0(1)(12), C(5) => S0(2)(11), C(4) => S0(3)(10), C(3) => S0(4)(9), C(2) => S0(5)(8), C(1 downto 0) => S0(6)(7 downto 6));
    AND7 : entity ANDvec (behaveDelay) generic map (8) port map (A => A, B => B(7),
    C(7) => S0(0)(14), C(6) => S0(1)(13), C(5) => S0(2)(12), C(4) => S0(3)(11), C(3) => S0(4)(10), C(2) => S0(5)(9), C(1) => S0(6)(8), C(0 downto 0) => S0(7)(7 downto 7));


    -- Step 1
    S1(0)(0) <= S0(0)(0);
    SHA010: entity halfAdder (behaveDelay) port map (A => S0(0)(1), B => S0(1)(1), S => S1(0)(1), Cout =>S1(0)(2));
    SFA020: entity fullAdder (behaveDelay) port map (A => S0(0)(2), B => S0(1)(2), C => S0(2)(2), S => S1(1)(2), Cout =>S1(0)(3));
    S1(1)(3) <= S0(0)(3);
    SFA030: entity fullAdder (behaveDelay) port map (A => S0(1)(3), B => S0(2)(3), C => S0(3)(3), S => S1(2)(3), Cout =>S1(0)(4));
    S1(1)(4) <= S0(0)(4);
    S1(2)(4) <= S0(1)(4);
    SFA040: entity fullAdder (behaveDelay) port map (A => S0(2)(4), B => S0(3)(4), C => S0(4)(4), S => S1(3)(4), Cout =>S1(0)(5));
    SFA050: entity fullAdder (behaveDelay) port map (A => S0(0)(5), B => S0(1)(5), C => S0(2)(5), S => S1(1)(5), Cout =>S1(0)(6));
    SFA051: entity fullAdder (behaveDelay) port map (A => S0(3)(5), B => S0(4)(5), C => S0(5)(5), S => S1(2)(5), Cout =>S1(1)(6));
    S1(2)(6) <= S0(0)(6);
    SFA060: entity fullAdder (behaveDelay) port map (A => S0(1)(6), B => S0(2)(6), C => S0(3)(6), S => S1(3)(6), Cout =>S1(0)(7));
    SFA061: entity fullAdder (behaveDelay) port map (A => S0(4)(6), B => S0(5)(6), C => S0(6)(6), S => S1(4)(6), Cout =>S1(1)(7));
    S1(2)(7) <= S0(0)(7);
    S1(3)(7) <= S0(1)(7);
    SFA070: entity fullAdder (behaveDelay) port map (A => S0(2)(7), B => S0(3)(7), C => S0(4)(7), S => S1(4)(7), Cout =>S1(0)(8));
    SFA071: entity fullAdder (behaveDelay) port map (A => S0(5)(7), B => S0(6)(7), C => S0(7)(7), S => S1(5)(7), Cout =>S1(1)(8));
    S1(2)(8) <= S0(0)(8);
    SFA080: entity fullAdder (behaveDelay) port map (A => S0(1)(8), B => S0(2)(8), C => S0(3)(8), S => S1(3)(8), Cout =>S1(0)(9));
    SFA081: entity fullAdder (behaveDelay) port map (A => S0(4)(8), B => S0(5)(8), C => S0(6)(8), S => S1(4)(8), Cout =>S1(1)(9));
    SFA090: entity fullAdder (behaveDelay) port map (A => S0(0)(9), B => S0(1)(9), C => S0(2)(9), S => S1(2)(9), Cout =>S1(0)(10));
    SFA091: entity fullAdder (behaveDelay) port map (A => S0(3)(9), B => S0(4)(9), C => S0(5)(9), S => S1(3)(9), Cout =>S1(1)(10));
    S1(2)(10) <= S0(0)(10);
    S1(3)(10) <= S0(1)(10);
    SFA0100: entity fullAdder (behaveDelay) port map (A => S0(2)(10), B => S0(3)(10), C => S0(4)(10), S => S1(4)(10), Cout =>S1(0)(11));
    S1(1)(11) <= S0(0)(11);
    SFA0110: entity fullAdder (behaveDelay) port map (A => S0(1)(11), B => S0(2)(11), C => S0(3)(11), S => S1(2)(11), Cout =>S1(0)(12));
    SFA0120: entity fullAdder (behaveDelay) port map (A => S0(0)(12), B => S0(1)(12), C => S0(2)(12), S => S1(1)(12), Cout =>S1(0)(13));
    S1(1)(13) <= S0(0)(13);
    S1(2)(13) <= S0(1)(13);
    S1(0)(14) <= S0(0)(14);


    -- Step 2
    S2(0)(0) <= S1(0)(0);
    S2(0)(1) <= S1(0)(1);
    SHA120: entity halfAdder (behaveDelay) port map (A => S1(0)(2), B => S1(1)(2), S => S2(0)(2), Cout =>S2(0)(3));
    SFA130: entity fullAdder (behaveDelay) port map (A => S1(0)(3), B => S1(1)(3), C => S1(2)(3), S => S2(1)(3), Cout =>S2(0)(4));
    S2(1)(4) <= S1(0)(4);
    SFA140: entity fullAdder (behaveDelay) port map (A => S1(1)(4), B => S1(2)(4), C => S1(3)(4), S => S2(2)(4), Cout =>S2(0)(5));
    SFA150: entity fullAdder (behaveDelay) port map (A => S1(0)(5), B => S1(1)(5), C => S1(2)(5), S => S2(1)(5), Cout =>S2(0)(6));
    SHA160: entity halfAdder (behaveDelay) port map (A => S1(0)(6), B => S1(1)(6), S => S2(1)(6), Cout =>S2(0)(7));
    SFA160: entity fullAdder (behaveDelay) port map (A => S1(2)(6), B => S1(3)(6), C => S1(4)(6), S => S2(2)(6), Cout =>S2(1)(7));
    SFA170: entity fullAdder (behaveDelay) port map (A => S1(0)(7), B => S1(1)(7), C => S1(2)(7), S => S2(2)(7), Cout =>S2(0)(8));
    SFA171: entity fullAdder (behaveDelay) port map (A => S1(3)(7), B => S1(4)(7), C => S1(5)(7), S => S2(3)(7), Cout =>S2(1)(8));
    SHA180: entity halfAdder (behaveDelay) port map (A => S1(0)(8), B => S1(1)(8), S => S2(2)(8), Cout =>S2(0)(9));
    SFA180: entity fullAdder (behaveDelay) port map (A => S1(2)(8), B => S1(3)(8), C => S1(4)(8), S => S2(3)(8), Cout =>S2(1)(9));
    S2(2)(9) <= S1(0)(9);
    SFA190: entity fullAdder (behaveDelay) port map (A => S1(1)(9), B => S1(2)(9), C => S1(3)(9), S => S2(3)(9), Cout =>S2(0)(10));
    S2(1)(10) <= S1(0)(10);
    S2(2)(10) <= S1(1)(10);
    SFA1100: entity fullAdder (behaveDelay) port map (A => S1(2)(10), B => S1(3)(10), C => S1(4)(10), S => S2(3)(10), Cout =>S2(0)(11));
    SFA1110: entity fullAdder (behaveDelay) port map (A => S1(0)(11), B => S1(1)(11), C => S1(2)(11), S => S2(1)(11), Cout =>S2(0)(12));
    S2(1)(12) <= S1(0)(12);
    S2(2)(12) <= S1(1)(12);
    SFA1130: entity fullAdder (behaveDelay) port map (A => S1(0)(13), B => S1(1)(13), C => S1(2)(13), S => S2(0)(13), Cout =>S2(0)(14));
    S2(1)(14) <= S1(0)(14);


    -- Step 3
    S3(0)(0) <= S2(0)(0);
    S3(0)(1) <= S2(0)(1);
    S3(0)(2) <= S2(0)(2);
    SHA230: entity halfAdder (behaveDelay) port map (A => S2(0)(3), B => S2(1)(3), S => S3(0)(3), Cout =>S3(0)(4));
    SFA240: entity fullAdder (behaveDelay) port map (A => S2(0)(4), B => S2(1)(4), C => S2(2)(4), S => S3(1)(4), Cout =>S3(0)(5));
    S3(1)(5) <= S2(0)(5);
    S3(2)(5) <= S2(1)(5);
    SFA260: entity fullAdder (behaveDelay) port map (A => S2(0)(6), B => S2(1)(6), C => S2(2)(6), S => S3(0)(6), Cout =>S3(0)(7));
    S3(1)(7) <= S2(0)(7);
    SFA270: entity fullAdder (behaveDelay) port map (A => S2(1)(7), B => S2(2)(7), C => S2(3)(7), S => S3(2)(7), Cout =>S3(0)(8));
    S3(1)(8) <= S2(0)(8);
    SFA280: entity fullAdder (behaveDelay) port map (A => S2(1)(8), B => S2(2)(8), C => S2(3)(8), S => S3(2)(8), Cout =>S3(0)(9));
    S3(1)(9) <= S2(0)(9);
    SFA290: entity fullAdder (behaveDelay) port map (A => S2(1)(9), B => S2(2)(9), C => S2(3)(9), S => S3(2)(9), Cout =>S3(0)(10));
    S3(1)(10) <= S2(0)(10);
    SFA2100: entity fullAdder (behaveDelay) port map (A => S2(1)(10), B => S2(2)(10), C => S2(3)(10), S => S3(2)(10), Cout =>S3(0)(11));
    S3(1)(11) <= S2(0)(11);
    S3(2)(11) <= S2(1)(11);
    SFA2120: entity fullAdder (behaveDelay) port map (A => S2(0)(12), B => S2(1)(12), C => S2(2)(12), S => S3(0)(12), Cout =>S3(0)(13));
    S3(1)(13) <= S2(0)(13);
    S3(0)(14) <= S2(0)(14);
    S3(1)(14) <= S2(1)(14);


    -- Step 4
    S4(0)(0) <= S3(0)(0);
    S4(0)(1) <= S3(0)(1);
    S4(0)(2) <= S3(0)(2);
    S4(0)(3) <= S3(0)(3);
    SHA340: entity halfAdder (behaveDelay) port map (A => S3(0)(4), B => S3(1)(4), S => S4(0)(4), Cout =>S4(0)(5));
    SFA350: entity fullAdder (behaveDelay) port map (A => S3(0)(5), B => S3(1)(5), C => S3(2)(5), S => S4(1)(5), Cout =>S4(0)(6));
    S4(1)(6) <= S3(0)(6);
    S4(0)(7) <= S3(0)(7);
    SHA370: entity halfAdder (behaveDelay) port map (A => S3(1)(7), B => S3(2)(7), S => S4(1)(7), Cout =>S4(0)(8));
    SFA380: entity fullAdder (behaveDelay) port map (A => S3(0)(8), B => S3(1)(8), C => S3(2)(8), S => S4(1)(8), Cout =>S4(0)(9));
    SFA390: entity fullAdder (behaveDelay) port map (A => S3(0)(9), B => S3(1)(9), C => S3(2)(9), S => S4(1)(9), Cout =>S4(0)(10));
    SFA3100: entity fullAdder (behaveDelay) port map (A => S3(0)(10), B => S3(1)(10), C => S3(2)(10), S => S4(1)(10), Cout =>S4(0)(11));
    SFA3110: entity fullAdder (behaveDelay) port map (A => S3(0)(11), B => S3(1)(11), C => S3(2)(11), S => S4(1)(11), Cout =>S4(0)(12));
    S4(1)(12) <= S3(0)(12);
    S4(0)(13) <= S3(0)(13);
    S4(1)(13) <= S3(1)(13);
    S4(0)(14) <= S3(0)(14);
    S4(1)(14) <= S3(1)(14);


    -- Final Adder
    FinalAdder : entity CarrySelect8X8Wallace (behaveDelay) port map (A => S4(0)(14 downto 5), B => S4(1)(14 downto 5),
    S => M(14 downto 5), C => M(15));

    M(4 downto 0) <= S4(0)(4 downto 0);

end architecture;
