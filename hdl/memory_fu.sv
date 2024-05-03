module memory_fu
import rv32i_types::*;
(
    input   logic                       clk, 
    input   logic                       rst, 
    input   loadStoreReservationEntry_t LoadStore_RS_package, 
    input   logic   [31:0]              a, b,
    input   logic                       cdb_mem_ack,
    input   logic   [31:0]              dmem_rdata, 
    input   logic                       dmem_resp, 
    input   logic                       branch,

    output  logic   [31:0]              dmem_addr,
    output  logic   [3:0]               dmem_rmask,
    output  logic   [3:0]               dmem_wmask,
    output  logic   [31:0]              dmem_wdata,
    output  cdb_t                       mem_cdb_output, 
    output  logic                       mem_fu_ready
);

    enum int unsigned {IDLE, WAIT, DONE} curr_state, next_state;

    logic                           local_cdb_valid;
    logic   [ROB_WIDTH-1:0]         local_rob;
    logic   [4:0]                   local_arch_reg;
    logic   [PR_WIDTH-1:0]          local_phys_reg;
    logic   [31:0]                  local_op1;
    logic   [31:0]                  local_op2;
    logic   [31:0]                  local_data;
    logic                           local_is_store;
    logic   [31:0]                  local_dmem_addr;
    logic   [3:0]                   local_dmem_rmask;
    logic   [3:0]                   local_dmem_wmask;
    logic   [31:0]                  local_dmem_wdata;
    logic   [31:0]                  rvfi_dmem_rdata;
    logic   [31:0]                  combinational_mem;
    logic   [2:0]                   local_funct3;

    always_comb
    begin : state_transition
        next_state = curr_state;
        unique case (curr_state)
            IDLE:    next_state = LoadStore_RS_package.ls_valid ? WAIT : IDLE;
            WAIT:    next_state = ( dmem_resp ) ? DONE : WAIT;
            DONE:    next_state = ( (LoadStore_RS_package.ls_valid == 1'b0) && (cdb_mem_ack == 1'b1) ) ? IDLE : DONE;
            default: next_state = curr_state;
        endcase
    end : state_transition

    always_comb
    begin : state_outputs
        mem_fu_ready = '0;
        mem_cdb_output.cdb_valid = '0;
        mem_cdb_output.rob = '0;
        mem_cdb_output.arch_reg = '0;
        mem_cdb_output.phys_reg = '0;
        mem_cdb_output.data = '0;
        mem_cdb_output.ps1_rdata = '0;
        mem_cdb_output.ps2_rdata = '0;
        mem_cdb_output.is_store = '0;
        mem_cdb_output.is_branch = '0;
        mem_cdb_output.is_jalr = '0;
        mem_cdb_output.branch_imm = '0;
        mem_cdb_output.mem_addr = '0;
        mem_cdb_output.mem_wdata = '0;
        mem_cdb_output.mem_rdata = '0;
        mem_cdb_output.mem_rmask = '0;
        mem_cdb_output.mem_wmask = '0;
        dmem_addr = '0;
        dmem_rmask = '0;
        dmem_wmask = '0;
        dmem_wdata = '0;
        unique case (curr_state)
            DONE:
            begin
                if ( cdb_mem_ack ) begin
                    mem_fu_ready = 1'b1;
                    mem_cdb_output.cdb_valid = local_cdb_valid;
                    mem_cdb_output.rob = local_rob;
                    mem_cdb_output.arch_reg = local_arch_reg;
                    mem_cdb_output.phys_reg = local_phys_reg;
                    mem_cdb_output.data = local_data;
                    mem_cdb_output.ps1_rdata = local_op1;
                    mem_cdb_output.ps2_rdata = local_op2;
                    mem_cdb_output.is_store = local_is_store;
                    mem_cdb_output.mem_addr = local_dmem_addr;
                    mem_cdb_output.mem_wdata = local_dmem_wdata;
                    mem_cdb_output.mem_rdata = rvfi_dmem_rdata;
                    mem_cdb_output.mem_rmask = local_dmem_rmask;
                    mem_cdb_output.mem_wmask = local_dmem_wmask;
                end
            end
            IDLE: 
            begin
                mem_fu_ready = !LoadStore_RS_package.ls_valid;
            end
            WAIT: 
            begin
                dmem_addr = local_dmem_addr;
                // We require this logic for dmem_rmask b/c of a special case found in the coremark
                // There is a branch that is being processed. The processor will be taking that branch.
                // While doing the calculation, dirty load instructions may cause issue with memory port
                // by giving xxxx to the dmem_rmask. I have manually set the dmem_rmask to ver be xxxx.
                // This won't work (won't pass RVFI) if the load instructions were valid.
                // However, knowing that they won't be valid, I needed to fake the memory port with 0
                // to stall just enough so that branch is taken place and we move on.
                // Please move this comment to the top in the module description after reading.
                if (local_dmem_rmask inside {4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0011, 4'b1100, 4'b1111}) begin
                    dmem_rmask = local_dmem_rmask;
                end else begin
                    dmem_rmask = '0;
                end
                dmem_wmask = local_dmem_wmask;
                dmem_wdata = local_dmem_wdata;
            end
            default: ;
        endcase
    end : state_outputs

    assign combinational_mem = a + LoadStore_RS_package.offset;

    always_ff @ (posedge clk)
    begin
        if (rst || branch)
        begin
            curr_state <= IDLE;
            local_dmem_addr <= '0;
            local_dmem_rmask <= '0;
            local_dmem_wmask <= '0;
            local_dmem_wdata <= '0;
            local_funct3 <= '0;
            rvfi_dmem_rdata <= '0;

            local_cdb_valid <= '0;
            local_rob <= '0;
            local_arch_reg <= '0;
            local_phys_reg <= '0;
            local_op1 <= '0;
            local_op2 <= '0;
        end

        else
        begin
            curr_state <= next_state;
            unique case (curr_state)
                IDLE:
                begin
                    if (LoadStore_RS_package.ls_valid)
                    begin
                        unique case (LoadStore_RS_package.operation)
                            1'b0:
                            begin
                                local_dmem_addr <= combinational_mem - combinational_mem[1:0];
                                unique case ( LoadStore_RS_package.funct3 )
                                    lb, lbu : local_dmem_rmask <= 4'b0001 << combinational_mem[1:0];
                                    lh, lhu : local_dmem_rmask <= 4'b0011 << combinational_mem[1:0];
                                    lw      : local_dmem_rmask <= 4'b1111;
                                    default: local_dmem_rmask <= 4'b0000;
                                endcase
                                local_dmem_wmask <= '0;
                                local_is_store <= 1'b0;
                                local_dmem_wdata <= '0;
                            end
                            1'b1:
                            begin
                                local_dmem_addr <= combinational_mem - combinational_mem[1:0];
                                local_dmem_wdata <= b << 8*combinational_mem[1:0];                                
                                unique case (LoadStore_RS_package.funct3)
                                    sb: local_dmem_wmask <= 4'b0001 << combinational_mem[1:0];
                                    sh: local_dmem_wmask <= 4'b0011 << combinational_mem[1:0];
                                    sw: local_dmem_wmask <= 4'b1111;
                                    default: local_dmem_wmask <= '0;

                                endcase
                                local_dmem_rmask <= '0;
                                local_is_store <= 1'b1;
                            end
                            default:;
                        endcase

                        local_cdb_valid <= LoadStore_RS_package.ls_valid;
                        local_rob <= LoadStore_RS_package.Wrob;
                        local_arch_reg <= LoadStore_RS_package.archDest;
                        local_phys_reg <= LoadStore_RS_package.pDest;
                        local_op1 <= a;
                        local_op2 <= b;
                        local_funct3 <= LoadStore_RS_package.funct3;
                    end
                end
                WAIT:
                begin
                    if ( dmem_resp ) begin
                        if ( local_funct3 inside {lbu, lhu} ) begin
                            unique case ( local_dmem_rmask )
                                4'b0001 : local_data <= { 24'b0, dmem_rdata[7:0] };
                                4'b0010 : local_data <= { 24'b0, dmem_rdata[15:8] };
                                4'b0100 : local_data <= { 24'b0, dmem_rdata[23:16] };
                                4'b1000 : local_data <= { 24'b0, dmem_rdata[31:24] };
                                4'b0011 : local_data <= { 16'b0, dmem_rdata[15:0] };
                                4'b0110 : local_data <= { 16'b0, dmem_rdata[23:8] };
                                4'b1100 : local_data <= { 16'b0, dmem_rdata[31:16] };
                                4'b1111 : local_data <= dmem_rdata;
                                default : local_data <= 32'b0;
                            endcase
                        end else begin
                            unique case ( local_dmem_rmask )
                                4'b0001 : local_data <= { { 24{ dmem_rdata[7] } }, dmem_rdata[7:0] };
                                4'b0010 : local_data <= { { 24{ dmem_rdata[15] } }, dmem_rdata[15:8] };
                                4'b0100 : local_data <= { { 24{ dmem_rdata[23] } }, dmem_rdata[23:16] };
                                4'b1000 : local_data <= { { 24{ dmem_rdata[31] } }, dmem_rdata[31:24] };
                                4'b0011 : local_data <= { { 16{ dmem_rdata[15] } }, dmem_rdata[15:0] };
                                4'b0110 : local_data <= { { 16{ dmem_rdata[23] } }, dmem_rdata[23:8] };
                                4'b1100 : local_data <= { { 16{ dmem_rdata[31] } }, dmem_rdata[31:16] };
                                4'b1111 : local_data <= dmem_rdata;
                                default : local_data <= 32'b0;
                            endcase
                        end
                        rvfi_dmem_rdata <= dmem_rdata;
                    end
                end
                default: ;
            endcase
        end
    end

endmodule : memory_fu