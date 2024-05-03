module arbit
import rv32i_types::*;
(
    input   logic                   clk, 
    input   logic                   rst, 
    input   cdb_t                   alu_cdb, 
    input   cdb_t                   mul_cdb, 
    input   cdb_t                   mem_cdb, 
    input                           branch,

    output  cdb_t                   cdb, 
    output  logic                   alu_ack, 
    output  logic                   mul_ack, 
    output  logic                   mem_ack
);
    // Clear CDB three consecutive cycles on branch
    logic   branch_one, branch_two;

    always_ff @ (posedge clk) begin
        branch_one <= branch;
        branch_two <= branch_one;
    end

    // Declaration of State Names
    enum int unsigned {
        s_alu, s_mem, s_mul
    } state, state_next;

    // Shifting to Next State 
    always_ff @( posedge clk ) begin
        if (rst) begin
            state <= s_alu;
        end else begin
            state <= state_next;
        end
    end

    // FSM
    always_comb begin
        alu_ack = 1'b0;
        mul_ack = 1'b0;
        mem_ack = 1'b0;
        cdb = '0;
        unique case (state)
            s_alu: begin
                state_next = s_mem;
                if (branch || branch_one || branch_two) cdb = '0;
                else cdb = alu_cdb;
                alu_ack = 1'b1;
            end
            s_mem: begin
                state_next = s_mul;
                if (branch || branch_one || branch_two) cdb = '0;
                else cdb = mem_cdb;
                mem_ack = 1'b1;
            end
            s_mul: begin
                state_next = s_alu;
                if (branch || branch_one || branch_two) cdb = '0;
                else cdb = mul_cdb;
                mul_ack = 1'b1;
            end
            default: begin
                state_next = s_alu;
                cdb = 'x;
            end
        endcase
    end


endmodule

