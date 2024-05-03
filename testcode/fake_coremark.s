.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.


    # Add your own test cases here!
    addi x0, x0 0
    addi x1, x0 0
    addi x2, x0 0
    addi x3, x0 0
    addi x4, x0 0
    addi x5, x0 0
    addi x6, x0 0
    addi x7, x0 0
    addi x8, x0 0
    addi x9, x0 0
    addi x10, x0 0
    addi x11, x0 0
    addi x12, x0 0
    addi x13, x0 0
    addi x14, x0 0
    addi x15, x0 0
    addi x16, x0 0
    addi x17, x0 0
    addi x18, x0 0
    addi x19, x0 0
    addi x20, x0 0
    addi x21, x0 0
    addi x22, x0 0
    addi x23, x0 0
    addi x24, x0, 0
    addi x25, x0, 0
    addi x26, x0, 0
    addi x27, x0, 0
    addi x28, x0, 0
    addi x29, x0, 0
    addi x30, x0, 0
    addi x31, x0, 0


    x6000
    x6004
    6004 + 636

    branch
    + 4
    branch
    + 4
    
    x600d

    auipc x6, 4
    addi x6, x6, 636
    auipc x7, 5
    beq x6, x7, 16
    beq x1, x19, 102
    sw x0, 0(x6)
    addi x6, x6, 4
    bltu x6, x7, -8
    sw x0, 0(x6)
    addi x6, x6, 4
    bltu x6, x7, -8
    sw x0, 0(x6)
    addi x6, x6, 4
    bltu x6, x7, -8
    slti x0, x0, -256

    

        
    slti x0, x0, -256 # this is the magic instruction to end the simulation


    # 13
    # 93
    # 113
    # 193
    # 213
    # 293
    # 313
    # 393
    # 413
    # 493
    # 513
    # 593
    # 613
    # 693
    # 713
    # 793
    # 813
    # 893
    # 913
    # 993
    # a13
    # a93
    # b13
    # b93
    # c13
    # c93
    # d13
    # d93
    # e13
    # e93
    # f13
    # f93
    # 4317
    # 27c30313
    # 5397
    # a5038393
    # 730863
    # 32023
    # 430313
    # fe736ce3
    # 32023
    # 430313
    # fe736ce3
    # 32023
    # 430313
    # fe736ce3
    # f0002013