.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    auipc x14, 0         # x14 <= pc + sext(immediate[31:12] << 12)
    # Testing load
    addi x15, x14, 1
    addi x1, x15, 1
    addi x2, x1, 1

    lb x16, 0(x14)
    lb x16, 1(x14)
    lb x16, 2(x14)
    lb x16, 3(x14)

    lb x16, 0(x15)
    lb x16, 1(x15)
    lb x16, 2(x15)
    lb x16, 3(x15)

    lh x17, 0(x14)
    lh x17, 1(x15)
    lh x17, 2(x14)
    lh x17, 3(x15)

    lw x18, 0(x14)
    lw x18, 1(x2)
    lw x18, 2(x1)
    lw x18, 3(x15)
    lw x18, 4(x14)
    
    lbu x19, 0(x14)
    lbu x19, 0(x14)
    lbu x19, 0(x14)
    lbu x19, 0(x14)
    lbu x19, 0(x14)
    lbu x19, 0(x14)
    lbu x19, 0(x14)

    lbu x19, 0(x14)
    lbu x19, 1(x14)
    lbu x19, 2(x14)
    lbu x19, 3(x14)
    lbu x19, 0(x15)
    lbu x19, 1(x15)
    lbu x19, 2(x15)
    lbu x19, 3(x15)

    lhu x20, 0(x14)
    lhu x20, 1(x15)
    lhu x20, 2(x14)
    lhu x20, 3(x15)

    # Testing store
    addi x5, x1, 1
    auipc x2, 0
    sb x1, 0(x2)

    sb x2, 0(x14)
    sb x2, 1(x14)
    sb x2, 2(x14)
    sb x2, 3(x14)
    sb x2, 0(x15)
    sb x2, 1(x15)
    sb x2, 2(x15)
    sb x2, 3(x15)

    sh x2, 0(x14)
    sh x2, 1(x15)
    sh x2, 2(x14)
    sh x2, 3(x15)

    sw x2, 0(x14)
    sw x2, 1(x5)
    sw x2, 2(x1)
    sw x2, 3(x15)
    sw x2, 4(x14)





    AUIPC x9, 0
    AUIPC x7, 0
    LUI x5, 0
    LUI x10, 0
    LUI x11, 0
    LB x1, 0(x7)
    LH x0, 0(x7)
    LW x1, 0(x7)
    LBU x4, 0(x7)
    LH x4, 0(x7)
    LHU x2, 0(x7)
    SB x3, 0(x7)
    LH x4, 0(x7)
    LH x3, 0(x7)
    LBU x4, 0(x7)
    SH x2, 0(x7)
    LW x0, 0(x7)
    LW x2, 0(x7)
    LHU x2, 0(x7)
    LW x0, 0(x7)
    SW x2, 0(x7)
    SW x4, 0(x7)
    SW x2, 0(x7)
    LHU x1, 0(x7)
    LB x1, 0(x7)
    SB x3, 0(x7)
    SW x4, 0(x7)
    LW x1, 0(x7)
    LBU x2, 0(x7)
    LHU x0, 0(x7)
    SB x3, 0(x7)
    LBU x2, 0(x7)
    LB x3, 0(x7)
    SW x4, 0(x7)
    SB x3, 0(x7)
    LW x2, 0(x7)
    LBU x4, 0(x7)
    LHU x2, 0(x7)
    LW x4, 0(x7)
    LHU x1, 0(x7)
    LBU x4, 0(x7)
    LHU x3, 0(x7)
    LH x4, 0(x7)
    LHU x4, 0(x7)
    LBU x2, 0(x7)
    SB x3, 0(x7)
    LH x3, 0(x7)
    LH x4, 0(x7)
    SW x2, 0(x7)
    LW x1, 0(x7)
    LBU x3, 0(x7)
    LW x4, 0(x7)
    SH x4, 0(x7)
    LH x1, 0(x7)
    LBU x0, 0(x7)
    LHU x2, 0(x7)
    SW x4, 0(x7)
    SB x3, 0(x7)
    LH x0, 0(x7)
    LH x2, 0(x7)
    LH x1, 0(x7)
    LHU x0, 0(x7)
    LBU x1, 0(x7)
    SB x0, 0(x7)
    LB x4, 0(x7)
    LW x4, 0(x7)
    LHU x1, 0(x7)
    LB x3, 0(x7)
    LBU x0, 0(x7)
    LH x2, 0(x7)
    SH x0, 0(x7)
    SH x0, 0(x7)
    SB x2, 0(x7)
    LBU x3, 0(x7)
    LB x0, 0(x7)
    LHU x1, 0(x7)
    LHU x1, 0(x7)
    SH x4, 0(x7)
    SW x1, 0(x7)
    SH x2, 0(x7)
    SH x3, 0(x7)
    LHU x0, 0(x7)
    LHU x2, 0(x7)
    LBU x2, 0(x7)
    LB x2, 0(x7)
    LW x2, 0(x7)
    SH x3, 0(x7)
    LB x2, 0(x7)
    SB x0, 0(x7)
    LHU x2, 0(x7)
    LB x2, 0(x7)
    LHU x3, 0(x7)
    LBU x0, 0(x7)
    SW x0, 0(x7)
    LH x4, 0(x7)
    LB x4, 0(x7)
    SW x3, 0(x7)
    SW x0, 0(x7)
    LW x1, 0(x7)
    SB x1, 0(x7)
    LB x3, 0(x7)
    LHU x1, 0(x7)
    SH x0, 0(x7)
    LBU x1, 0(x7)
    LHU x4, 0(x7)


    # Add your own test cases here!
        
    slti x0, x0, -256 # this is the magic instruction to end the simulation
