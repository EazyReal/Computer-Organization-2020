.data
N: .word 10 #N
str1: .string "Array: "
str2: .string "Sorted: "
str3: .string " "
str4: .string "\n"

.text
main:
        la      a1,str1
        li      a0,4
        ecall

        #create stack
        addi    sp,sp,-60
        #save s0
        sw      s0,56(sp) # store word
        #update s0
        addi    s0,sp,60 # add immidiate

        #init arr[] to memory
        li      a5,5 #load integer
        sw      a5,-60(s0)
        li      a5,3
        sw      a5,-56(s0)
        li      a5,6
        sw      a5,-52(s0)
        li      a5,7
        sw      a5,-48(s0)
        li      a5,31
        sw      a5,-44(s0)
        li      a5,23
        sw      a5,-40(s0)
        li      a5,43
        sw      a5,-36(s0)
        li      a5,12
        sw      a5,-32(s0)
        li      a5,45
        sw      a5,-28(s0)
        li      a5,1
        sw      a5,-24(s0)

        li      a6,0
        lw      a7,N
        jal     ra,print

        la      a1,str4
        li      a0,4
        ecall

        #init i to memory
        sw      zero,-12(s0)
        j       .L2

        la      a1,str2
        li      a0,4
        ecall

        li      a6,0
        lw      a7,N

        jal     ra,print

        la      a1,str4
        li      a0,4
        ecall       

        li       a5, 10
        ecall

.L6:
        #init j to memory
        sw      zero,-16(s0)
        j       .L3
.L5:
        #load arr[ j ] to a4
        lw      a5,-16(s0)
        slli    a5,a5,2
        addi    a4,s0,-8
        add     a5,a4,a5
        lw      a4,-24(a5)

        #load arr[j+1] a5
        lw      a5,-16(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a3,s0,-8
        add     a5,a3,a5
        lw      a5,-24(a5)
        
        #if arr[j + 1] > arr[j] 
        bge     a5,a4,.L4

# arr[j+1] < arr[j]

        #load arr[j] a5
        lw      a5,-16(s0)
        slli    a5,a5,2
        addi    a4,s0,-12
        add     a5,a4,a5
        lw      a5,-24(a5)

        #store arr[j] to tmp
        sw      a5,-20(s0)

        #load arr[j+1] to a4
        lw      a5,-16(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-12
        add     a5,a4,a5
        lw      a4,-24(a5)

        #arr[j] = arr[j+1]
        lw      a5,-16(s0)
        slli    a5,a5,2
        addi    a3,s0,-8
        add     a5,a3,a5
        sw      a4,-24(a5)

        #store tmp to arr[j+1]
        lw      a5,-16(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-8
        add     a5,a4,a5
        lw      a4,-20(s0)
        sw      a4,-24(a5)
.L4:
        #j++
        lw      a5,-16(s0) #a5=j
        addi    a5,a5,1
        sw      a5,-16(s0)
.L3:
        #check (j - i) < 9
        li      a4,9
        lw      a5,-12(s0)
        sub     a5,a4,a5
        lw      a4,-16(s0)
        blt     a4,a5,.L5

        #i++
        lw      a5,-12(s0)
        addi    a5,a5,1
        sw      a5,-12(s0)
.L2:
        #check i < 10
        lw      a4,-12(s0)
        li      a5,8
        bge     a5,a4,.L6

        #return
        li      a5,0
        mv      a0,a5
        lw      s0,56(sp)
        addi    sp,sp,60
        jr      ra


print:
        addi    sp,sp,-60
        sw      s0,56(sp)
        slli    a5,a6,2
        add     s5,s0,a5

        lw      a1,-24(s5)
        li      a0,1
        ecall

        la      a1,str3
        li      a0,4
        ecall

        addi    a6,a6,1
        
        blt     a6,a7,print
        lw      s0,56(sp)
        addi    sp,sp,60
        ret