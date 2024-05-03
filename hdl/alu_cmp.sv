//------------------------------------------------------------------
// alu_cmp Description:
//  This module holds both alu and cmp option.
//  It uses the operation input from RS_package to determine 
//  which operations to do. Specifically, 4 bits =
//  bit3 = 1 uses alu , 0 = use cmp
//  bit2-0 = funct3
//  
//  It will output both alu and cmp options as the same output cdb_output
//  When doing compare operations, it saves its data in the least
//  significant bit (bit 0) and the rest of the bits are zeroed out.
//  It has a latch that holds on to the data of current operation and
//  released when the arbiter is ready to take the data. Until then, 
//  the module will not send out "ready" signal to reserveAM.
//
//  logic: First check did the computation finish. 
//  Next check can you output that instruction on to arbitrer
//  addFU ready is driven by if compoutation finish and it has outputed
//  Computation finishes every cycle so no need to check
//  So we need to latch the output until we get an ack from arbitrer (and output is computed)
//  Two thoughts do we output a bunch of nops with a valid bit (rn)
//  or real instructions but another bit to say if u use it
//  If first thougt then we need to wait for a real instruction 
//  by checking valid then latch if arbitrer not ready
//  Once latch we need to send a stall signal to RS to 
//  continuse to output a bunch of fake instructions 
//  or at least not output any real instuctions. Once Abitrer says its ready it will use the output
//  If second thought then we need to look at enable bit (called for now)
//  If its like this then we can send the stall signal to RS to continue to latch onto the curent instruction
//  which FU will still have as its output. Now once Abitrer is done send the ack signal to RS.
//  RS no longer needs to latch so either it changes its output or it holds the same output but the enable bit is set down
//  we push the output onto the  next cycle
//  timing overall not sure
//  
//------------------------------------------------------------------

