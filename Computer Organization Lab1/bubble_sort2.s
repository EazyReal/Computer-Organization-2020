.data
N:.word 10
str1:.string "Array: "
str2:.string "\n"
str3:.string " "
str4:.string "Sorted: "

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
        la      a1,str1
        li      a0,4
        ecall

          
        addi    sp,sp -88
        mv      s0,sp
        lw      a0,array1
        sw      a0,0(s0)
        lw      a0,array2
        sw      a0,8(s0)
        lw      a0,array3
        sw      a0,16(s0)
        lw      a0,array4
        sw      a0,24(s0)
        lw      a0,array5
        sw      a0,32(s0)
        lw      a0,array6
        sw      a0,40(s0)
        lw      a0,array7
        sw      a0,48(s0)
        lw      a0,array8
        sw      a0,56(s0)
        lw      a0,array9
        sw      a0,64(s0)
        lw      a0,array10
        sw      a0,72(s0)

        li      a6,0
        lw      a7,N
        jal     ra,print

        la      a1,str2
        li      a0,4
        ecall

        jal     ra,sort

        la      a1,str4
        li      a0,4
        ecall

        li      a6,0
        lw      a7,N


        jal     ra,print

        la      a1,str2
        li      a0,4
        ecall        

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



print:
        addi    sp,sp,-8
        sw      ra,0(sp)
        slli    a5,a6,3
        add     s5,s0,a5

        lw      a1,0(s5)
        li      a0,1
        ecall

        la      a1,str3
        li      a0,4
        ecall

        addi    a6,a6,1
        
        blt     a6,a7,print
        lw      ra,0(sp)
        addi    sp,sp,8
        ret