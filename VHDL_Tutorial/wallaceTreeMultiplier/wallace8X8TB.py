for i in range(1,256):
    for j in range(1,256):
        out = '{:08b} '.format(i)
        out += '{:08b} '.format(j)
        out += '{:016b} '.format(i*j)
        print(out)
