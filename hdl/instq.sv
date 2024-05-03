module instq
import rv32i_types::*;
#(parameter int WIDTH = 32, parameter int DEPTH = 5)

(
    
    input   logic               clk,
    input   logic               rst,
    input   logic               enq,
    input   logic               deq,
    input   if_id_stage_reg_t   if_id_reg,
    input   logic               branch,

    // For Gshare
    input   logic               prediction,

    output  logic   [31:0]      branch_pc,
    output  logic               gshare_is_br,
    output  logic   [31:0]      branch_imm,

    output  logic               empty,
    output  logic               full,
    output  if_id_stage_reg_t   if_id_reg_out

);

logic prediction_queue  [DEPTH-1:0];
logic [WIDTH-1:0] queue [DEPTH-1:0];
logic [31:0]  PCqueue [DEPTH-1:0];
logic [31:0]  PC_next_queue [DEPTH-1:0];
int cnt, head, tail;

// For Gshare
always_comb begin
    branch_pc = '0;
    gshare_is_br = '0;
    branch_imm = '0;
    if (if_id_reg.out_inst[6:0] == op_b_br) begin
        branch_pc = if_id_reg.pc;
        gshare_is_br = 1'b1;
        branch_imm = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[7], if_id_reg.out_inst[30:25], if_id_reg.out_inst[11:8], 1'b0} + if_id_reg.pc;
    end
end

// Branch Next Used for Magic because for cache request is being 
// changed combinationally so received data is correct
// logic   branch_next;
// always_ff @ (posedge clk) begin
//     branch_next <= branch;
// end

always_ff @( posedge clk ) begin 
    // if (rst || branch || branch_next ) begin
    if (rst || branch) begin
        head <= 0;
        tail <= 0;
        for ( int i = 0; i < DEPTH; i++ ) begin
            PCqueue[i] <= '0;     
            queue[i] <= '0;       
            PC_next_queue[i] <= '0;
            prediction_queue[i] <= '0;
        end
        cnt <= 0;
    end
    else begin
        // enq
        if (enq && !(cnt == DEPTH)) begin
            queue[tail] <= if_id_reg.out_inst;
            PCqueue[tail] <= if_id_reg.pc;
            PC_next_queue[tail] <= if_id_reg.pc_next;
            prediction_queue[tail] <= prediction;
            if (tail == DEPTH-1) begin 
                tail <= 0;
            end else begin
                tail <= tail + 1;
            end
        end 
        // deq
        if (deq && cnt != 0) begin
            queue[head] <= '0;
            PCqueue[head] <= '0;
            PC_next_queue[head] <= '0;
            prediction_queue[head] <= '0;
            if (head == DEPTH-1) begin
                head <= 0;
            end else begin 
                head <= head + 1;
            end
        end

        if (enq && !(cnt == DEPTH) && deq && cnt != 0 ) cnt <= cnt;
        else if (enq && !(cnt == DEPTH)) cnt <= cnt +1;
        else if (deq && cnt != 0) cnt <= cnt - 1;
    end
end

assign if_id_reg_out.pc = (deq) ? PCqueue[head] : '0;
assign if_id_reg_out.pc_next = (deq )  ? PC_next_queue[head] : '0;
assign if_id_reg_out.out_inst = (deq )  ? queue[head] : '0;
assign if_id_reg_out.prediction = (deq) ? prediction_queue[head] : '0;
assign empty = (cnt == 0) ? '1 : '0;
assign full = (cnt == DEPTH) ? '1 : '0;

endmodule : instq