.data
N:.word 10
arr: .word 5,3,6,7,31,23,43,12,45,1
msg1:.string "Array: "
endl:.string "\n"
space:.string " "
msg2:.string "Sorted: "

array1: .word 5
array2: .word 3
array3: .word 6
array4: .word 7
array5: .word 31
array6: .word 23
array7: .word 43
array8: .word 12
array9: .word 45
array10: .word 1


.text
main:
        # print "Array: "
        la      a1,msg1
        li      a0,4
        ecall

        # load array from args 
        la      t0, arr
        lw      t2, N

        # print array before sorted
        jal     ra, print_loop

        # print endl
        la      a1, endl
        li      a0, 4
        ecall

         # exit call
        li      a0, 10
        ecall

        # sort array
        lw      t0, arr
        lw      t2, N
        jal     ra, sort

        # print "Sorted: "
        la      a1, msg2
        li      a0, 4
        ecall

        # load N back
        # print array after sorted
        lw      t2, N
        jal     ra, print_loop

        # print endl
        la      a1, endl
        li      a0, 4
        ecall        

        # exit call
        li      a0, 10
        ecall



# a2=i a3=N initial
sort:

        addi    sp,sp,-8
        sw      ra,0(sp)


        li      a2,0
        lw      a3,N


        jal     ra sort2


        lw      ra,0(sp)
        addi    sp,sp,8
        ret

# a2=i  a3 =N  for(i=0;i<N;i++)
sort2:
        
        bge     a2,a3,return

        addi    sp,sp,-8
        sw      ra,0(sp)
        

        addi    a4,a2,-1
        jal     ra,sort3
        #i++
        addi    a2,a2,1
        jal     ra,sort2

        lw      ra,0(sp)
        addi    sp,sp,8
        ret
        

# a4=j    data[j] > data[j+1]
sort3:
        blt     a4,zero,return
        
        addi    sp,sp,-8
        sw      ra,0(sp)

        slli    t1,a4,3
        add     s1,s0,t1
        lw      t2,0(s1)

        addi    s1,s1,8
        lw      t3,0(s1)
        blt     t2,t3,continue

        jal     ra,swap
        addi    a4,a4,-1
        jal     ra,sort3
        lw      ra,0(sp)
        addi    sp,sp,8
        ret
        


continue:
        addi    sp,sp,-8
        sw      ra,0(sp)
        addi    a4,a4,-1
        jal     ra,sort3
        lw      ra,0(sp)
        addi    sp,sp,8
        ret
        

# swap  a4=j
swap:
        addi    sp,sp,-8
        sw      ra,0(sp)
        slli    t1,a4,3
        addi    t2,a4,1
        slli    t2,t2,3
        add     s3,s0,t1
        add     s4,s0,t2
        lw      t2,0(s3)
        lw      t3,0(s4)
        sw      t2,0(s4)
        sw      t3,0(s3)
        lw      ra,0(sp)
        addi    sp,sp,8
        ret




return:
        addi a0,a0,0
        ret



print_loop:
        # print space
        li      a0, 4
        la      a1, space
        ecall 

        # print arr[i]
        li      a0, 1
        lw      t1, 0(t0)
        mv      a1, t1
        ecall 

        # i = i+1 with t0 move right
        addi    t0, t0, 4
        # (n=t2) n--
        addi    t2, t2, -1
        # continue to loop, if n!=0
        bne     t2, zero, loop
        # else done, return
        ret     