.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    auipc x1, 0         # x1  = 6000 0000   Fill data_cache0
    addi x21, x1, 4     # x21 = 6000 0004
    addi x21, x1, 8     # x21 = 6000 0008
    addi x21, x1, 12    # x21 = 6000 000c
    addi x21, x1, 16    # x21 = 6000 0010
    addi x21, x1, 20    # x21 = 6000 0014
    addi x21, x1, 24    # x21 = 6000 0018
    addi x21, x1, 28    # x21 = 6000 001c
    
    auipc x2, 0         # x2  = 6000 0020   Fill data_cache2
    addi x22, x2, 4     # x22 = 6000 0024
    addi x22, x2, 8     # x22 = 6000 0028
    addi x22, x2, 12    # x22 = 6000 002c
    addi x22, x2, 16    # x22 = 6000 0030
    addi x22, x2, 20    # x22 = 6000 0034
    addi x22, x2, 24    # x22 = 6000 0038
    addi x22, x2, 28    # x22 = 6000 003c
    
    auipc x3, 0         # x3  = 6000 0040   Fill data_cache1
    addi x23, x3, 4     # x23 = 6000 0044
    addi x23, x3, 8     # x23 = 6000 0048
    addi x23, x3, 12    # x23 = 6000 004c
    addi x23, x3, 16    # x23 = 6000 0050
    addi x23, x3, 20    # x23 = 6000 0054
    addi x23, x3, 24    # x23 = 6000 0058
    addi x23, x3, 28    # x23 = 6000 005c

    auipc x4, 0         # x4  = 6000 0060   Fill data_cache3
    addi x24, x4, 4     # x24 = 6000 0064
    addi x24, x4, 8     # x24 = 6000 0068
    addi x24, x4, 12    # x24 = 6000 006c
    addi x24, x4, 16    # x24 = 6000 0070
    addi x24, x4, 20    # x24 = 6000 0074
    addi x24, x4, 24    # x24 = 6000 0078
    addi x24, x4, 28    # x24 = 6000 007c

    lw x11, 0(x1)       # x11 = 0000 0097   Read from data_cache0
    lw x12, 0(x2)       # x12 = 0000 0117   Read from data_cache2
    lw x13, 0(x3)       # x13 = 0000 0197   Read from data_cache1
    lw x14, 0(x4)       # x14 = 0000 0217   Read from data_cache3
    lw x11, 0(x1)       # x11 = 0000 0097   Read from data_cache0
    lw x12, 0(x2)       # x12 = 0000 0117   Read from data_cache2
    lw x13, 0(x3)       # x13 = 0000 0197   Read from data_cache1
    lw x14, 0(x4)       # x14 = 0000 0217   Read from data_cache3

    auipc x5, 0         # x5  = 6000 00a0   OVERRIDE data_cache0
    addi x25, x5, 4     # x25 = 6000 00a4
    addi x25, x5, 8     # x25 = 6000 00a8
    addi x25, x5, 12    # x25 = 6000 00ac
    addi x25, x5, 16    # x25 = 6000 00b0
    addi x25, x5, 20    # x25 = 6000 00b4
    addi x25, x5, 24    # x25 = 6000 00b8
    addi x25, x5, 28    # x25 = 6000 00bc

    sw x11, 0(x5)       # change data_cache0 value: 297 ==> 97
    sw x11, 0(x2)       # change data_cache2 value: 117 ==> 97
    sw x11, 0(x3)       # change data_cache1 value: 197 ==> 97
    sw x11, 0(x4)       # change data_cache3 value: 217 ==> 97
    sw x11, 0(x5)       # change data_cache0 value: 97 ==> 97
    sw x11, 0(x2)       # change data_cache2 value: 97 ==> 97
    sw x11, 0(x3)       # change data_cache1 value: 97 ==> 97
    sw x11, 0(x4)       # change data_cache3 value: 97 ==> 97

    auipc x6, 0         # x6  = 6000 00c0   OVERRIDE data_cache0
    addi x26, x6, 4     # x26 = 6000 00c4
    addi x26, x6, 8     # x26 = 6000 00c8
    addi x26, x6, 12    # x26 = 6000 00cc
    addi x26, x6, 16    # x26 = 6000 00d0
    addi x26, x6, 20    # x26 = 6000 00d4
    addi x26, x6, 24    # x26 = 6000 00d8
    addi x26, x6, 28    # x26 = 6000 00dc

    addi x30, x30, 1    # dummy 6000 00e0
    lw x12, 0(x2)       # x12 = 0000 0117   Read from data_cache2
    lw x13, 0(x3)       # x13 = 0000 0197   Read from data_cache1
    lw x14, 0(x4)       # x14 = 0000 0217   Read from data_cache3
    addi x30, x30, 1    # dummy 6000 00f0
    addi x30, x30, 1    # dummy 6000 00f4
    addi x30, x30, 1    # dummy 6000 00f8
    addi x30, x30, 1    # dummy 6000 00fc

    lw x11, 0(x1)       # x11 = 0000 0097
                        # OVERRIDE data_cache0 with 6000 0000 data
                        # should see 97 in x31 instead of 297 if stored properly

    slti x0, x0, -256   # this is the magic instruction to end the simulation
