.globl	__start

.text

T:
        ### s0 contains the head of the linked list ###
        addi sp, sp, -16
        sw ra, 12(sp)                      
        sw s0, 8(sp)                       
        sw s1, 4(sp)
        addi s0, sp, 16  
        sw a0, 0(s0)
        lw a1, 0(s0)
        bnez a1, not_zero
        j compute_done
        
not_zero:
        lw a2, 0(s0)
        li a1, 1
        bne a2, a1, not_zero_and_one
        j compute_done
        
not_zero_and_one:
        lw a1, 0(s0)
        addi a1, a1, -1
        mv a0, a1
        call T
        mv a1, a0
        slli s1,a1,1
        lw a1, 0(s0)
        addi a1, a1, -2
        mv a0, a1
        call T
        mv a1, a0
        add a1, s1, a1
        
compute_done:
        mv a0, a1
        lw ra, 12(sp)                      
        lw s0, 8(sp)                       
        lw s1, 4(sp)
        addi sp, sp, 16
        ret


__start:
        ### save ra、s0 ###                                   
        addi sp, sp, -16
        sw ra, 12(sp)                      
        sw s0, 8(sp)                                            
        ### read the numbers of the linked list ###
        call read_int
        ### if(nums == 0) output "Empty!" ###
        call T        
        call print_int
exit:   
        ### exit handling ###
        li a0, 0
        lw ra, 12(sp)                      
        lw s0, 8(sp)                       
        addi sp, sp, 16
	li a0, 10
	ecall

read_int:
	li a0, 5
	ecall
	jr ra

print_int:
	mv  a1, a0
	li a0, 1
	ecall
	li a0, 11
	li a1, ' '
	ecall
	jr ra
