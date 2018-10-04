-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

-- package basic is

-- 	component bitShifter is
-- 		generic(datawidth : integer := 8);
-- 		port(
-- 			din : in std_logic_vector(datawidth-1 downto 0);
-- 			dinSerial, wr, wrSerial, ASR : in std_logic;
-- 			clk, ena, rst : in std_logic;
-- 			dout : out std_logic);
-- 	end component;
	
-- 	component myReg is
-- 	generic (dataWidth : integer := 8);
-- 	port(
-- 		din: in std_logic_vector(dataWidth-1 downto 0);
-- 		clk, ena, rst: in std_logic;
-- 		dout: out std_logic_vector(dataWidth-1 downto 0));
-- 	end component;

-- 	component fullAdder is
-- 		port(
-- 			A, B, C : in std_logic;
-- 			S, Cout : out std_logic);
-- 	end component;

-- 	component sum is
-- 		port(
-- 			A, B, C : in std_logic;
-- 			S : out std_logic);
-- 	end component;


-- 	component inverter is
-- 		port(
-- 			A: in std_logic;
-- 			Ab : out std_logic);
-- 	end component;
	
-- end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myReg is
	generic (dataWidth : integer := 8);
	port(
		din: in std_logic_vector(dataWidth-1 downto 0);
		clk, ena, rst: in std_logic;
		dout: out std_logic_vector(dataWidth-1 downto 0));
end entity;

