from math import log2
# bitReversal reverse the bits of a given integer of a given bitwidth
def bitReversal(integer, bits):
    # Create format string 'width'
    width = '0'+str(bits)+'b'
    # Create binary representation of integer of bits width
    binary = format(integer, width)
    # Initialize reversed binary string
    rBin = ''
    # Loop over all bits
    for i in range(bits):
        # Assign reversed bits accordingly
        rBin += binary[bits-i-1]
    # Return integer representation of reversed bits
    return int(rBin, 2)

# stage + start/(2*length) + 1

# ntt computes the forward NTT given a modulo q, length n,
# polynomial coefficients f, and twiddle factors psis
# this NTT is based on the Cooley-Tukey normal input, bit-reversed output
def ntt(q, n, f, psis):
    # set output polynomial to input polynomial
    outf = f
    # length is the amount of inputs for each butterfly group
    length = int(n/2)
    # loop while there are 2+ inputs (for the butterflies)
    while(length >= 1):
        # start at the 0th index
        start = 0
        # current psi tracker
        psi = 0
        # loop until start is out of range
        while(start < n):
            # set index j to the start of the current batch of inputs
            j = start
            # loop over the current batch of inputs (this is the CT butterfly)
            while(j < start+length):
                # find the current twiddle factor
                twid = psis[psi]
                u = outf[j]
                v = outf[j+length]
                # compute even indexed output
                outf[j] = (u+twid*v)%q
                # compute odd indexed output
                outf[j+length] = (u-twid*v)%q
                # increment j for next input
                j += 1
            # increment start to the start of the next batch of inputs
            start += 2*length
            psi += 1
        # divide length in half for next round of recursion
        length = int(length/2)
    # return outf = NTT(f)
    return outf

# intt computes the inverse NTT given a modulo q, length n,
# polynomial coefficients fhat, and twiddle factors invPsis
# this INTT is based on the Gentleman-Sande bit-reversed input, normal output
def intt(q, n, fhat, psiInvs):
    # set output polynomial to input polynomial
    outf = fhat
    # length is the amount of inputs for each butterfly group
    length = 1
    # current psi tracker
    psi = 0
    # loop while there are <= n/2 inputs (for the butterflies)
    while(length <= int(n/2)):
        # start at the 0th index
        start = 0
        # loop until start is out of range
        while(start < n):
            # set index j to the start of the current batch of inputs
            j = start
            # loop over the current batch of inputs (this is the GS butterfly)
            while(j < start+length):
                # find the current tiwddle factor
                twid = psiInvs[psi]
                u = outf[j]
                v = outf[j+length]
                # compute even indexed output
                outf[j] = (u+v)%q
                # compute odd indexed output
                outf[j+length] = ((u-v)*twid)%q
                # increment j for next input
                j += 1
            # increment start to the start of the next batch of inputs
            start += 2*length
            psi += 1
        # multiply length by 2 for next round of recursion
        length = int(length*2)
        psi = 0
    # find inverse of n for scaling
    invn = 0
    # loop until inverse n is found
    while((n*invn)%q != 1):
        invn += 1
    # loop over inverse and scale
    for i in range(n):
        outf[i] = int((outf[i]*invn)%q)
    # return outf = INTT(fhat)
    return outf

