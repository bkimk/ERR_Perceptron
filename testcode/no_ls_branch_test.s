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
    SRA x19, x17, x23
    ANDI x4, x11, 77
    SLL x17, x13, x28
    SLTU x21, x23, x13
    XOR x27, x21, x24
    ORI x21, x15, -31
    ADD x11, x1, x15
    AUIPC x1, 15
    SUB x1, x5, x23
XOR x31, x18, x10





SLL x18, x0, x12





ADDI x12, x29, 65





ANDI x3, x2, -39





ORI x1, x13, 55





SRL x26, x23, x9





OR x8, x27, x14





ANDI x30, x13, 75





SLT x31, x1, x3





AUIPC x2, 7





SLTU x28, x12, x0





SRAI x28, x2, 0





SRAI x25, x2, 15





ORI x7, x31, -9





SUB x24, x30, x4





XORI x8, x16, 80





SRL x18, x29, x19





ANDI x13, x30, 74





ANDI x18, x5, 42





SUB x15, x6, x5





ANDI x19, x1, 12





AUIPC x12, 18





OR x1, x22, x3





ORI x22, x27, 75





SRL x13, x20, x30





ORI x28, x17, 34





SLLI x17, x7, 12





OR x31, x6, x2





OR x5, x22, x24





SLTI x5, x2, 1





SRL x6, x13, x19





SLT x22, x24, x11





LUI x31, 0





AND x4, x13, x11





XORI x19, x29, -46





SLTIU x5, x15, 66





AUIPC x9, 18





SLL x16, x29, x5





SLLI x22, x27, 7





SRL x11, x23, x13





SUB x2, x30, x9





ADDI x6, x24, 15





LUI x2, 11





XORI x13, x25, 37





ADDI x18, x9, -34





SLL x11, x3, x21





XORI x22, x17, 23





ANDI x29, x15, -60





SRL x8, x31, x11





ADDI x14, x16, -48





SLLI x19, x25, 23





SLT x1, x23, x26





AND x3, x3, x14





SLL x14, x20, x9





SLTI x15, x29, 16





SUB x1, x15, x4





XORI x11, x23, 75





ADDI x5, x22, 99





SRA x27, x14, x25





ADDI x25, x12, -62





SLT x23, x4, x20





SLTIU x1, x11, 80





AND x6, x2, x15





AUIPC x28, 11





ANDI x9, x17, 35





SUB x2, x31, x2





ORI x3, x12, -65





XORI x20, x9, 61





SRA x9, x6, x9





SLTI x16, x17, 71





SUB x1, x12, x31





SRAI x20, x31, 6





ORI x30, x27, 87





XORI x22, x13, 84





ANDI x12, x3, 12





SRLI x10, x23, 2





ORI x3, x22, -54





SRLI x25, x5, 31





SRL x11, x14, x14





SUB x2, x18, x7





ORI x30, x30, 65





SLTU x9, x12, x31





OR x11, x10, x26





SRL x12, x9, x16





ADDI x6, x27, -38





OR x23, x19, x18





SRA x24, x31, x3





AND x9, x13, x10





SLTU x24, x13, x30





SLTIU x10, x31, -23





SLTU x27, x1, x24





SLTI x22, x7, -3





SLTI x25, x15, -3





XOR x25, x28, x8





XORI x18, x14, 67





SLTI x19, x3, 34





SRA x29, x24, x10





SLT x9, x18, x22





AND x15, x14, x31





AND x0, x12, x22





SRA x25, x4, x3





SLTIU x12, x20, -22





AND x2, x17, x25





SLL x7, x6, x3





SRL x20, x15, x10





SLT x1, x29, x6





AUIPC x5, 9





XORI x8, x14, -3





SLTI x6, x2, -4





ADDI x7, x9, -16





SRL x17, x22, x25





ADDI x22, x27, -75





SRA x6, x18, x15





ORI x3, x0, -93





ORI x0, x24, 48





SLLI x26, x18, 1





SLLI x10, x10, 24





SLTI x4, x13, -32





SRAI x24, x17, 20





OR x0, x13, x24





SRLI x1, x20, 27





SRA x26, x13, x5





SUB x16, x20, x23





SRA x15, x27, x31





SUB x24, x8, x27





ANDI x2, x7, 77





ANDI x2, x19, -57





SLLI x2, x6, 22





SRL x2, x19, x9





OR x14, x27, x26





