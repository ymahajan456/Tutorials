import numpy as np
import pandas as pd

mode = "(behaveDelay)"


def genWallace8X8(fileName):
    outfile = open(fileName,'w')
    outfile.write("""library ieee;
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
    
""")

    data = pd.read_table("wallace8X8.csv", sep=",")
    data = np.array(data)

    stages = len(data)//4
    # to creatre stage signal names (entry after the stage name in CSV file)
    stageDepth = [8]
    for i in range(stages):
        stageDepth.append(data[4*i][1])

    stages = stages+1

    stageNames = ['S'+ str(i) for i in range(stages)]

    for i in range(stages):
        outfile.write("    signal " + stageNames[i] + " : stage(" + str(stageDepth[i]-1) + " downto 0);\n")
    
    outfile.write('\n    begin\n\n')
    
    # Creating Partial Products
    outfile.write("    -- Partial Products  (S0)\n")
    for i in range(8):
        outfile.write("    AND" + str(i) + " : entity ANDvec "+mode+" generic map (8) port map (A => A, B => B("+ str(i)+ "),\n    ")
        for j in range(i):
            outfile.write( "C(" + str(7-j) + ") => S0(" + str(j) + ")(" + str(7+i-j) +"), ")
        outfile.write("C("+ str(7-i) + " downto 0) => S0(" + str(i) + ")(7 downto " + str(i) +")")
        
        outfile.write(");\n")

    # Reduction Steps 
    
    for i in range(stages - 1):
        outfile.write("\n\n    -- Step "+ str(i+1) + "\n")
        HA = data[4*i+2][1:]
        FA = data[4*i+1][1:]
        P = data[4*i+3][1:]
        HA = [int(x) for x in HA]
        P = [int(x) for x in P]
        FA = [int(x) for x in FA]
        HA.reverse() 
        FA.reverse()
        P.reverse()
        # print(FA)
        # print(HA)
        # print(P)
        readIndex = [0 for i in range(15)]
        writeIndex = [0 for i in range(15)]
        
        for j in range(15):
            # passes
            for k in range(P[j]):
                outfile.write("    " + stageNames[i+1] + "("+str(writeIndex[j])+")("+str(j)+") <= " + stageNames[i] + "("+str(readIndex[j])+")("+str(j)+");\n")
                readIndex[j] = readIndex[j] + 1;
                writeIndex[j] = writeIndex[j] + 1;

            # Half Adders
            for k in range(HA[j]):
                outfile.write("    SHA" + str(i) + str(j) + str(k) + ": entity halfAdder "+mode+" port map (")
                outfile.write("A => "+ stageNames[i] + "("+str(readIndex[j])+")("+str(j)+"), B => " + stageNames[i] + "("+str(readIndex[j]+1)+")("+str(j)+")," 
                + " S => " + stageNames[i+1] + "("+str(writeIndex[j])+")("+str(j)+"), Cout =>" + stageNames[i+1] + "("+str(writeIndex[j+1])+")("+str(j+1)+"));\n")
                readIndex[j] = readIndex[j] + 2
                writeIndex[j] = writeIndex[j] + 1
                writeIndex[j+1] = writeIndex[j+1] + 1

            # Full Adders
            for k in range(FA[j]):
                outfile.write("    SFA" + str(i) + str(j) + str(k) + ": entity fullAdder "+mode+" port map (")
                outfile.write("A => "+ stageNames[i] + "("+str(readIndex[j])+")("+str(j)+"), B => " + stageNames[i] + "("+str(readIndex[j]+1)+")("+str(j)+")," 
                + " C => " + stageNames[i] + "("+str(readIndex[j]+2)+")("+str(j)+"),"
                + " S => " + stageNames[i+1] + "("+str(writeIndex[j])+")("+str(j)+"), Cout =>" + stageNames[i+1] + "("+str(writeIndex[j+1])+")("+str(j+1)+"));\n")
                readIndex[j] = readIndex[j] + 3
                writeIndex[j] = writeIndex[j] + 1
                writeIndex[j+1] = writeIndex[j+1] + 1


    outfile.write("""\n\n    -- Final Adder
    FinalAdder : entity CarrySelect8X8Wallace """+mode+""" port map (A => S4(0)(14 downto 5), B => S4(1)(14 downto 5),
    S => M(14 downto 5), C => M(15));

    M(4 downto 0) <= S4(0)(4 downto 0);

end architecture;\n""")
    
    outfile.close()


genWallace8X8('wallace8X8.vhd')
