.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.
  
 
    # Basic arithmetic operations
    addi x1, x0, 10     # x1 = 10
    addi x2, x0, 20     # x2 = 20

    # Branching
    bne x1, x2, label_1  # Branch if x1 != x2
    addi x3, x0, 100     # x3 = 100 (This should not be executed)
    nop
    nop
label_1:
    addi x3, x0, 200     # x3 = 200 (This should be executed)

    # Jump and Link (JAL)
    jal x4, jump_target  # Jump and link to jump_target, return address is stored in x4
    addi x5, x0, 300     # x5 = 300 (This should not be executed)

jump_target:
    addi x6, x0, 400     # x6 = 400 (This should be executed)

   

    slti x0, x0, -256 # this is the magic instruction to end the simulation
