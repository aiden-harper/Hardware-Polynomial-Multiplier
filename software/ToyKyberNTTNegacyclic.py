# This is based on this paper: https://eprint.iacr.org/2024/585.pdf
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
    
# ntt computes the forward NTT given a modulo q, length n,
# polynomial coefficients f, and twiddle factors psis
# this NTT is based on the Cooley-Tukey normal input, bit-reversed output
def ntt(q, n, f, psis):
    # set output polynomial to input polynomial
    outf = f
    # length is the amount of inputs for each butterfly group
    length = int(n/2)
    # current psi tracker
    psi = 1
    # loop while there are 2+ inputs (for the butterflies)
    while(length >= 1):
        # start at the 0th index
        start = 0
        # loop until start is out of range
        while(start < n):
            # set index j to the start of the current batch of inputs
            j = start
            # loop over the current batch of inputs (this is the CT butterfly)
            while(j < start+length):
                # find the current tiwddle factor
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
    psi = 1
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
    q = 7681
    n = 8

    # twiddle factors
    psi = 527
    # calculate twiddle factors
    psisNorm = []
    for i in range(n):
        psisNorm.append((psi**i)%q)
    # sort psis in bit reverse order
    psis = []
    for i in range(n):
        psis.append(psisNorm[bitReversal(i,int(log2(n)))])
    
    # find inverse psi
    psiInv = 0
    # loop until inverse is found
    while((psi*psiInv)%q != 1):
        psiInv += 1
    # calculate inverse twiddle factors
    psiInvsNorm = []
    for i in range(n):
        psiInvsNorm.append((psiInv**i)%q)
    # sort psiInvs in bit reverse order
    psiInvsTemp = []
    for i in range(n):
        psiInvsTemp.append(psiInvsNorm[bitReversal(i,int(log2(n)))])
    # mirror the bit reversed psiInvs
    psiInvRev = []
    for i in range(n):
        psiInvRev.append(psiInvsTemp[n-i-1])
    # reorder mirroerd psiInvs groups
    group = n/2
    psiInvs = [1]
    index = 0
    for i in range(int(log2(n))):
        for j in range(int(group)):
            psiInvs.append(psiInvRev[int(group)-j-1+int(index)])
        index += group
        group /= 2
    
    # input array f
    f = [1, 2, 3, 4, 5, 6, 7, 8]
    print(psis)
    print('f =', f)
    
    # NTT computation
    fhat = ntt(q, n, f, psis)
    print('ntt(f) =', fhat)
    
    # INTT computation
    invf = intt(q, n, fhat, psiInvs)
    print('intt(ntt(f)) =', invf)

    # polynomial multiplication check
    a = [1, 2, 3, 4, 5, 6, 7, 8]
    b = [1, 2, 3, 4, 5, 6, 7, 8]
    print('\na =', a)
    print('b =', b)
    ahat = ntt(q, n, a, psis)
    bhat = ntt(q, n, b, psis)
    c = []
    for i in range(n):
        c.append((ahat[i]*bhat[i])%q)
    print('c = aXb =', intt(q, n, c, psiInvs))
main()
