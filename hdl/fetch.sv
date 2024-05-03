module fetch
import rv32i_types::*;
(
    input   logic                           clk,
    input   logic                           rst,

    input   logic                           full,
    input   logic                           imem_resp,
    input   logic               [31:0]      imem_rdata,
    input   logic                           branch,
    input   logic               [31:0]      br_pc,
    input   logic                           prediction,
    input   logic               [31:0]      predict_pc,

    output  logic                           enq,
    output  logic               [31:0]      imem_addr,
    output  logic               [3:0]       imem_rmask,
    output  if_id_stage_reg_t               if_id_reg_next
);

    // ADD LOGIC FOR MISPREDICT

            logic   [31:0]  pc;
            logic   [31:0]  pc_next;
            logic   [31:0]  pc_false_predict;
            logic   [31:0]  hold_inst;
            logic           check;
            logic           iwait;              // May need to change to an output

    always_ff @( posedge clk ) begin
        if ( rst ) begin
            pc <= 32'h60000000;
        // branch have priority
        end else if (branch) begin
            pc <= br_pc;
        end else if (prediction && enq) begin          // predicted pc
            pc <= predict_pc;
        end else if ( full || iwait ) begin
            pc <= pc;
        end else begin
            pc <= pc_next;
        end
        if (!iwait) begin                       // Logic for OrdinaryMem maybe
            if (full) begin
                if( imem_resp && !check ) begin
                    hold_inst <= imem_rdata;
                    check <= '1;
                end
            end else begin
                hold_inst <= '0;
                check <= '0;
            end
        end else begin
            hold_inst <= '0;
            check <= '0;
        end
    end
    // How it works(for david):
    // First need to check if our instruction has came back after setting the imem_addr this info is in iwait
    // Next if so we need to check if we must latch the instruction cuz the iq maybe full
    // If it is we set check to be high in the next cycle which then sets the out_inst to be hold_inst 
    // which holds the past instruction.

    always_comb begin
        imem_rmask = '1;
        imem_addr = pc;
        enq = '0;
        iwait = '1;
        if_id_reg_next.out_inst = imem_rdata;
        if ( imem_resp ) begin 
            iwait = '0;
        end
        if ( imem_resp && !full && !branch ) begin
            enq = '1;
        end
        if ( check ) begin
            if_id_reg_next.out_inst = hold_inst;
        end
        if_id_reg_next.pc = pc;
        if_id_reg_next.pc_next = pc+4;
      
        pc_next = pc +  32'd4;
    end

endmodule : fetch
