# Find valid nth (omega) and 2nth (psi) roots of unity given a modulo (q)
# and the size of polynomial (n)
def main():
    # polynomial ring
    q = 3329
    n = 256
    # print out ring
    print('q =', q)
    print('n =', n)

    # find inverse of n
    invN = 0
    while((invN*n)%q != 1):
        invN += 1
    print('invN =', invN)
    
    # set w to lowest possible value
    w = 2
    # list to hold omegas
    ws = []
    while(w < q):
        # find ws such that w^n%q = 1
        while((w**n)%q != 1):
            w += 1
        ws.append(w)
        # remove ws such that w^k%q = 1 where k<n
        for k in range(1,n):
            if((w**k)%q == 1):
                ws = ws[:-1]
                break
        w += 1
    # remove last element as it is actually invalid
    ws = ws[:-1]
    print('omegas =', ws)

    # find psis for the ws
    for w in ws:
        psi = 2
        psis = []
        while(psi < q):
            # find psis such that psi^2%q = w and psi^n = -1 = q-1
            while((psi**2)%q != w or (psi**n)%q != q-1):
                psi += 1
            psis.append(psi)
            psi += 1
        psis = psis[:-1]
        print('omega =', w, '   valid psis =', psis)
    

main()
