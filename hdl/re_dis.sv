module re_dis
import rv32i_types::*;

(
    input       logic                   clk,
    input       logic                   rst,
    input       id_ex_stage_reg_t       id_rename_dispatch,

    output      logic   [4:0]           arch_rs1,
    output      logic   [4:0]           arch_rs2,
    output      logic                   free_deq,
    input       logic                   free_empty,      
    input       logic                   AddStall,
    input       logic                   MulStall,
    input       logic                   RobStall,
    input       logic                   LSStall, 
    input       logic   [PR_WIDTH-1:0]  free_rd,
    input       logic   [PR_WIDTH-1:0]  phys_rs1,
    input       logic   [PR_WIDTH-1:0]  phys_rs2,
    input       logic                   ps1_valid,
    input       logic                   ps2_valid,
    input       logic   [ROB_WIDTH-1:0] rob_idx,
    input       logic   [31:0]          imm_gen, 
    input       logic   [6:0]           opcode, 
    input       logic                   branch,
    input       logic                   prediction,
    input       logic   [31:0]          pc,

    // dispatch to RAT, ROB, RS
    output      logic                   rat_reg_we,
    output      logic   [PR_WIDTH-1:0]  phys_rd,
    output      logic   [4:0]           arch_rd,
    output      logic                   rob_reg_we,   
    output      ROBEntry_t              rob_entry,
    output      logic                   add_reg_we,
    output      logic                   mul_reg_we,
    output      logic                   ls_reg_we, 
    output      ReservationEntry_t      res_entry,
    output      logic                   re_dis_stall
);

logic               check;
id_ex_stage_reg_t   id_rename_hold;
id_ex_stage_reg_t   id_rename_out;
// Only reason to latch is bc decode could change its output while waiting for a not stall

always_ff @( posedge clk) begin
    if (rst) begin
        id_rename_hold <= '0;
        check <= '0;
    end
    if (id_rename_dispatch.decoded) begin
        if (re_dis_stall) begin
            if (!check) begin
                id_rename_hold <= id_rename_dispatch;
                check <= '1;
            end
        end
        else begin
            id_rename_hold <= '0;
            check <= '0;
        end
    end else begin
        id_rename_hold <= '0;
        check <= '0;
    end
end

