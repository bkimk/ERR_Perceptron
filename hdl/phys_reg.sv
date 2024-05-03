module phys_reg
import rv32i_types::*;
(
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   cdb_regf_we,
    input   logic   [PR_WIDTH-1:0]  cdb_pd, 
    input   logic   [31:0]          cdb_pd_value, 
    input   logic                   cdb_is_store, 
    input   logic   [PR_WIDTH-1:0]  alu_ps1, 
    input   logic   [PR_WIDTH-1:0]  alu_ps2, 
    input   logic   [PR_WIDTH-1:0]  mul_ps1, 
    input   logic   [PR_WIDTH-1:0]  mul_ps2, 
    input   logic   [PR_WIDTH-1:0]  mem_ps1,    
    input   logic   [PR_WIDTH-1:0]  mem_ps2, 

    output  logic   [31:0]          alu_ps1_value, 
    output  logic   [31:0]          alu_ps2_value, 
    output  logic   [31:0]          mul_ps1_value, 
    output  logic   [31:0]          mul_ps2_value, 
    output  logic   [31:0]          mem_ps1_value, 
    output  logic   [31:0]          mem_ps2_value
);

    logic [31:0] pr_data [PHYS_REG_NUM];


    always_ff @( posedge clk ) begin
        if ( rst ) begin
            for ( int i = 0; i < PHYS_REG_NUM; i++ ) begin
                pr_data[i] <= '0;
            end
        end else if (cdb_pd != 6'd0 )begin
            if (cdb_regf_we && !cdb_is_store ) pr_data[cdb_pd] <= cdb_pd_value;
        end
    end

    assign alu_ps1_value = pr_data[alu_ps1];
    assign alu_ps2_value = pr_data[alu_ps2];
    assign mul_ps1_value = pr_data[mul_ps1];
    assign mul_ps2_value = pr_data[mul_ps2];
    assign mem_ps1_value = pr_data[mem_ps1];
    assign mem_ps2_value = pr_data[mem_ps2];

endmodule : phys_reg