XORI x11, x16, -42





ADDI x3, x10, 3





SLLI x28, x2, 17





SRLI x3, x16, 27





SLLI x18, x31, 10





ORI x19, x25, -95





ORI x27, x14, 20





SRA x25, x16, x31





XORI x8, x25, -27





ANDI x11, x29, 70





ADD x17, x17, x25





ANDI x14, x15, 87





ADD x24, x30, x0





LUI x31, 24





SRAI x10, x6, 24





SRA x6, x16, x0





SLTU x21, x9, x30





SRL x21, x28, x31





LUI x23, 31





SRAI x31, x24, 6





ORI x2, x30, 48





ADDI x15, x28, 83





XOR x19, x28, x18





XORI x5, x15, 73





SLTU x18, x1, x22





ADDI x28, x12, 95





XOR x4, x28, x9





ADD x30, x16, x20





SLTU x7, x0, x2





AND x7, x0, x12





SLTU x12, x24, x15





SLTI x8, x8, -93





SRL x12, x13, x27





XOR x12, x19, x13





ADDI x23, x13, 83





SUB x2, x22, x26





AUIPC x12, 8





SLLI x23, x16, 12





SLL x21, x17, x26





SLT x15, x7, x24





AND x4, x6, x12





ANDI x1, x7, -81





ANDI x29, x31, -52





XOR x12, x9, x28





ANDI x31, x21, -65





AUIPC x15, 11





SLTI x27, x22, 88





SLTIU x20, x17, 76





ADDI x14, x11, 63





SLT x29, x17, x14





SLTU x16, x0, x30





SLTIU x15, x18, 15





SLL x0, x30, x13





SRL x24, x7, x29





SRA x16, x8, x22





ORI x15, x19, -3





SUB x23, x21, x31





XORI x9, x8, 57





ORI x14, x11, 95





SLTU x1, x4, x24





ANDI x0, x17, 43





SRAI x9, x1, 29





ADD x0, x1, x0





SLTIU x16, x28, 9





SRL x10, x25, x28





SLTIU x24, x21, -33





SRAI x29, x15, 17





XORI x4, x30, -84





ADD x0, x1, x7





SLT x5, x18, x25





SLTU x2, x25, x15





XORI x23, x27, 31





SLTU x29, x30, x9





SLTIU x24, x13, 79





SRAI x1, x29, 28





SLL x7, x30, x14





ANDI x12, x18, 26





SLLI x2, x18, 30





AUIPC x3, 8





SLT x13, x27, x1





AUIPC x12, 9





ORI x2, x25, -19





SRAI x6, x20, 24





SRL x20, x17, x3





AUIPC x20, 9





SLL x28, x31, x29





SLT x0, x9, x26





AND x21, x22, x28





SRAI x8, x5, 22





AND x1, x8, x0





SUB x30, x16, x31





ADDI x1, x7, 52





SLTI x14, x10, -62





ANDI x6, x26, 97





SLTI x13, x14, -28





SLTIU x2, x19, 56





SLTIU x11, x4, 77





SRL x3, x17, x21





ANDI x0, x16, 8





AND x25, x6, x29





SLTIU x3, x0, 2





ORI x8, x18, -6





SLTIU x14, x8, 78





SLTU x3, x7, x15





OR x31, x20, x18





AUIPC x12, 5





SRLI x10, x10, 25





SRA x28, x25, x23





SLTIU x7, x31, -25





SRAI x5, x7, 1





ADD x0, x19, x15





ADD x2, x15, x6





SUB x9, x15, x2





ORI x16, x4, -28





ADD x17, x11, x27





ADD x6, x8, x25





AUIPC x17, 17





SRA x4, x25, x1





SLTIU x31, x26, -71





ORI x2, x10, 29





XOR x14, x24, x7





ADD x2, x19, x5





LUI x11, 18





SLLI x20, x10, 22





SRLI x30, x25, 10





AUIPC x16, 2





SRAI x22, x26, 30





SRA x2, x4, x19





SLTIU x8, x11, 91





SLTIU x26, x28, -66





SRAI x10, x22, 5





SLTI x11, x17, 12





SLL x1, x4, x11





SLTI x10, x12, 65





AND x4, x27, x4





SRL x25, x18, x27





SLTIU x8, x2, -20





SLTU x30, x20, x24





AND x24, x21, x11





AND x29, x1, x24





SRLI x16, x6, 11





AUIPC x29, 27





