dependency_test.s: 
.align 4
.section .text
.globl _start
    # This program consists of small snippets
    # containing RAW, WAW, and WAR hazards

    # This test is NOT exhaustive
_start:

# initialize







   slti x0, x0, -256 # this is the magic instruction to end the simulation