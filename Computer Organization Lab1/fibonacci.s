# author : yan-tong lin
# modified from TA example
# all right reserves
# no plagiarism

# usage : Fibonacci(arg), print result

.data
#the arg-th Fibonacci is to be found
arg: .word 10
str: .string "th number in the Fibonacci sequence is "
endl: .string "\n"

.text
main:
        #call Fibonacci(arg), param in a0
        lw       a0, arg
        jal      ra, Fibonacci_base
        #return values of Fibonacci_base/Fibonacci_recursive are both a0

        # Print the result to console
        lw       a1, arg
        jal      ra, printResult

        # Exit program
        li       a0, 10
        ecall

Fibonacci_base:
        addi     sp, sp, -32
        sw       ra, 16(sp)
        sw       a0, 0(sp)
        #a0 should be saved cause f is called twice dependent to a0 in one f call
        addi     t0, a0, -2
        #if t0 = ao-2 >= 0, go recursive else is base case
        bge      t0, zero, Fibonacci_recursive

        #mv       a0, a0
        #return arg is arg is 0 or 1
        #no need to change a0

        #end functioncall
        addi     sp, sp, 32
        jalr     x0, x1, 0


Fibonacci_recursive:
        #call Fibonacci(a0-1) and save to sp+8
        addi     a0, a0, -1
        jal      ra, Fibonacci_base
        sw       a0, 8(sp)
        #save result, save in register could be overwrite by recursibe call

        #call Fibonacci(a0-1), return val is now in a0
        lw       a0, 0(sp)
        addi     a0, a0 ,-2
        jal      ra, Fibonacci_base

        #add together
        lw       t1, 8(sp)
        add      a0, a0, t1

        #end functioncall
        #mv      a0, a0 #return value is a0 already
        lw       ra, 16(sp)
        addi     sp, sp, 32
        ret


# expects:
# a1: the ao-th Fibonacci number
# a0: Result
printResult:
        mv       t0, a1
        mv       t1, a0

        mv       a1, t0
        li       a0, 1
        ecall

        la       a1, str
        li       a0, 4
        ecall

        mv       a1, t1
        li       a0, 1
        ecall

        la       a1, endl
        li       a0, 4
        ecall

        ret