LUI x26, 11





AND x31, x30, x26





XOR x5, x27, x6





SUB x2, x5, x11





AUIPC x10, 9





SLL x21, x24, x21





SRL x8, x5, x1





ANDI x2, x22, 40





SRAI x15, x30, 8





SLTI x8, x26, 75





OR x23, x26, x10





SLTIU x6, x28, -42





SUB x19, x11, x9





SRL x30, x24, x30





ORI x22, x24, -6





LUI x25, 10





XOR x8, x2, x2





XORI x14, x7, -36





XOR x7, x1, x6





SRL x14, x9, x7





SRLI x17, x29, 0





SLTU x24, x4, x27





LUI x10, 5





ANDI x26, x31, -99





ANDI x21, x24, -83





SLTU x27, x30, x26





ANDI x9, x24, 70





SUB x17, x28, x16





ADD x7, x31, x31





SLLI x31, x1, 1





SRL x8, x2, x7





XORI x10, x24, 18





ANDI x1, x10, 42





AUIPC x2, 21





SRL x22, x28, x7





AND x31, x15, x10





SLT x31, x8, x16





XOR x21, x22, x28





AUIPC x8, 18





SLTIU x12, x6, 97





XOR x18, x28, x11





SRL x8, x20, x28





AND x1, x8, x14





OR x12, x26, x22





LUI x0, 7





ADDI x10, x12, -47





SLLI x14, x23, 12





ADDI x9, x14, -11





SLTU x11, x23, x8





SLTI x6, x30, -24





SLTI x2, x30, -45





ANDI x17, x4, -18





SLL x11, x23, x28





SUB x12, x30, x29





SLTU x29, x19, x31





SLTI x29, x30, -87





SLLI x16, x13, 21





SRA x15, x20, x23





ADD x1, x31, x11





OR x14, x25, x22





OR x10, x12, x30





SLT x17, x0, x26





SLTI x11, x0, 42





SLT x3, x0, x22





SRL x20, x29, x24





SLTIU x10, x16, 31





AUIPC x11, 6





OR x14, x21, x1





SLL x10, x29, x1





SRL x30, x31, x16





SLTIU x15, x31, -71





OR x17, x0, x25





ADD x4, x25, x23





ANDI x14, x16, 59





SLTIU x3, x19, 44





SUB x31, x14, x24





SUB x28, x24, x23





LUI x2, 7





XORI x30, x3, 77





SLTI x3, x7, -36





AUIPC x13, 23





LUI x29, 14





SLL x29, x30, x1





SRLI x11, x19, 6





LUI x12, 17





XORI x10, x23, -46





ORI x4, x31, -84





AND x12, x13, x20





ANDI x7, x27, -26





SLT x7, x0, x13





SRAI x10, x5, 13





SLTI x20, x23, 52





SRLI x3, x31, 29





AND x25, x5, x16





AUIPC x18, 29





SRA x2, x11, x20





ADDI x17, x29, 45





LUI x7, 12





SLL x9, x26, x14





ADDI x4, x12, 94





LUI x15, 4





OR x27, x9, x20





SLTI x11, x23, -100





OR x22, x18, x24





SLL x2, x13, x3





ORI x8, x1, 38





SLTIU x26, x25, -67





ADD x4, x31, x26





SUB x17, x26, x12





SLLI x28, x14, 25





SLLI x18, x8, 29





ANDI x24, x23, 87





OR x18, x3, x16





SUB x10, x17, x10





SLT x19, x2, x5





SRLI x3, x9, 14





SUB x13, x29, x25





XORI x19, x19, 34





SLTIU x9, x21, -2





SRLI x20, x10, 23





ADD x15, x15, x26





SLLI x16, x9, 13





XORI x29, x20, 77





ANDI x14, x11, -18





SRL x20, x27, x17





SUB x19, x27, x14





ORI x4, x15, 85





SUB x13, x1, x29





SRL x28, x30, x2





ADDI x11, x30, -88





SLL x27, x26, x9





SRAI x0, x21, 31





AND x11, x10, x7





SRLI x0, x30, 17





SRAI x25, x25, 28





XORI x24, x22, -72





ADDI x30, x13, 54





SLTU x8, x6, x27





ADD x12, x27, x13





XOR x6, x22, x16





ADD x1, x31, x12





SLTIU x19, x15, 56





ADDI x22, x22, 33





ORI x23, x30, -92