architecture behav of myReg is
	begin
	process(clk, rst, ena)
	begin
		if(clk'event and (clk and ena) = '1') then
			if(rst = '1') then
				dout <= (others => '0');
			else
				dout <= din;
			end if;
		end if;
	end process;
end architecture;


------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity bitShifter is
	generic(datawidth : integer := 8);
	port(
		din : in std_logic_vector(datawidth-1 downto 0);
		dinSerial, wr, wrSerial, ASR : in std_logic;
		clk, ena, rst : in std_logic;
		dout : out std_logic);
end entity;

architecture behav of bitShifter is
	
	component myReg is
	generic (dataWidth : integer := 8);
	port(
		din: in std_logic_vector(dataWidth-1 downto 0);
		clk, ena, rst: in std_logic;
		dout: out std_logic_vector(dataWidth-1 downto 0));
	end component;
	
	signal regOut, regIn : std_logic_vector(dataWidth-1 downto 0);
	signal replaceBit : std_logic;
	
	begin
	replaceBit <= dinSerial when (wrSerial = '1') else 
						regOut(dataWidth-1) when (ASR = '1') else '0';
						
	regIn <= din when (wr = '1') else regOut(dataWidth-2 downto 0) & replaceBit;
	dout <= regOut(dataWidth-1);
	
	SHIFTERREG: myReg
		generic map(dataWidth)
		port map(
			din => regIn, clk => clk, ena => ena, rst => rst, dout => regOut);
end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity fullAdder is
	port(
		A, B, C : in std_logic;
		S, Cout : out std_logic);
end entity fullAdder;

architecture behaveIdeal of fullAdder is
	begin
		S <= A xor B xor C;
		Cout <= (A and B) or (B and C) or (A and C);
end architecture behaveIdeal;

architecture behaveDelay of fullAdder is
	begin
		S <= A xor B xor C after 0.83 ns;
		Cout <= ((A and B) or (B and C) or (A and C)) after 0.465 ns;
end architecture behaveDelay;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity sum is
	port(
		A, B, C : in std_logic;
		S : out std_logic);
end entity sum;


architecture behaveIdeal of sum is
	begin
		S <= A xor B xor C;
end architecture behaveIdeal;

architecture behaveDelay of sum is
	begin
		S <= (A xor B xor C) after 0.83 ns;
end architecture behaveDelay;



--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity carryBar is
	port(
		A, B, C : in std_logic;
		Cbar : out std_logic);
end entity;

architecture behaveIdeal of carryBar is
	begin
		Cbar <= not((A and B) or (B and C) or (A and C));
end architecture;

architecture behaveDelay of carryBar is
	begin
		Cbar <= not((A and B) or (B and C) or (A and C)) after 0.34 ns;
end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux21 is
	generic(datawidth : integer := 8);
	port(
		A, B : in std_logic_vector(datawidth-1 downto 0);
		S : std_logic;
		O : out std_logic_vector(datawidth-1 downto 0));
end entity;

architecture behaveIdeal of mux21 is
	begin
		O <= B when (S = '1') else A;
end architecture;

architecture behaveDelay of mux21 is
	begin
		O <= B when (S = '1') else A after 0.54 ns;
end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfAdder is
	port(
		A, B : in std_logic;
		S, Cout : out std_logic);
end entity;

architecture behaveIdeal of halfAdder is
	begin
		S <= A xor B;
		Cout <= A and B;
end architecture;

architecture behaveDelay of halfAdder is
	begin
		S <= A xor B after 0.47 ns;
		Cout <= A and B after 0.30 ns ;
end architecture;


--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inverter is
	port(
		A: in std_logic;
		Ab : out std_logic);
end entity;

architecture behaveIdeal of inverter is
	begin
		Ab <= not A;
end architecture;

architecture behaveDelay of inverter is
	begin
		Ab <= not A after 0.135 ns;
end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity H_RCAdder is
	generic(dataWidth : integer := 8);
	port(
		A, B : in std_logic_vector(dataWidth-1 downto 0);
		S : out std_logic_vector(datawidth-1 downto 0);
		C : out std_logic);
end entity;

architecture behaveIdeal of H_RCAdder is

	signal inA, inB, inC, inS : std_logic_vector(datawidth-1 downto 0);
	begin
		INPUTINVERTERS : for N in 0 to dataWidth-1 generate
			ODD : if N mod 2 > 0 generate
				INVAX : entity inverter (behaveIdeal) port map (A => A(N), Ab => inA(N));
				INVBX : entity inverter (behaveIdeal) port map (A => B(N), Ab => inB(N));
				INVSX : entity inverter (behaveIdeal) port map (A => inS(N), Ab => S(N));
			end generate;
		end generate;

		OUTPUTINVERTERS : for N in 0 to dataWidth-1 generate
			EVEN : if N mod 2 = 0 generate
				S(N) <= inS(N);
				inA(N) <= A(N);
				inB(N) <= B(N);
			end generate;
		end generate;

		-- first half adder
		inS(0) <= inA(0) xor inB(0);
		inC(0) <= inA(0) nand inB(0);

		ADDERS : for N in 1 to datawidth-1 generate
			SUMX : entity sum (behaveIdeal) port map (A => inA(N), B => inB(N), C => inC(N-1), S => inS(N));
			CARRYX : entity carryBar (behaveIdeal) port map (A => inA(N), B => inB(N), C => inC(N-1), Cbar => inC(N));
		end generate;

		C <= inC(datawidth-1);
end architecture;

architecture behaveDelay of H_RCAdder is
	
		signal inA, inB, inC, inS : std_logic_vector(datawidth-1 downto 0);
		begin
			INPUTINVERTERS : for N in 0 to dataWidth-1 generate
				ODD : if N mod 2 > 0 generate
					INVAX : entity inverter (behaveDelay) port map (A => A(N), Ab => inA(N));
					INVBX : entity inverter (behaveDelay) port map (A => B(N), Ab => inB(N));
					INVSX : entity inverter (behaveDelay) port map (A => inS(N), Ab => S(N));
				end generate;
			end generate;
	
			OUTPUTINVERTERS : for N in 0 to dataWidth-1 generate
				EVEN : if N mod 2 = 0 generate
					S(N) <= inS(N);
					inA(N) <= A(N);
					inB(N) <= B(N);
				end generate;
			end generate;
	
			-- first half adder
			inS(0) <= inA(0) xor inB(0) after 0.47 ns;
			inC(0) <= inA(0) nand inB(0) after 0.17 ns;
	
			ADDERS : for N in 1 to datawidth-1 generate
				SUMX : entity sum (behaveDelay) port map (A => inA(N), B => inB(N), C => inC(N-1), S => inS(N));
				CARRYX : entity carryBar (behaveDelay) port map (A => inA(N), B => inB(N), C => inC(N-1), Cbar => inC(N));
			end generate;
	
			C <= inC(datawidth-1);
	end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity F_RCAdder is
	generic(dataWidth : integer := 8);
	port(
		A, B : in std_logic_vector(dataWidth-1 downto 0);
		Cin : in std_logic;
		S : out std_logic_vector(datawidth-1 downto 0);
		C : out std_logic);
end entity;

architecture behaveIdeal of F_RCAdder is

	signal inA, inB, inC, inS : std_logic_vector(datawidth-1 downto 0);
	begin
		INPUTINVERTERS : for N in 0 to dataWidth-1 generate
		ODD : if N mod 2 > 0 generate
			INVAX : entity inverter (behaveIdeal) port map (A => A(N), Ab => inA(N));
			INVBX : entity inverter (behaveIdeal) port map (A => B(N), Ab => inB(N));
			INVSX : entity inverter (behaveIdeal) port map (A => inS(N), Ab => S(N));
		end generate;
	end generate;

	OUTPUTINVERTERS : for N in 0 to dataWidth-1 generate
		EVEN : if N mod 2 = 0 generate
			S(N) <= inS(N);
			inA(N) <= A(N);
			inB(N) <= B(N);
		end generate;
	end generate;

		-- first adder
		FIRSTSUM : entity sum (behaveIdeal) port map (A => inA(0), B => inB(0), C => Cin, S => inS(0));
		FIRSTCARRY : entity carryBar (behaveIdeal) port map (A => inA(0), B => inB(0), C => Cin, Cbar => inC(0));
	

		ADDERS : for N in 1 to datawidth-1 generate
			SUMX : entity sum (behaveIdeal) port map (A => inA(N), B => inB(N), C => inC(N-1), S => inS(N));
			CARRYX : entity carryBar (behaveIdeal) port map (A => inA(N), B => inB(N), C => inC(N-1), Cbar => inC(N));
		end generate;

		C <= inC(datawidth-1);
end architecture;

architecture behaveDelay of F_RCAdder is
	
		signal inA, inB, inC, inS : std_logic_vector(datawidth-1 downto 0);
		begin
			INPUTINVERTERS : for N in 0 to dataWidth-1 generate
			ODD : if N mod 2 > 0 generate
				INVAX : entity inverter (behaveDelay) port map (A => A(N), Ab => inA(N));
				INVBX : entity inverter (behaveDelay) port map (A => B(N), Ab => inB(N));
				INVSX : entity inverter (behaveDelay) port map (A => inS(N), Ab => S(N));
			end generate;
		end generate;
	
		OUTPUTINVERTERS : for N in 0 to dataWidth-1 generate
			EVEN : if N mod 2 = 0 generate
				S(N) <= inS(N);
				inA(N) <= A(N);
				inB(N) <= B(N);
			end generate;
		end generate;
	
			-- first adder
			FIRSTSUM : entity sum (behaveDelay) port map (A => inA(0), B => inB(0), C => Cin, S => inS(0));
			FIRSTCARRY : entity carryBar (behaveDelay) port map (A => inA(0), B => inB(0), C => Cin, Cbar => inC(0));
		
	
			ADDERS : for N in 1 to datawidth-1 generate
				SUMX : entity sum (behaveDelay) port map (A => inA(N), B => inB(N), C => inC(N-1), S => inS(N));
				CARRYX : entity carryBar (behaveDelay) port map (A => inA(N), B => inB(N), C => inC(N-1), Cbar => inC(N));
			end generate;
	
			C <= inC(datawidth-1);
	end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity CarrySelect8X8Wallace is
	port(
		A, B : in std_logic_vector(9 downto 0);
		S : out std_logic_vector(9 downto 0);
		C : out std_logic);
end entity;

architecture behaveIdeal of CarrySelect8X8Wallace is
	signal Cselect0, Cselect1, CSA0, CSA1, CTA0, CTA1,Cb : std_logic;
	signal SSA0, SSA1 : std_logic_vector(2 downto 0);
	signal STA0, STA1 : std_logic_vector(4 downto 0);


	begin
		-- Fist Step
		FA : entity H_RCAdder (behaveIdeal) generic map (2) port map (A => A(1 downto 0), B => B(1 downto 0),
				S => S(1 downto 0), C => Cselect0);

		-- Second Step
		SA0 : entity F_RCAdder (behaveIdeal) generic map (3) port map (A => A(4 downto 2), B => B(4 downto 2),
				Cin => '0', S => SSA0(2 downto 0), C => CSA0);
		SA1 : entity F_RCAdder (behaveIdeal) generic map (3) port map (A => A(4 downto 2), B => B(4 downto 2),
				Cin => '1', S => SSA1(2 downto 0), C => CSA1);

		-- Second Stage MUX
		MUXSAC : entity mux21 (behaveIdeal) generic map (1) port map (A(0) => CSA0, B(0) => CSA1,
				S => Cselect0, O(0) => Cselect1);
		MUXSAS : entity mux21 (behaveIdeal) generic map (3) port map (A => SSA0, B => SSA1,
				S => Cselect0, O => S(4 downto 2));

		-- Third Stage
		TA0 : entity F_RCAdder (behaveIdeal) generic map (5) port map (A => A(9 downto 5), B => B(9 downto 5),
				Cin => '0', S => STA0(4 downto 0), C => CTA0);
		TA1 : entity F_RCAdder (behaveIdeal) generic map (5) port map (A => A(9 downto 5), B => B(9 downto 5),
				Cin => '1', S => STA1(4 downto 0), C => CTA1);

		-- Third Stage MUX [Second stage produces Carry Bar]
		MUXTAC : entity mux21 (behaveIdeal) generic map (1) port map (A(0) => CTA1, B(0) => CTA0,
				S => Cselect1, O(0) => Cb);
		MUXTAS : entity mux21 (behaveIdeal) generic map (5) port map (A => STA1, B => STA0,
				S => Cselect1, O => S(9 downto 5));

		LASTINV : entity inverter (behaveIdeal) port map (A => Cb, Ab => C);

end architecture;

architecture behaveDelay of CarrySelect8X8Wallace is
	signal Cselect0, Cselect1, CSA0, CSA1, CTA0, CTA1,Cb : std_logic;
	signal SSA0, SSA1 : std_logic_vector(2 downto 0);
	signal STA0, STA1 : std_logic_vector(4 downto 0);


	begin
		-- Fist Step
		FA : entity H_RCAdder (behaveDelay) generic map (2) port map (A => A(1 downto 0), B => B(1 downto 0),
				S => S(1 downto 0), C => Cselect0);

		-- Second Step
		SA0 : entity F_RCAdder (behaveDelay) generic map (3) port map (A => A(4 downto 2), B => B(4 downto 2),
				Cin => '0', S => SSA0(2 downto 0), C => CSA0);
		SA1 : entity F_RCAdder (behaveDelay) generic map (3) port map (A => A(4 downto 2), B => B(4 downto 2),
				Cin => '1', S => SSA1(2 downto 0), C => CSA1);

		-- Second Stage MUX
		MUXSAC : entity mux21 (behaveDelay) generic map (1) port map (A(0) => CSA0, B(0) => CSA1,
				S => Cselect0, O(0) => Cselect1);
		MUXSAS : entity mux21 (behaveDelay) generic map (3) port map (A => SSA0, B => SSA1,
				S => Cselect0, O => S(4 downto 2));

		-- Third Stage
		TA0 : entity F_RCAdder (behaveDelay) generic map (5) port map (A => A(9 downto 5), B => B(9 downto 5),
				Cin => '0', S => STA0(4 downto 0), C => CTA0);
		TA1 : entity F_RCAdder (behaveDelay) generic map (5) port map (A => A(9 downto 5), B => B(9 downto 5),
				Cin => '1', S => STA1(4 downto 0), C => CTA1);

		-- Third Stage MUX [Second stage produces Carry Bar]
		MUXTAC : entity mux21 (behaveDelay) generic map (1) port map (A(0) => CTA1, B(0) => CTA0,
				S => Cselect1, O(0) => Cb);
		MUXTAS : entity mux21 (behaveDelay) generic map (5) port map (A => STA1, B => STA0,
				S => Cselect1, O => S(9 downto 5));

		LASTINV : entity inverter (behaveDelay) port map (A => Cb, Ab => C);

end architecture;

--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ANDvec is
	generic (datawidth : integer := 8);
	port (A : in std_logic_vector(datawidth-1 downto 0);
		B : in std_logic;
		C : out std_logic_vector(datawidth-1 downto 0));
end entity;

architecture behaveIdeal of ANDvec is
	begin
		C <= A when (B = '1') else (others => '0');
end architecture;

architecture behaveDelay of ANDvec is
	begin
		C <= A when (B = '1') else (others => '0') after 0.3 ns;
	end architecture;