.globl __start

.rodata
    division_by_zero: .string "division by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################

    li t0, 0
    beq s1, t0, addition
    
    li t0, 1
    beq s1, t0, subtraction
    
    li t0, 2
    beq s1, t0, multiplication
    
    li t0, 3
    beq s1, t0, integer_division
    
    li t0, 4
    beq s1, t0, minimum
    
    li t0, 5
    li s3, 1
    beq s1, t0, power
    
    li t0, 6
    beq s1, t0, factorial
    
addition:
    add s3, s0, s2
    j output
    
subtraction:
    sub s3, s0, s2
    j output
    
multiplication:
    mul s3, s0, s2
    j output
    
integer_division:
    li t0, 0
    beq s2, t0, division_by_zero_except
    divu s3, s0, s2
    j output
    
minimum:
    bge s0, s2, result_s2
    addi s3, s0, 0
    j output

result_s2:
    addi s3, s2, 0
    j output
    
power:
    li t0, 0
    beq s2, t0, output
    mul s3, s3, s0
    addi s2, s2, -1
    j power
    
factorial:
    mul s3, s3, s0
    addi s0, s0, -1
    beq s0, x0, output
    j factorial

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