SUB x28, x16, x24





SLLI x31, x16, 5





SRL x19, x5, x12





XORI x0, x17, -31





XOR x12, x31, x9





LUI x4, 15





LUI x6, 4





ORI x28, x2, -20





SLTI x30, x4, 11





XORI x25, x21, -60





SLLI x22, x30, 8





SRA x4, x9, x19





ANDI x21, x23, 92





AND x30, x8, x2





SUB x13, x30, x15





SLL x31, x4, x13





SUB x20, x20, x14





AUIPC x11, 1





AND x16, x9, x3





ANDI x28, x21, 53





ORI x16, x6, -3





SRA x1, x24, x14





XOR x15, x2, x23





ANDI x11, x12, 76





XORI x9, x25, 78





SLTU x5, x31, x20





SLT x11, x27, x25





OR x5, x14, x12





ADDI x3, x19, -60





ANDI x10, x23, 8





AND x12, x9, x0





SLTU x2, x14, x23





SRLI x0, x18, 10





XOR x24, x31, x19





XOR x11, x3, x28





SLL x17, x10, x16





XOR x2, x16, x8





SLT x21, x16, x25





ADDI x19, x27, 3





SLTU x19, x26, x16





OR x30, x31, x13





AUIPC x26, 0





SLLI x9, x27, 1





SLT x30, x5, x0





SRLI x7, x20, 31





XOR x1, x18, x20





SLT x9, x23, x5





SRAI x25, x15, 13





SUB x21, x22, x31





SLTI x25, x2, 100





AUIPC x16, 5





SRAI x7, x17, 11





ADDI x11, x6, 18





ANDI x17, x30, 95





SRLI x16, x11, 10





XOR x23, x10, x20





AUIPC x7, 9





SRLI x26, x31, 19





SLT x28, x15, x5





OR x24, x11, x4





XORI x3, x3, -39





SLTU x27, x30, x4





SLTIU x15, x4, 45





AUIPC x30, 19





ANDI x29, x25, 31





SLLI x14, x20, 8





SLL x2, x6, x12





SUB x6, x20, x20





AUIPC x28, 21





SRAI x5, x22, 17





ADDI x12, x4, 85





SLTIU x10, x7, -63





AUIPC x1, 23





ADDI x2, x3, 33





XOR x3, x19, x29





SLLI x17, x6, 2





ANDI x3, x1, 21





SLL x18, x2, x17





SUB x10, x10, x22





XOR x31, x28, x16





SLTI x31, x29, -30





SLTU x24, x25, x20





SLTIU x4, x29, 57





SLT x13, x15, x17





SLTIU x20, x20, 59





LUI x2, 6





SLTU x19, x31, x23





SUB x3, x1, x17





SLT x4, x25, x17





SLTU x17, x28, x1





SRLI x27, x16, 6





SRL x23, x25, x26





AND x25, x29, x29





ADDI x28, x25, 57





ANDI x7, x1, -93





SLTIU x26, x12, 11





XORI x24, x11, 8





SUB x26, x9, x9





ADDI x16, x17, 86





ADDI x21, x24, -37





OR x21, x12, x19





SLL x19, x11, x22





SLTU x25, x25, x7





ADD x26, x13, x31





SRL x7, x1, x13





LUI x27, 13





SLLI x24, x17, 4





OR x14, x31, x5





SRL x19, x31, x10





SLT x25, x4, x3





ORI x1, x24, -19





SRLI x2, x25, 20





SRLI x5, x9, 17





SRL x19, x12, x27





XOR x19, x3, x19





SLLI x21, x14, 12





ANDI x29, x2, -98





XOR x24, x1, x17





SRAI x4, x3, 9





ADDI x18, x19, -55





LUI x12, 7





XORI x10, x23, -80





SRLI x24, x19, 0





SUB x25, x23, x14





SRLI x20, x14, 28





AND x20, x6, x2





SRA x27, x24, x17





SRLI x18, x29, 27





SLL x28, x16, x6





SUB x17, x1, x12





SLT x7, x27, x18





SUB x14, x2, x24





XOR x13, x3, x26





SLLI x7, x25, 0





SLTI x9, x21, -56





ADDI x17, x22, -56





XORI x2, x21, 54





ADD x19, x2, x11





ADD x23, x8, x17





ORI x22, x27, 60





OR x10, x30, x18





SLT x22, x11, x18





XORI x7, x25, -81





