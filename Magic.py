#!/usr/local/bin/python3.7

import sys

sys.setrecursionlimit(50000)
lis = []

def cost(x):

    global lis
    if lis[x] != 0:
        return lis[x]


    if x < 12:

        lis[x] = x-1
        return lis[x]

    if x % 2 == 0:
        half=x/2
        lis[x] = min(cost(x-1)+1, cost(half) + 5)
        return lis[x]

    if str(x)[:1] == '9' and str(x)[-1:] == '1':

        rev=int(str(x)[::-1])
        lis[x] = min(cost(x-1)+1, cost(rev)+ 20)
        return lis[x]

    else:
        lis[x] = cost(x-1)+1
        return lis[x]

def main():

   print("Enter the number of orbs required to upgrade the wand.")
   n = input()

   global lis
   lis = [0]*(n+1)

   finalcost=cost(n)
   print('Minimum gold coins required to upgrade the wand are ' + str(finalcost)+'.')
   print(lis)

if __name__ == '__main__':
      main()
