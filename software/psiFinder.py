def main():
    # polynomial ring
    q = 7681
    n = 8

    # set w to lowest possible value
    w = 2
    # list to hold omegas
    ws = []
    while(w < q):
        # find ws such that w^n%q = 1
        while((w**n)%q != 1):
            w += 1
        ws.append(w)
        w += 1
        # remove ws such that w^k%q = 1 where k<n
        for k in range(1,n):
            if((w**k)%q == 1):
                ws = ws[:-1]
                break
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
        print(w, psis)
    

main()