SRAI x9, x2, 15





SLT x16, x27, x1





XOR x16, x18, x14





ANDI x19, x4, 83





SRAI x2, x25, 3





ADDI x28, x1, 62





SLTI x8, x2, -13





SLLI x2, x7, 14





SLTI x27, x9, 49





SRAI x27, x12, 25





AUIPC x5, 8





AUIPC x31, 11





ADD x31, x22, x28





OR x15, x9, x20





SLTU x2, x31, x9





SRLI x22, x9, 30





SLTU x4, x15, x16





SLT x28, x30, x21





ANDI x7, x13, 6





OR x10, x7, x18





SRLI x29, x31, 10





SLTIU x8, x31, -93





AND x5, x22, x27





SRL x26, x15, x3





SUB x26, x28, x28





LUI x11, 17





SUB x4, x27, x3





AUIPC x0, 26





XOR x7, x17, x16





OR x30, x24, x11





LUI x17, 14





SRA x19, x8, x26





ANDI x20, x5, 97





ADD x6, x8, x5





SLTU x7, x25, x1





SLL x10, x13, x9





OR x29, x1, x12





LUI x26, 28





SLLI x19, x27, 0





ORI x7, x3, 87





SRA x6, x26, x11





AND x21, x12, x22





SRAI x1, x5, 6





SUB x0, x22, x4





SRA x10, x17, x14





ADD x10, x16, x18





SLTU x10, x16, x29





SUB x5, x15, x21





OR x20, x26, x17





SLTI x28, x5, 74





ANDI x1, x3, -22





SLLI x31, x17, 9





SRLI x9, x7, 3





SUB x30, x23, x4





AND x25, x19, x10





XORI x20, x17, -81





SLTIU x5, x1, -18





ANDI x15, x3, -34





SUB x18, x27, x16





SRAI x4, x5, 9





LUI x12, 10





OR x26, x8, x3





AND x17, x15, x17





ADDI x27, x13, -25





SLTI x10, x5, -47





AUIPC x11, 27





SRAI x19, x14, 7





SLLI x29, x11, 31





OR x21, x4, x31





LUI x31, 0





ORI x28, x29, 53





OR x23, x15, x3





ADDI x0, x4, 5





SLTIU x12, x22, 63





SRA x20, x8, x26





XORI x8, x7, 67





ADDI x31, x26, 92





AUIPC x23, 21





LUI x24, 10





AND x11, x27, x21





ADD x29, x1, x5





ADD x24, x27, x13





ADDI x26, x0, -71





ADDI x13, x1, 51





SRL x6, x3, x21





SLTIU x13, x17, 30





SLLI x16, x5, 2





XOR x25, x14, x23





AND x0, x3, x0





ORI x9, x11, -60





ORI x14, x1, -47





SRLI x11, x12, 27





SLLI x16, x5, 22





SRA x14, x7, x1





ORI x28, x7, -80





SLTIU x15, x26, -23





SLTIU x15, x12, 43





ORI x10, x5, 71





XOR x1, x7, x9





ORI x13, x10, -68





SLTU x20, x23, x30





SLTIU x16, x28, -46





SRA x24, x16, x10





OR x15, x30, x26





ORI x7, x13, 41





ADDI x3, x24, -91





SLT x31, x18, x9





SLTI x29, x16, 35





SLT x3, x5, x22





SRA x25, x27, x24





LUI x31, 2





SRL x15, x18, x16





AUIPC x30, 0





AUIPC x3, 10





ORI x26, x28, 91





XORI x11, x10, 62





SRA x17, x0, x30





XOR x1, x20, x0





AUIPC x3, 24





SLTIU x18, x1, -5





SLLI x29, x26, 8





SLTIU x31, x23, -41





SRL x9, x25, x3





AND x28, x30, x16





SLL x10, x1, x24





OR x15, x18, x5





SRA x4, x8, x5





ADD x0, x4, x8





ADD x1, x30, x20





AND x25, x17, x18





SLT x12, x17, x11





SLT x28, x9, x2





AUIPC x30, 10





SLTU x25, x25, x26





AUIPC x7, 4





SLTIU x18, x0, 66





SRAI x28, x16, 31





SRA x28, x17, x17





SLL x7, x8, x18





ADDI x24, x25, 5





ORI x31, x2, 84





SLT x20, x10, x19





SLTI x18, x0, -26





OR x0, x28, x11





LUI x24, 0





