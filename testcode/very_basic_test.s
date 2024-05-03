.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.
    
    addi x1, x0, 12  # x1 <= 12
    addi x2, x1, -2  # x2 <= x1 - 2
    add x3, x1, x2  # x3 <= x1 + x2
    sub x4, x1, x2  # x4 <= x1 - x2
    sll x5, x1, x2  # x5 <= x1 << x2
    slt x6, x1, x2  # x6 <= x1 <s x2
    sltu x7, x1, x2  # x7 <= x1 <u x2
    xor x8, x1, x2  # x8 <= x1 ^ x2
    srl x9, x1, x2  # x9 <= x1 >>u x2
    sra x10, x1, x2  # x10 <= x1 >>s x2
    or x11, x1, x2  # x11 <= x1 | x2
    and x12, x1, x2  # x12 <= x1 & x2
    lui x13, 13  # x13 <= sext(immediate[31:12] << 12)
    auipc x14, 14  # x14 <= pc + sext(immediate[31:12] << 12)



    slti x0, x0, -256 # this is the magic instruction to end the simulation
