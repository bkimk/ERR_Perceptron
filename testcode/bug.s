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


    slti x0, x0, -256 # this is the magic instruction to end the simulation
