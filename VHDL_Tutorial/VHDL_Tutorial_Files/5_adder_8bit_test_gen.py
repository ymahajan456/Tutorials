# Accompanies 5_adder_8bit_tb: Creates test vector file
# Created by Yogesh Mahajan 14D070022
# Not required to be understood

# Objectives:
#       - NULL
outFile = open('5_adder_8bit_test_data.txt', 'w')

for a in range(256):
    for b in range(256):
        s = a + b
        c = ' 1\n' if s >= 256 else ' 0\n'
        outFile.write('{0:08b}'.format(a) + ' ' + '{0:08b}'.format(b) + ' 0 ' + '{0:08b}'.format(s % 256) + c)
        s = s + 1
        c = ' 1\n' if s >= 256 else ' 0\n'
        outFile.write('{0:08b}'.format(a) + ' ' + '{0:08b}'.format(b) + ' 1 ' + '{0:08b}'.format(s % 256) + c)

outFile.close()