always_comb begin

    if (check) begin
        id_rename_out = id_rename_hold;
    end else begin
        id_rename_out = id_rename_dispatch;
    end
    arch_rs1 = id_rename_out.rs1_addr;
    arch_rs2 = id_rename_out.rs2_addr;
    re_dis_stall = '0;
    free_deq = '0;
    res_entry = '0;
    rob_reg_we = '0;
    add_reg_we = '0;
    mul_reg_we = '0;
    ls_reg_we = '0;
    rob_entry = '0;
    rat_reg_we = '0;
    phys_rd = '0;
    arch_rd = '0;
    rob_entry.prediction = prediction;
    rob_entry.pc = pc;
    rob_entry.is_branch = '0;
    
    if (id_rename_out.decoded && !branch) begin 
        phys_rd = free_rd;
        arch_rd = id_rename_out.rd;
        rob_entry.rob_valid = '1;
        rob_entry.idx = rob_idx;
        rob_entry.archReg = id_rename_out.rd;
        rob_entry.pReg = free_rd; 
        res_entry.pDest = free_rd;
        rob_entry.st = '0;
        rob_entry.br = '0;
        rob_entry.br_imm = '0;
        res_entry.prs1 = phys_rs1;
        res_entry.prs2 = phys_rs2;
        if (id_rename_out.rs1_addr != '0) res_entry.prs1Ready = ps1_valid;
        else res_entry.prs1Ready = '1;
        if (id_rename_out.rs2_addr != '0) res_entry.prs2Ready = ps2_valid;
        else res_entry.prs2Ready = '1;
        rob_entry.jmp = '0;

        unique case (id_rename_out.reservation_choice)
            2'b00: begin //arith
                add_reg_we = '1;
                if ( id_rename_out.opcode == op_b_imm ) begin
                    unique case ( id_rename_out.funct3 )
                    slt     :                           // for slti
                        begin
                            res_entry.Op[3] = '0;
                            res_entry.Op[2:0] = blt;
                        end
                    sltu    :                          // for sltui
                        begin
                            res_entry.Op[3] = '0;
                            res_entry.Op[2:0] = bltu;
                        end
                    sr      :
                        begin
                            res_entry.Op[3] = '1;
                            res_entry.Op[2:0] = (id_rename_out.inst[30]) ? alu_sra : alu_srl;
                        end
                    default :
                        begin
                            res_entry.Op[3] = '1;
                            res_entry.Op[2:0] = id_rename_out.funct3;
                        end
                    endcase
                end else if ( id_rename_out.opcode == op_b_reg ) begin
                    unique case ( id_rename_out.funct3 )
                    add     : 
                        begin
                            res_entry.Op[3] = '1;
                            res_entry.Op[2:0] = (id_rename_out.inst[30]) ? alu_sub : alu_add;
                        end
                    slt     :
                        begin
                            res_entry.Op[3] = '0;
                            res_entry.Op[2:0] = blt;
                        end
                    sltu    : 
                        begin
                            res_entry.Op[3] = '0;
                            res_entry.Op[2:0] = bltu;
                        end
                    sr      :
                        begin
                            res_entry.Op[3] = '1;
                            res_entry.Op[2:0] = (id_rename_out.inst[30]) ? alu_sra : alu_srl;
                        end
                    default :
                        begin
                            res_entry.Op[3] = '1;
                            res_entry.Op[2:0] = id_rename_out.funct3;
                        end
                    endcase
                end else if ( id_rename_out.opcode inside {op_b_lui, op_b_auipc} ) begin
                    res_entry.Op[3] = '1;
                    res_entry.Op[2:0] = alu_add;
                end else if (id_rename_out.opcode inside {op_b_br}) begin
                    rob_entry.br_imm = id_rename_out.pc + imm_gen;
                    rob_entry.is_branch = 1'b1;
                    rob_entry.br = '0;
                    res_entry.Op[3] = '0;
                    res_entry.Op[2:0] = id_rename_out.funct3;
                    rob_entry.pReg = '0;
                    res_entry.pDest = '0;
                end else if (id_rename_out.opcode inside {op_b_jal}) begin
                    rob_entry.jmp = '1;
                    rob_entry.br_imm = id_rename_out.pc + imm_gen;
                    rob_entry.br = '1;
                    res_entry.Op[3] = '1;
                    res_entry.prs1 = '0;
                    res_entry.prs2 = '0;
                    res_entry.prs1Ready = '1;
                    res_entry.prs2Ready = '1;
                    res_entry.Op[2:0] = alu_add;
                end else if (id_rename_out.opcode inside {op_b_jalr}) begin
                    rob_entry.jmp = '1;

                    rob_entry.br_imm = imm_gen;
                    rob_entry.br = '1;
                    res_entry.Op[3] = '1;
                    res_entry.prs2 = '0;
                    res_entry.prs2Ready = '1;
                    res_entry.Op[2:0] = alu_add;
                end else begin
                    res_entry.Op[3] = '1;
                    res_entry.Op[2:0] = id_rename_out.funct3;
                end
                // change what stall depends on
                re_dis_stall = free_empty || AddStall || !RobStall;
                if (id_rename_out.opcode == op_b_imm && id_rename_out.funct3 == sr) begin
                    res_entry.imm_gen = {27'b0, imm_gen[4:0]};
                end else if ( id_rename_out.opcode inside {op_b_jalr, op_b_jal}) begin
                    res_entry.imm_gen = id_rename_out.pc + 3'b100;
                end else if ( id_rename_out.opcode inside {op_b_br} ) begin
                    res_entry.imm_gen = id_rename_out.pc + imm_gen;
                end else begin
                    res_entry.imm_gen = imm_gen;
                end
            end
            2'b01: begin //load
                ls_reg_we = '1;
                res_entry.Op[3] = '1;
                res_entry.Op[2:0] = id_rename_out.funct3;
                re_dis_stall = free_empty || LSStall || !RobStall;
                res_entry.imm_gen = imm_gen;
            end
            2'b10: begin //store
                ls_reg_we = '1;
                res_entry.Op[3] = '1;
                res_entry.Op[2:0] = id_rename_out.funct3;
                re_dis_stall = free_empty || LSStall || !RobStall;
                res_entry.imm_gen = imm_gen;
                rob_entry.st = '1;
            end
            2'b11: begin //mul
                mul_reg_we = '1;
                res_entry.Op[3] = '1;
                res_entry.Op[2:0] = id_rename_out.funct3;
                re_dis_stall = free_empty || MulStall || !RobStall;
                res_entry.imm_gen = imm_gen;
            end
            default: begin
                res_entry.Op = '0;
                re_dis_stall = '0;
                res_entry.imm_gen = '0;
            end
        endcase
        if (re_dis_stall) begin
            add_reg_we = '0;
            mul_reg_we = '0;
            ls_reg_we = '0;
        end else if (arch_rd == 5'b0) begin
            rob_reg_we = '1;
            rat_reg_we = '0;
            free_deq = '0;
            phys_rd = '0;
            rob_entry.pReg = '0;
            res_entry.pDest = '0;
        end else begin
            rob_reg_we = '1;
            rat_reg_we = '1;
            free_deq = '1;
        end
        res_entry.valid = '1;
        
        res_entry.Wrob = rob_idx;
        res_entry.archDest = id_rename_out.rd;
        res_entry.opcode = opcode;
    end

    rob_entry.rvfi_sig = id_rename_out.rvfi_sig;    // Pass RVFI signals through the stage
end

endmodule
