# author : yan-tong lin
# modified from TA example
# all right reserves
# no plagiarism

# usage : gcd(arg1, arg2), print result

.data

#define N1 512
#define N2 480
arg1: .word 512 # Number to find the factorial value of
arg2: .word 480
#define str1 "GCD value of "
#define str2 " and "
#define str3 " is "
#define endl "\n"
str1: .string "GCD value of "
str2: .string " and "
str3: .string " is "
endl: .string "\n"

.text
main:
        lw       a0, arg1   # Load argument from static data
        lw       a1, arg2
        jal      ra, gcd_base
        # Jump-and-link to the 'gcd_base' label

        # Print the result to console
        # mv       a0, a0
        lw       a1, arg1
        lw       a2, arg2
        jal      ra, printResult

        # Exit Main program
        li       a0, 10
        ecall

gcd_base:
        addi     sp, sp, -32
        sw       ra, 16(sp) #save return address
        #sw       a0, 0(sp) #save args
        #sw       a1, 8(sp)
        addi     t0, a1, -1
        bge      t0, zero, gcd_recursive #branch if n - 1 >= 0

        #here n(a1) <= 0
        #lw       a0, 0(sp)
        #lw       ra, 16(sp) #base case can return without loading back ra
        addi     sp, sp, 32
        jalr     x0, ra, 0

gcd_recursive:
        # now is in else
        # calc module => change params => recurse
        # no need swap

        loop:
                blt     a0, a1, done # a1>=a0 break
                sub     a0, a0, a1   # a0-=a1
                j       loop
        done:
                #now a0 = r(remainder of m%n)
                #now a1 = n(n)
                jal      ra, swap
                #mv t0, a0
                #mv a0, a1
                #mv a1, t0
                #now a0 = n
                #now a1 = r
                jal      ra, gcd_base

        #return directly (now a0 should be result)
                lw       ra, 16(sp)
                addi     sp, sp, 32
                ret

### need to use function call or ret to main
swap:
        
        mv t0, a0
        mv a0, a1
        mv a1, t0
        ret #bug , return to main


# expects:
# a0: gcd(arg1, arg2)
# a1: arg1
# a2: arg2
printResult:
        mv       t0, a0
        mv       t1, a1
        mv       t2, a2

        la       a1, str1
        li       a0, 4
        ecall

        mv       a1, t1
        li       a0, 1
        ecall

        la       a1, str2
        li       a0, 4
        ecall

        mv       a1, t2
        li       a0, 1
        ecall

        la       a1, str3
        li       a0, 4
        ecall

        mv       a1, t0
        li       a0, 1
        ecall

        la       a1, endl
        li       a0, 4
        ecall

        ret