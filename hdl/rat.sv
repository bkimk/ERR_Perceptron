module rat
import rv32i_types::*;
(
    input   logic                   clk,
    input   logic                   rst, 
    input   cdb_t                   cdb, 
    input   logic                   dispatch_regf_we, 
    input   logic   [4:0]           dispatch_rd, 
    input   logic   [PR_WIDTH-1:0]  dispatch_pd, 
    input   logic   [4:0]           rs1, 
    input   logic   [4:0]           rs2, 
    input   logic                   branch,
    input   ROBEntry_t              commit,
    input   logic   [PR_WIDTH-1:0]  arch_phys_map_copy [RRF_NUM],

    output  logic   [PR_WIDTH-1:0]  ps1, 
    output  logic                   ps1_valid, 
    output  logic   [PR_WIDTH-1:0]  ps2, 
    output  logic                   ps2_valid
);

logic [PR_WIDTH-1:0] arch_phys_map [RAT_NUM];
logic valid_arr [RAT_NUM];

always_ff @( posedge clk ) begin
    if ( rst ) begin
        for ( int i = 0; i < RAT_NUM; i++ ) begin
            arch_phys_map[i] <= 6'(unsigned'(i));
            valid_arr[i] <= '1;
        end
    end else if ( branch ) begin
        for ( int i = 0; i < RAT_NUM; i++ ) begin
            if (commit.archReg == 5'(unsigned'(i)) && commit.jmp) begin
                arch_phys_map[i] <= commit.pReg;
            end else begin
                arch_phys_map[i] <= arch_phys_map_copy[i];
            end
            valid_arr[i] <= '1;
        end
    end else begin        
        if (cdb.cdb_valid && dispatch_regf_we && (dispatch_rd == cdb.arch_reg )) begin
            valid_arr[dispatch_rd] <= 1'b0;
            arch_phys_map[dispatch_rd] <= dispatch_regf_we ? dispatch_pd : arch_phys_map[dispatch_rd];
        end else begin
            if (dispatch_regf_we) begin
                valid_arr[dispatch_rd] <= 1'b0;
                arch_phys_map[dispatch_rd] <= dispatch_pd;
            end
            if ( cdb.cdb_valid && (arch_phys_map[cdb.arch_reg] == cdb.phys_reg)) begin
                valid_arr[cdb.arch_reg] <= 1'b1;
                arch_phys_map[dispatch_rd] <= dispatch_regf_we ? dispatch_pd : arch_phys_map[dispatch_rd];
            end
        end
    end
end

always_comb begin
    ps1_valid = valid_arr[rs1];
    ps2_valid = valid_arr[rs2];
    ps1 = arch_phys_map[rs1];
    ps2 = arch_phys_map[rs2];
    if (cdb.cdb_valid && (arch_phys_map[cdb.arch_reg] == cdb.phys_reg)) begin
        if (rs1 == cdb.arch_reg) ps1_valid = 1'b1;
        if (rs2 == cdb.arch_reg) ps2_valid = 1'b1;
    end
end



endmodule : rat