ADD x9, x14, x3





SRAI x21, x21, 20





AUIPC x18, 27





SLTI x28, x23, 13





SUB x23, x28, x30





ANDI x14, x9, 54





SLTU x16, x9, x24





ANDI x29, x14, -54





SLTI x30, x9, 53





LUI x31, 25





SLTU x13, x18, x7





LUI x22, 6





SLTU x14, x6, x10





SRA x11, x30, x26





ADD x8, x29, x7





ADDI x14, x18, 20





SRLI x2, x5, 15





SRLI x31, x12, 29





OR x22, x13, x21





SLL x16, x1, x23





ADD x12, x18, x27





SLL x22, x27, x15





SLT x12, x18, x5





SRLI x6, x20, 13





SLLI x11, x14, 24





ANDI x13, x7, 89





SRAI x9, x20, 11





XORI x26, x0, -30





XOR x21, x24, x14





AUIPC x3, 2





AND x16, x1, x1





SRAI x12, x11, 3





SRA x11, x22, x3





AND x9, x29, x24





SUB x10, x24, x4





SLLI x24, x10, 24





SLTIU x13, x12, -26





AUIPC x23, 12





SRLI x1, x14, 20





ANDI x21, x12, -84





SRLI x19, x21, 3





LUI x17, 7





XOR x9, x29, x7





SLLI x16, x18, 30





SRA x4, x12, x5





ADD x22, x8, x30





SRAI x22, x6, 21





OR x15, x15, x23





OR x8, x27, x22





SLTI x23, x20, 65





XORI x21, x2, 4





XORI x25, x28, -34





SLLI x15, x4, 24





AUIPC x20, 18





ORI x23, x9, -35





SRLI x11, x6, 0





ORI x2, x31, 52





ADDI x17, x10, 2





OR x7, x10, x23





SLTI x3, x29, -43





OR x25, x13, x18





SLT x30, x27, x5





ANDI x19, x10, 17





OR x3, x18, x13





SRAI x29, x11, 17





SLL x28, x4, x19





OR x13, x8, x5





SRA x15, x30, x2





XOR x29, x20, x11





ADDI x13, x0, -59





SLL x28, x26, x9





XOR x3, x17, x16





ANDI x5, x3, 3





XORI x17, x4, -73





ANDI x16, x7, 63





LUI x24, 5





ADD x26, x20, x12





ADD x23, x31, x13





SLTU x8, x26, x0





ADD x23, x14, x23





SLL x6, x0, x18





ORI x7, x1, 10





SRL x4, x11, x14





SRLI x3, x22, 31





SLTI x21, x9, 55





ANDI x10, x1, 84





ORI x14, x23, 94





SLT x1, x6, x21





SLTU x23, x17, x28





ORI x3, x17, -59





XORI x8, x17, -4





SLTU x0, x28, x17





SLTI x27, x24, 76





SRL x4, x4, x25





SUB x9, x26, x6





SUB x19, x2, x26





SLL x6, x2, x15





AUIPC x13, 25





SRL x19, x22, x5





AUIPC x20, 9





LUI x7, 6





ANDI x4, x11, -67





SLTIU x20, x15, -89





SLT x17, x25, x4





SUB x17, x28, x27





SLLI x20, x1, 5





SLTI x5, x22, -51





SLLI x22, x31, 3





XORI x24, x7, -53





SLLI x15, x1, 31





SRA x17, x18, x12





SLTI x30, x7, -2





SLTI x31, x7, 90





ADDI x30, x4, -81





SRA x26, x11, x10





SLL x27, x9, x16





SLL x29, x31, x3





OR x3, x19, x12





ANDI x11, x29, -89





SRLI x5, x8, 25





SLL x28, x11, x8





XOR x19, x12, x19





ADDI x5, x21, 9





SLLI x3, x23, 13





ADDI x22, x12, -99





SLT x26, x24, x15





SLTU x15, x16, x11





ANDI x18, x15, 53





SLL x21, x31, x3





SLL x19, x0, x13





SRAI x16, x14, 26





ADD x16, x3, x22





XOR x13, x29, x13





ANDI x7, x7, -49





XORI x5, x18, 95





ADDI x4, x2, 14





XOR x20, x0, x21





XORI x4, x4, 11





AUIPC x30, 25





LUI x20, 1





SRL x4, x12, x9





AUIPC x15, 20





SLL x9, x6, x12





