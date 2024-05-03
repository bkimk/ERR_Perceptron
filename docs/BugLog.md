# ECE 411: mp_ooo GUIDE

## Out-of-Order RISC-V Processor



# Getting Started
## Register 0
Expected behavior - In RAT R0 should always point to P0, when dispatching if a register needs to use R0 as a operand set it to be valid. If R0 is the Destination then set it to P0 and don't dequeue anything from free list. If the instruction with the R0 as its destination reg commits onto the RRF then dont push P0 to the Free List. Modify Physical Reg File to not change the P0 value. Also set the RAT reg_we to 0.

## Datastructures - Transparency
RAT - Reading Tranparency when writing to the data structure output its content if read is the same
    - When Dispatching to RAT from free list and recieving a CDB in the same cycle and both modify the same Arch Reg must continue to set the invalid bit as we reassigned it to a new Phys Reg.

(Optional Read Transparency for RAT apply this in RS where Enq and the CDB data is occuring in the same cycle and set the corresponding reg to valid)

ROB -


## Store/Load Branch Bugs

ROB - Branch signal must be driven combinationally as well as its corresponding br_imm. As a result in the rrf must pass into the always ff block to be read by the rvfi sig. If done sequentially the branch will signal will be generated one cycle later and the rob will be cleared another cycle later. This means that there is a cycle which needs to be invalidated when passing to rrf

ROB - When Enq and Deq the same time must address the counter and the commit signal appropriately as in must specify each case as this is a sequential block.

Fetch - Have Branch be a higher priority compared to the Instruction Queue being Full

Dispatching Branch instructions - set the rd to register 0

## Reservation Station / Functional Unit / Arbiter Interaction (Design)

- Arbiter is FSM (round robin). Gives ready signal to each FU every third cycle. 
- Add/Mul FU finishes operation and holds output until FU is ready.
- Reservation Station outputs valid (both Phys reg Ready) entries to the FU when ready signal is given. Outputted entry is set to 0 in the next cycle and current entry is sent in next cycle.

- Dequeue the Store instruction from the RS




