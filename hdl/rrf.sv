//------------------------------------------------------------------
// rrf Description:
//  This module holds the committed mapping of the arch_phys maps.
//  
//  When branching, the copy of rrf should go into rat to revert
//  the rat back to state right after branch.
//  The connection to free list is done combinationally.
//  
//  RVFI signals are taken from this stage of the instruction execution.
//  
//------------------------------------------------------------------
module rrf
import rv32i_types::*;
(
    input   logic                   clk,
    input   logic                   rst,
    input   ROBEntry_t              commit,
    input   logic                   regf_we, 
    input   logic                   branch,

    output  logic   [PR_WIDTH-1:0]  old_phys_reg_index, 
    output  logic                   enqueue,
    output  logic   [PR_WIDTH-1:0]  arch_phys_map_copy [RRF_NUM]   // copy outputted combinationally
);

    logic   [PR_WIDTH-1:0]  arch_phys_map [RRF_NUM]; 
    logic   [63:0]          order;
    logic   [31:0]          real_pcwdata;
    logic                   branch_next;

    // Copy of RRF combinational set
    assign arch_phys_map_copy = arch_phys_map;
    assign old_phys_reg_index = regf_we ? arch_phys_map[commit.archReg] : 1'b0;
    assign enqueue = (regf_we && arch_phys_map[commit.archReg] != '0) ? 1'b1 : 1'b0;

    always_comb begin
        if (branch && commit.br && !commit.prediction) real_pcwdata = commit.br_imm;
        else if (branch && commit.prediction && !commit.br)real_pcwdata = commit.rvfi_sig.pc_wdata;
        else if (commit.prediction && commit.br) real_pcwdata = commit.br_imm;
        else real_pcwdata = commit.rvfi_sig.pc_wdata;
    end

    always_ff @( posedge clk ) begin
        if ( rst ) begin
            order <= '0;
            for ( int i = 0; i < RRF_NUM; i++ ) begin
                arch_phys_map[i] <= 6'(unsigned'(i));
            end
        end else begin
            if ( regf_we ) begin
                arch_phys_map[commit.archReg] <= commit.pReg;
            end
            if (regf_we) begin
                order <= order + 1'b1;
            end else begin
                order <= order;
            end

        end
    end

endmodule : rrf