SLTU x14, x20, x22





SUB x31, x31, x11





AUIPC x22, 1





XOR x13, x9, x30





OR x19, x25, x10





ANDI x29, x11, 77





LUI x10, 13





AND x24, x17, x23





XORI x4, x9, -39





SLTI x17, x31, 25





SRL x20, x1, x2





XORI x25, x21, -55





LUI x26, 21





SLL x10, x21, x18





SRLI x22, x6, 30





SRAI x1, x16, 17





SRA x21, x0, x13





AUIPC x23, 8





XORI x24, x30, -38





ADDI x4, x11, 28





LUI x8, 0





SLTU x17, x31, x27





XORI x14, x8, -47





ORI x0, x7, -70





ORI x8, x10, -2





SRLI x29, x1, 14





SLT x18, x7, x19





SLT x1, x7, x7





OR x20, x31, x20





ADD x26, x27, x2





ADDI x26, x9, 1





SRL x22, x1, x17





SLL x7, x17, x0





SRLI x0, x1, 8





SLL x18, x12, x23





ANDI x30, x14, 76





SUB x14, x9, x30





ADDI x1, x9, -68





SLL x4, x23, x6





SLTU x8, x26, x26





AND x27, x12, x26





OR x14, x6, x7





AUIPC x30, 7





SRL x12, x17, x11





AND x21, x20, x4





XORI x10, x8, -75





SLL x1, x30, x11





SRL x29, x16, x28





AND x24, x28, x19





SLL x11, x15, x3





ORI x20, x22, 87





SUB x23, x21, x28





LUI x27, 15





SLTIU x20, x20, -43





AUIPC x8, 28





XOR x3, x14, x12





SUB x24, x18, x29





SLL x11, x31, x29





SLLI x17, x20, 13





SLTI x27, x17, -41





AND x9, x1, x1





SLT x20, x7, x15





SLLI x16, x30, 9





LUI x31, 25





ANDI x11, x18, -95





ADD x24, x10, x16





SRLI x9, x11, 2





SLTU x11, x16, x13





SUB x10, x27, x28





ADDI x14, x10, -39





SLTIU x6, x23, -33





SRL x27, x19, x4





SLT x26, x23, x15





SRL x4, x31, x24





SLT x17, x13, x24





SRA x6, x12, x4





SRA x24, x12, x14





SLT x3, x18, x31





AUIPC x29, 26





SRL x29, x29, x29





AUIPC x4, 1





SRAI x29, x12, 24





SLTI x13, x5, -87





ADDI x25, x31, -11





XORI x15, x8, 94





XORI x9, x30, 17





XORI x20, x2, 14





AUIPC x9, 12





LUI x1, 25





ANDI x22, x15, -76





XORI x16, x3, -47





LUI x12, 28





SRA x6, x14, x31





ADDI x5, x8, -99





AND x8, x15, x17





LUI x12, 25





SRAI x27, x15, 0





SLT x4, x9, x10





XORI x4, x14, -80





SLL x2, x11, x26





ORI x3, x5, 67





ORI x26, x26, 77





ORI x20, x8, -24





SLTI x21, x10, 28





ORI x9, x1, 40





SUB x21, x23, x27





SRA x0, x29, x0





ANDI x15, x26, 7





ANDI x18, x24, 76





SLTI x7, x31, 12





ADDI x2, x31, 82





SRLI x2, x19, 14





LUI x31, 26





ADDI x13, x26, -17





SLLI x0, x16, 28





LUI x12, 1





ANDI x12, x14, -49





SLT x0, x23, x19





SRAI x3, x30, 19





SRA x25, x1, x10





AND x0, x17, x10





SRAI x17, x6, 14





AUIPC x4, 20





XOR x3, x29, x16





SUB x22, x20, x26





SLLI x23, x4, 7





ORI x20, x18, -62





SRL x16, x22, x23





LUI x13, 27





ADDI x3, x12, -93





OR x16, x1, x11





SLT x31, x14, x28





ANDI x9, x7, 3





SUB x7, x30, x19





SRA x1, x24, x13





AUIPC x10, 20





SRL x0, x25, x2





OR x9, x29, x13





SRL x31, x27, x24





SLL x9, x4, x22





SRAI x13, x7, 5





SRLI x19, x20, 14





SLL x10, x12, x5





SUB x13, x12, x14





    slti x0, x0, -256 # this is the magic instruction to end the simulation
