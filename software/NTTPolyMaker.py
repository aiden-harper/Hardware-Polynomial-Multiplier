from math import log2
def twiddleGen():
##    W = int(input("Power of: "))
##    Q = int(input("Modulo: "))
##    N = int(input("Size of polynomial: "))
##    inverse = bool(input("Inverses? "))
    W = 3
    Q = 17
    N = 16
    inverse = True
    temp = []
    result = []
    if(inverse):
        x = 0;
        while((W*x)%Q != 1):
            x += 1
        W = x
    for i in range(int(N/2)):
        temp.append(W**i%Q)
    for i in range(int(log2(N))):
        result.append([])
        for j in range(int(N/2)):
            index = int((j*len(temp)/(2**i))%len(temp))
            result[i].append(temp[index])
    return(result)

def main():
    w = twiddleGen()
    l = [0,7,3,5,11,15,15,5,9,11,1,2,3,7,14,10]
    print("// input: ", end='')
    for i in range(len(l)):
        print(str(l[i])+"x^"+str(i), end='')
        if i != len(l)-1:
            print(" + ", end='')
    print("\n\t#50 ", end='')
    for i in range(len(l)):
        print("in["+str(i)+"] <= "+str(l[i])+"; ", end='')
    for stage in range(len(w)):
        for i in range(len(w[0])):
            print("w["+str(stage)+"]"+"["+str(i)+"] <= "+str(w[stage][i])+\
                  "; ", end='')
main()
