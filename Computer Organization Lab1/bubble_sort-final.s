# author : Yan-Tong Lin
# all right reserves
# no plagiarism

# usage :
# arr = the array that want to sort
# N, size of arr


.data
N: .word 11
arr: .word 5,3,6,7,31,23,43,12,45,1,99
msg1: .string "Input Array: "
msg2: .string "After Sorted: "
space: .string "  "
endl: .string "\n"

# a7 = N(constant in this program), s1 = i
# s0 = arr start pointer(const)
# s1 = arr pointer
# t1 = i
# t2 = j
# t3 = delta with t2(t2 << 2)
# t4 = arr[j]
# t5 = arr[j+1]

.text
 main:
       # a7 = N, constant in this program
       lw      a7, N
       la      s0, arr

       # print msg1
       li      a0, 4
       la      a1, msg1
       ecall

       # load array to s0
       # i = 0
       # print array with loop
       la      s1, arr
       li      t1, 0
       jal     ra, print_loop
       
       # print endl
       li      a0, 4
       la      a1, endl
       ecall

       # now use t1 as i, init with 0
       # about to start sort
       # t1 = i, s0 = arr start, constant when sorting
       li      t1, 0 
       la      s0, arr

#Bubble Sort Starts Here

fori:
       # if i == N, break
       beq     t1, a7, end_of_sort
       # j = i - 1
       addi    t2, t1, -1

forj:
       #if j < 0, break
       blt    t2, zero, to_nxt_i

       # t3 = j << 2
       # 4 byte per word, t3 is the actual distance from arr start(t4)
       slli    t3, t2, 2
       # t4 is now arr[j]
       add     s1, s0, t3
       
       # load arr[j] and arr[j+1]
       lw      t4, 0(s1)
       lw      t5, 4(s1)

       # if arr[j] <= arr[j+1](i.e., is sorted before)
       # break
       ble     t4, t5 , to_nxt_i

       # else swap arr[j] and arr[j+1](by direct saving), continue
       sw      t4, 4(s1)
       sw      t5, 0(s1)

       # j--, continue
       addi    t2, t2, -1
       j       forj

#end of the inner loop
to_nxt_i:
       #i++
       addi    t1, t1, 1
       j       fori


#End of the outer loop
end_of_sort:
       # print msg2
       li      a0, 4
       la      a1, msg2
       ecall
       
       # i = 0        
       # print sorted array with loop  
       li      t1, 0
       la      s1, arr
       jal     ra, print_loop

       # endl
       li      a0, 4
       la      a1, endl
       ecall

       #Exit program
       li      a0, 10
       ecall


# expectations:
# s1 is the array pointer now
# t1 is i
print_loop:
       lw      a1, 0(s1)
       li      a0, 1
       ecall

       # print space
       la      a1, space
       li      a0, 4
       ecall

       # i(t1)++
       # arr ptr(s1) +=4 
       addi    s1, s1, 4
       addi    t1 ,t1, 1

       blt     t1, a7, print_loop
       ret