def main():
    # Polynomial ring
    q = 3329 #3329 #7681
    n = 8 #256

    # twiddle factors
    omega = 40 #848 #62   #527 for n=8
    # calculate twiddle factors
    omegas = []
    for i in range(int(n/2)):
        omegas.append((omega**i)%q)
    omegasBO = []
    for i in range(int(n/2)):
        omegasBO.append(omegas[bitReversal(i,int(log2(int(n/2))))])
    print('omegasBO =\n', omegasBO)
    
    # find inverse omega
    omegaInv = 0
    # loop until inverse is found
    while((omega*omegaInv)%q != 1):
        omegaInv += 1
    # calculate inverse twiddle factors
    omegaInvs = []
    for i in range(int(n/2)):
        omegaInvs.append((omegaInv**i)%q)
    omegaInvsBO = []
    for i in range(int(n/2)):
        omegaInvsBO.append(omegaInvs[bitReversal(i,int(log2(int(n/2))))])
    print('omegaInvsBO =\n', omegaInvsBO)
        
    # input array f
    #f = [1038, 1490, 1852, 2012, 1223, 916, 1485, 1215, 1617, 97, 779, 413, 1196, 1374, 992, 967, 1683, 431, 1796, 990, 1893, 1651, 291, 1946, 1340, 1694, 2008, 806, 1278, 279, 885, 567, 688, 1969, 1869, 2204, 359, 2017, 127, 1582, 878, 1456, 1885, 1170, 2137, 1895, 583, 231, 1698, 1270, 214, 2225, 1382, 344, 714, 797, 925, 1972, 227, 956, 612, 1720, 69, 721, 321, 1360, 120, 2049, 730, 10, 302, 788, 2121, 1501, 485, 1896, 1113, 982, 2083, 2202, 419, 2174, 1939, 2207, 504, 931, 739, 1399, 365, 340, 648, 1225, 955, 1613, 723, 643, 127, 1763, 1655, 825, 1627, 1292, 547, 1303, 2117, 141, 165, 1056, 1836, 946, 930, 528, 151, 1810, 637, 1322, 2159, 1515, 1369, 2141, 1016, 2159, 1420, 821, 1598, 588, 1346, 665, 1544, 590, 1939, 1296, 406, 99, 2104, 1056, 1318, 205, 881, 2219, 374, 569, 1605, 637, 948, 1172, 508, 538, 1507, 1318, 540, 914, 2077, 2120, 1809, 43, 1737, 2061, 1960, 17, 357, 895, 1249, 331, 1791, 744, 1903, 2054, 495, 218, 1096, 1394, 826, 952, 320, 1141, 369, 1645, 333, 525, 2034, 744, 201, 1335, 263, 1324, 121, 2158, 1315, 1476, 826, 555, 1326, 485, 264, 980, 2220, 1859, 1521, 684, 809, 1753, 1286, 1686, 1436, 223, 612, 963, 308, 1031, 1762, 1477, 571, 1043, 821, 495, 1516, 1371, 462, 7, 1329, 1416, 1075, 671, 614, 385, 1412, 1511, 1411, 2177, 380, 476, 1345, 799, 282, 2190, 1970, 1952, 166, 842, 1005, 2161, 119, 796, 315, 43, 1957, 1306, 1475, 209, 844, 1212, 947, 721, 920, 1594]
    f = [1, 2, 3, 4, 5, 6, 7, 8]
    print('f =\n', f)
    
    # NTT computation
    fhat = ntt(q, n, f, omegasBO)
    print('ntt(f) =\n', fhat)
    
    # INTT computation
    invf = intt(q, n, fhat, omegaInvsBO)
    print('intt(ntt(f)) =\n', invf)

    # polynomial multiplication check
    #a = [1038, 1490, 1852, 2012, 1223, 916, 1485, 1215, 1617, 97, 779, 413, 1196, 1374, 992, 967, 1683, 431, 1796, 990, 1893, 1651, 291, 1946, 1340, 1694, 2008, 806, 1278, 279, 885, 567, 688, 1969, 1869, 2204, 359, 2017, 127, 1582, 878, 1456, 1885, 1170, 2137, 1895, 583, 231, 1698, 1270, 214, 2225, 1382, 344, 714, 797, 925, 1972, 227, 956, 612, 1720, 69, 721, 321, 1360, 120, 2049, 730, 10, 302, 788, 2121, 1501, 485, 1896, 1113, 982, 2083, 2202, 419, 2174, 1939, 2207, 504, 931, 739, 1399, 365, 340, 648, 1225, 955, 1613, 723, 643, 127, 1763, 1655, 825, 1627, 1292, 547, 1303, 2117, 141, 165, 1056, 1836, 946, 930, 528, 151, 1810, 637, 1322, 2159, 1515, 1369, 2141, 1016, 2159, 1420, 821, 1598, 588, 1346, 665, 1544, 590, 1939, 1296, 406, 99, 2104, 1056, 1318, 205, 881, 2219, 374, 569, 1605, 637, 948, 1172, 508, 538, 1507, 1318, 540, 914, 2077, 2120, 1809, 43, 1737, 2061, 1960, 17, 357, 895, 1249, 331, 1791, 744, 1903, 2054, 495, 218, 1096, 1394, 826, 952, 320, 1141, 369, 1645, 333, 525, 2034, 744, 201, 1335, 263, 1324, 121, 2158, 1315, 1476, 826, 555, 1326, 485, 264, 980, 2220, 1859, 1521, 684, 809, 1753, 1286, 1686, 1436, 223, 612, 963, 308, 1031, 1762, 1477, 571, 1043, 821, 495, 1516, 1371, 462, 7, 1329, 1416, 1075, 671, 614, 385, 1412, 1511, 1411, 2177, 380, 476, 1345, 799, 282, 2190, 1970, 1952, 166, 842, 1005, 2161, 119, 796, 315, 43, 1957, 1306, 1475, 209, 844, 1212, 947, 721, 920, 1594]
    #b = [1844, 1460, 71, 98, 448, 517, 667, 121, 1172, 1330, 471, 1810, 1776, 695, 894, 1297, 1383, 483, 1297, 1959, 2177, 126, 1323, 2215, 1718, 1267, 1353, 153, 1294, 1448, 932, 1652, 354, 525, 165, 1192, 1193, 1368, 1794, 1077, 1484, 747, 704, 102, 178, 9, 1265, 1717, 1265, 1438, 526, 918, 993, 607, 537, 1783, 1434, 1786, 678, 335, 1829, 1708, 88, 994, 1870, 203, 1212, 353, 314, 2044, 186, 1771, 2238, 1748, 567, 1316, 11, 695, 1075, 1627, 1890, 1538, 1455, 152, 1244, 691, 1013, 1783, 1883, 2198, 1960, 280, 1425, 1082, 1071, 1939, 212, 179, 1391, 32, 803, 713, 1958, 934, 1140, 976, 712, 757, 135, 1146, 1972, 646, 240, 1149, 1062, 496, 2124, 1242, 1933, 1603, 1334, 327, 830, 1482, 1123, 86, 2124, 2173, 1109, 29, 37, 1426, 1989, 1493, 854, 766, 812, 709, 124, 1000, 301, 1059, 317, 1913, 11, 62, 809, 1609, 176, 344, 701, 2124, 1822, 1998, 2077, 286, 1000, 307, 527, 647, 1041, 121, 2214, 1990, 1300, 951, 1278, 1352, 1983, 1272, 1983, 917, 532, 841, 594, 1508, 2056, 86, 1814, 1391, 1114, 1462, 1579, 360, 1755, 1279, 832, 1119, 1886, 1793, 842, 1116, 1560, 938, 179, 152, 342, 1109, 878, 5, 1425, 1420, 795, 1100, 454, 437, 778, 1201, 1777, 81, 918, 2221, 224, 280, 1691, 895, 737, 683, 2028, 425, 1643, 1892, 1936, 1170, 414, 882, 2235, 2034, 240, 1804, 1058, 883, 76, 2085, 301, 1520, 1525, 480, 1537, 414, 744, 354, 1996, 608, 2025, 740, 1687, 2063, 1812, 1458, 1390, 614, 19, 1694, 1511, 1124]
    a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    b = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    print('\na =\n', a)
    print('\nb =\n', b)
    ahat = ntt(q, n, a, omegasBO)
    bhat = ntt(q, n, b, omegasBO)
    c = []
    for i in range(n):
        c.append((ahat[i]*bhat[i])%q)
    print('\nc = aXb =\n', intt(q, n, c, omegaInvsBO))
main()