module alu_cmp
import rv32i_types::*;
(
    input   logic                   clk, 
    input   logic                   rst, 
    input   ReservationEntry_t      RS_package, 
    input   logic   [31:0]          a, b,
    input   logic                   cdb_alu_ack,

    output  cdb_t                   cdb_output, 
    output  logic                   ready
);

    logic signed   [31:0] as;
    logic signed   [31:0] bs;
    logic unsigned [31:0] au;
    logic unsigned [31:0] bu;
    logic          [31:0] real_a;
    logic          [31:0] real_b;

    always_comb begin
        real_a = a;
        real_b = b;
        unique case ( RS_package.opcode )
            op_b_jal, op_b_jalr : real_a = RS_package.imm_gen;
            op_b_lui, op_b_auipc:
                begin
                    real_a = 32'b0;
                    real_b = RS_package.imm_gen;
                end
            op_b_imm    : real_b = RS_package.imm_gen;
            op_b_br     : real_b = b;
            op_b_reg    : real_b = (RS_package.Op inside {{1'b1, alu_sra}, {1'b1, alu_srl}}) ? {27'b0, b[4:0]} : b;
            default     :;
        endcase
    end

    assign as =   signed'(real_a);
    assign bs =   signed'(real_b);
    assign au = unsigned'(real_a);
    assign bu = unsigned'(real_b);

    // Local data that needs to be saved for cdb packaging when we send it to the arbiter
    logic                   local_cdb_valid;
    logic [4:0]             local_arch_reg;
    logic [PR_WIDTH-1:0]    local_phys_reg;
    logic [ROB_WIDTH-1:0]   local_rob;
    logic [31:0]            local_data;
    logic [31:0]            local_op1, local_op2;
    logic                   local_ready;
    logic                   local_is_branch, local_is_jalr;
    logic                   jalr_flag;
    logic [31:0]            local_branch_imm;

    logic [31:0]            f;              // output from computation
    logic                   alu_comp_done;  // flag to check if computation is done
    logic                   br_flag;        // flag for branch

    // ALU & CMP
    always_comb begin
        // if the input has both data ready, 
        if ( RS_package.prs1Ready && RS_package.prs2Ready) begin
            // check the last bit of Op which 1 = use ALU, 0 = use CMP
            if ( RS_package.Op[3] ) begin
                unique case ( RS_package.Op[2:0] )
                    alu_add: f = au +   bu;
                    alu_sll: f = au <<  bu[4:0];
                    alu_sra: f = unsigned'( as >>> bu[4:0] );
                    alu_sub: f = au -   bu;
                    alu_xor: f = au ^   bu;
                    alu_srl: f = au >>  bu[4:0];
                    alu_or:  f = au |   bu;
                    alu_and: f = au &   bu;
                    default: f = 'x;
                endcase
            end else begin
                unique case ( RS_package.Op[2:0] )
                    beq:  f = { 31'b0, { ( au == bu ) } };
                    bne:  f = { 31'b0, { ( au != bu ) } };
                    blt:  f = { 31'b0, { ( as <  bs ) } };
                    bge:  f = { 31'b0, { ( as >=  bs ) } };
                    bltu: f = { 31'b0, { ( au <  bu ) } };
                    bgeu: f = { 31'b0, { ( au >=  bu ) } };
                    default: f = 32'bx;
                endcase
                
            end
            if ( RS_package.opcode inside {op_b_jal, op_b_jalr} || ( RS_package.opcode == op_b_br && f[0] ) ) begin
                br_flag = 1'b1;
                jalr_flag = ( RS_package.opcode == op_b_jalr ) ? 1'b1 : 1'b0;
            end
            else begin 
                br_flag = 1'b0;
                jalr_flag = 1'b0;
            end
        end else begin
            br_flag = 1'b0;
            jalr_flag = 1'b0;
            f = '0;
        end
    end

    // latching the data for cdb_output
    always_ff @( posedge clk ) begin
        if ( rst ) begin
            local_ready <= '0;
            local_cdb_valid <= '0;
            local_arch_reg <= '0;
            local_phys_reg <= '0;
            local_rob <= '0;
            local_data <= '0;
            local_op1 <= '0;
            local_op2 <= '0;
            local_branch_imm <= '0;
            local_is_branch <= '0;
            local_is_jalr <= '0;
        end else if ( ready ) begin
            local_ready <= 1'b1;    // when this module sends out ready, receives data 1 clk later
        end
        else if ( local_ready ) begin
            local_ready <= 1'b0;
            if ( RS_package.valid == 1'b1 ) begin
                local_cdb_valid <= RS_package.valid;
                local_arch_reg <= RS_package.archDest;
                local_phys_reg <= RS_package.pDest;
                local_rob <= RS_package.Wrob;
                local_data <= f;                        // alu and cmp are ready on the same cycle
                local_op1 <= a;
                local_op2 <= b;
                local_branch_imm <= RS_package.imm_gen;
                local_is_branch <= ( br_flag ) ? 1'b1 : 1'b0;
                local_is_jalr <= ( jalr_flag ) ? 1'b1 : 1'b0;
            end else begin
                local_cdb_valid <= '0;
                local_arch_reg <= '0;
                local_phys_reg <= '0;
                local_rob <= '0;
                local_data <= '0;
                local_op1 <= '0;
                local_op2 <= '0;
                local_branch_imm <= '0;
                local_is_branch <= 1'b0;
                local_is_jalr <= 1'b0;
            end
        end
        if ( rst ) begin
            alu_comp_done <= '1;
        end else if ( RS_package.valid ) begin
            alu_comp_done <= 1'b1;
        end else begin
            alu_comp_done <= alu_comp_done;
        end
    end

    // ready signal should be high when computation is done and arbiter is ready.
    assign ready = alu_comp_done && cdb_alu_ack;
    assign cdb_output.cdb_valid = ( ready ) ? local_cdb_valid : '0;
    assign cdb_output.rob = ( ready ) ? local_rob : '0;
    assign cdb_output.arch_reg = ( ready ) ? local_arch_reg : '0;
    assign cdb_output.phys_reg = ( ready ) ? local_phys_reg : '0;
    assign cdb_output.data = ( ready ) ? local_data : '0;
    assign cdb_output.ps1_rdata = ( ready ) ?  local_op1 : '0;
    assign cdb_output.ps2_rdata = ( ready ) ?  local_op2 : '0;
    assign cdb_output.is_store = 1'b0;
    assign cdb_output.is_branch = ( ready ) ?  local_is_branch : '0;
    assign cdb_output.is_jalr = ( ready ) ? local_is_jalr : '0;
    assign cdb_output.branch_imm = ( ready ) ?  local_branch_imm : '0;
    assign cdb_output.mem_addr = '0;
    assign cdb_output.mem_wdata = '0;
    assign cdb_output.mem_rdata = '0;
    assign cdb_output.mem_rmask = '0;
    assign cdb_output.mem_wmask = '0;

endmodule : alu_cmp