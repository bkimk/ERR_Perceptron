//------------------------------------------------------------------
// free_list Description:
//  This module holds the registers that are "free" to use (ERR).
//  It utilizes head_ptr and tail_ptr to check the boundary of free registers.
// 
//  For branching, we use branch_head_ptr that only increments when there
//  is a commit. Notice there isn't a branch_tail_ptr b/c it is basically
//  same charateristic as the tail_ptr. Both are only updated when there is a commit.
//  When we branch, we simply change the head ptr to the branch_head_ptr.
//  
//  For jumping, it is similar to branching except that it is a commit then branch.
//  In short, commit + flush. Thus, the head_ptr should become a branch_head_ptr.
//  (no change in head_ptr when there is a commit so it is same as branching)
//  The tail_ptr should increment by 1 because there is a commit (jal/jalr) and 
//  then the branching occurs. Thus, tail_ptr should just be +1 of its original.
//  (Previously, I believe you took out +1 because it caused a gap where tail ptr skipped
//  a slot causing 0 to be inputted. However, the error was that when jumping, 
//  you weren't doing the commit. Thus, 0 was inputted into the slot.)
//  
//------------------------------------------------------------------
module free_list
import rv32i_types::*;
(   
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   enqueue,
    input   logic                   dequeue,
    input   logic   [PR_WIDTH-1:0]  freed_phys_reg,
    input   logic                   branch,
    input   logic                   jmp,
    
    output  logic                   is_empty,
    output  logic   [PR_WIDTH-1:0]  free_phys_reg
);

logic [PR_WIDTH-1 : 0] free_list_queue [PHYS_REG_NUM];
logic [PR_WIDTH-1 : 0] head_ptr;
logic [PR_WIDTH-1 : 0] tail_ptr;
logic [PR_WIDTH-1 : 0] branch_head_ptr;
logic [PR_WIDTH-1 : 0] phys_idx;

int cnt;

assign is_empty = ( cnt == 0 );
assign free_phys_reg = free_list_queue[head_ptr];

always_ff @( posedge clk ) begin 
    // base case where we reset free list to start from x20 onward
    if ( rst ) begin
        head_ptr <= '0;
        tail_ptr <= 6'd32;
        branch_head_ptr <= '0;
        cnt <= 32;
        for ( int i = 0; i < PHYS_REG_NUM; i++ ) begin
            if (i > 31) free_list_queue[i] <= '0;
            else free_list_queue[i] <= 6'(unsigned'(i)) + 6'd32;
        end
    end
    else if (jmp) begin                                     // jmp = commit + flush logic.
        if (freed_phys_reg == '0) begin                     // A special case where jal/jalr x0...
            head_ptr <= branch_head_ptr;                    // In this case, characteristic is 
            tail_ptr <= tail_ptr;                           // same as the branching/flushing logic.
            cnt <= 32;
        end else begin
            free_list_queue[tail_ptr] <= freed_phys_reg;    // accounting free_list with "commit" portion
            head_ptr <= branch_head_ptr + 1'b1;             // incrementing headptr with "commit" + "flushing"
            if ( tail_ptr == PR_NUM_LOGIC - 1'b1 ) begin    // <-- Due to circular queue
                tail_ptr <= '0;
            end else begin
                tail_ptr <= tail_ptr + 1'b1;
            end
            if (branch_head_ptr == PR_NUM_LOGIC - 1'b1 ) begin  // branch_head_ptr should increment as well
                branch_head_ptr <= '0;                          // cause there is a commit.
            end else begin
                branch_head_ptr <= branch_head_ptr + 1'b1;
            end
            cnt <= 32;
        end
    end else if (branch) begin                                  // A branching/flushing logic.
        head_ptr <= branch_head_ptr;
        tail_ptr <= tail_ptr;
        cnt <= 32;
    end
    else begin
        if ( enqueue && (cnt < PHYS_REG_NUM))  begin            // Enqueue Logic
            free_list_queue[tail_ptr] <= freed_phys_reg;
            head_ptr <= head_ptr;

            if (branch_head_ptr == PR_NUM_LOGIC - 1'b1 ) branch_head_ptr <= '0; 
            else branch_head_ptr <= branch_head_ptr + 1'b1;
            if (tail_ptr == PR_NUM_LOGIC - 1'b1 ) tail_ptr <= '0;
            else tail_ptr <= tail_ptr + 1'b1;
        end
        if ( dequeue && !(is_empty) ) begin                     // Dequeue Logic
            head_ptr <= head_ptr + 1'b1;

            if (head_ptr == PR_NUM_LOGIC - 1'b1 ) head_ptr <= '0; 
            else head_ptr <= head_ptr + 1'b1;
        end

        // count logic
        if (enqueue && (cnt < PHYS_REG_NUM) && dequeue && !(is_empty)) cnt <= cnt;
        else if (enqueue && (cnt < PHYS_REG_NUM)) cnt <= cnt + 1;
        else if (dequeue && !(is_empty)) cnt <= cnt - 1;
    end
end
endmodule : free_list