.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.
    # Labels

    # Testing CP3
    addi x14, x0, 0
    addi x1, x0, 0
    auipc x14, 0
    lb x16, 0(x14)

    auipc x14, 0
    jal x20, point0
    lw x1, 0(x14)
    addi x1, x1, 1

    # JAL/JALR/BR Testing
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    jal x20, point0
    jal x20, point1
    jal x20, point2
    jal x20, point3
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point0: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    auipc x14, 0
    sw x16, 0(x14)
    bne x16, x16, point1
    jal x20, point1
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point1: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30
    auipc x13, 0
    lw x14, 0(x13)
    bgeu x1, x2, point3
    lw x14, 0(x13)
    lw x14, 0(x13)

point2: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point3: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point4: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point5: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point6: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point7: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point8: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30

point9: 
    addi x1, x0, 1
    addi x2, x0, 5
    addi x3, x0, 8
    addi x4, x0, 8
    addi x5, x0, 12
    addi x6, x0, 16
    addi x7, x0, 22
    addi x8, x0, 22
    addi x9, x0, 30



    # lbu x27, 1032(x0)
    # Load Stall Tests
    auipc x14, 0  # x14 <= pc + sext(immediate[31:12] << 12)
    lw x1, 0(x14)
    addi x1, x1, 1
    lui x1, 6
    beq x1, x1, rand_pos # 125th instruction

    auipc x1, 0
    lw x2, 0(x1)
    add x3, x1, x2

    # Forwarding Tests
    addi x11, x0, 0
    addi x1, x0, 4  # x1 <= 4
    addi x3, x1, 8  # x3 <= x1 + 8
    add x4, x3, x1 # x4 <= x3 + x1
    add x5, x11, x1 # x5 <= x11 + x1
    add x6, x1, x2
    addi x1, x0, 5
    addi x3, x1, 8
    auipc x24, 0
    addi x25, x24, 2
    lw x26, 2(x25)
    addi x2, x2, 20
    sll x4, x2, x1
    add x5, x2, x1
    slt x6, x1, x2

    # JAL testing
    jal x1, rand_pos

    # Individual Instruction testing
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

rand_pos:
    auipc x14, 0  # x14 <= pc + sext(immediate[31:12] << 12)
    #JALR Testing
    jalr x1, x14, 8
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

branch_testing: 
    # BR Testing
    addi x1, x0, 5
    addi x2, x0, 8
    addi x3, x0, 8
    beq x1, x2, one_nop
    bltu x3, x2, one_nop
    bltu x3, x2, one_nop

    nop
    nop
one_nop: 
    bne x1, x2, two_nop
    bltu x3, x2, one_nop
    nop
    nop
    nop
two_nop: 
    blt x1, x2, three_nop
    bltu x3, x2, one_nop
    nop
    nop
    nop
three_nop: 
    bge x1, x2, four_nop
    bltu x3, x2, one_nop
    nop
    nop
    nop
four_nop: 
    bltu x1, x2, five_nop
    bltu x3, x2, one_nop
    nop
    nop
    nop
five_nop: 
    bgeu x1, x2, six_nop

    bltu x3, x2, one_nop
    nop
    nop
    nop
six_nop: 
    beq x3, x2, seven_nop
    bltu x3, x2, one_nop

    nop
    nop
    nop
seven_nop: 
    bne x3, x2, eight_nop
    bltu x3, x2, one_nop

    nop
    nop
    nop
eight_nop: 
    blt x3, x2, nine_nop
    bltu x3, x2, one_nop

    nop
    nop
    nop
nine_nop:
    bge x3, x2, ten_nop
    bltu x3, x2, one_nop

    nop
    nop
    nop
ten_nop: 
    bltu x3, x2, eleven_nop
    bltu x3, x2, one_nop
    nop
    nop
eleven_nop: 
    bgeu x3, x2, tweleve_nop
    bltu x3, x2, one_nop

    nop
    nop
    nop
tweleve_nop: 
    slti x0, x0, -256 # this is the magic instruction to end the simulation