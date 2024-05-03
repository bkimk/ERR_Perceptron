module decode
import rv32i_types::*;
(
    // input   logic               clk,
    // input   logic               rst,
    input   logic               branch,

    input   logic               empty,
    input   if_id_stage_reg_t   if_id_reg,             
    input   logic               re_dis_stall,

    output  logic               deq,
    output  id_ex_stage_reg_t   id_ex_reg_next
);

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    // assign id_ex_reg_next.pc = if_id_reg.pc;
    // assign id_ex_reg_next.pc_next = if_id_reg.pc_next;
    assign id_ex_reg_next.valid = ( if_id_reg.out_inst != '0 ) ? 1'b1 : 1'b0;  
    assign id_ex_reg_next.prediction = if_id_reg.prediction;
    // assign id_ex_reg_next.inst = if_id_reg.out_inst;

    // Splitting up input instruction mem data
    always_comb begin
        id_ex_reg_next.pc = if_id_reg.pc;
        id_ex_reg_next.pc_next = if_id_reg.pc_next;
        id_ex_reg_next.decoded = '0;
        id_ex_reg_next.funct3 = '0;
        id_ex_reg_next.funct7 = '0;
        id_ex_reg_next.opcode = '0;
        id_ex_reg_next.inst = if_id_reg.out_inst;
        rs1 = '0;
        rs2 = '0;
        rd = '0;
        deq = '0;

        if ( !empty && !re_dis_stall && !branch ) begin
            deq = '1;
            id_ex_reg_next.funct3 = if_id_reg.out_inst[14:12];
            id_ex_reg_next.funct7 = if_id_reg.out_inst[31:25];
            id_ex_reg_next.opcode = if_id_reg.out_inst[6:0];
            rs1 = if_id_reg.out_inst[19:15];
            rs2 = if_id_reg.out_inst[24:20];
            rd = if_id_reg.out_inst[11:7];
            id_ex_reg_next.decoded = '1;
        end
    end

    always_comb begin
        // reservation_choice 11 is multiply RS, 00 is add RS
        // Getting Instruction, Control Unit Logic
        unique case ( id_ex_reg_next.opcode )    
            op_b_lui   : begin 
                id_ex_reg_next.mem_rmask = 4'b0000;
                id_ex_reg_next.mem_wmask = 4'b0000;
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;
                id_ex_reg_next.rs1_addr = 5'b00000;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;    
                id_ex_reg_next.reservation_choice = 2'b00;
            end
            op_b_auipc : begin
                id_ex_reg_next.mem_rmask = 4'b0000;
                id_ex_reg_next.mem_wmask = 4'b0000;
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;
                id_ex_reg_next.rs1_addr = 5'b00000;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = 2'b00;     
            end
            op_b_jal : begin
                id_ex_reg_next.mem_rmask = 4'b0000;       
                id_ex_reg_next.mem_wmask = 4'b0000; 
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;       
                id_ex_reg_next.rs1_addr = 5'b00000;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = 2'b00;      
            end
            op_b_jalr : begin
                id_ex_reg_next.mem_rmask = 4'b0000;       
                id_ex_reg_next.mem_wmask = 4'b0000; 
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;        
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = 2'b00;      
            end
            op_b_br : begin
                id_ex_reg_next.mem_rmask = 4'b0000;       
                id_ex_reg_next.mem_wmask = 4'b0000; 
                id_ex_reg_next.RegWrite = 1'b0;
                id_ex_reg_next.MemtoReg = 1'b0;
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = rs2;
                id_ex_reg_next.rd = 5'b00000;
                id_ex_reg_next.reservation_choice = 2'b00;   
            end
            op_b_load : begin
                id_ex_reg_next.mem_rmask = 4'b0000;   
                id_ex_reg_next.mem_wmask = 4'b0000;
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b1;
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = 2'b01;        
            end
            op_b_store : begin
                id_ex_reg_next.mem_rmask = 4'b0000;
                id_ex_reg_next.mem_wmask = 4'b0000;   
                id_ex_reg_next.RegWrite = 1'b0;
                id_ex_reg_next.MemtoReg = 1'b0; 
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = rs2;
                id_ex_reg_next.rd = 5'b00000;
                id_ex_reg_next.reservation_choice = 2'b10;       
            end
            op_b_imm  : begin
                id_ex_reg_next.mem_rmask = 4'b0000;
                id_ex_reg_next.mem_wmask = 4'b0000;
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = 5'b00000;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = 2'b00;
            end
            op_b_reg  : begin
                id_ex_reg_next.mem_rmask = 4'b0000;
                id_ex_reg_next.mem_wmask = 4'b0000;
                id_ex_reg_next.RegWrite = 1'b1;
                id_ex_reg_next.MemtoReg = 1'b0;
                id_ex_reg_next.rs1_addr = rs1;
                id_ex_reg_next.rs2_addr = rs2;
                id_ex_reg_next.rd = rd;
                id_ex_reg_next.reservation_choice = ( if_id_reg.out_inst[31:25] == 7'b0000001 ) ? 2'b11 : 2'b00;
            end
            default  : begin
                id_ex_reg_next.mem_rmask = '0;
                id_ex_reg_next.mem_wmask = '0;
                id_ex_reg_next.RegWrite = 'x;
                id_ex_reg_next.MemtoReg = 'x;
                id_ex_reg_next.rs1_addr = 'x;
                id_ex_reg_next.rs2_addr = 'x;
                id_ex_reg_next.rd = 'x;
                id_ex_reg_next.reservation_choice = 'x;
            end
        endcase

        // IMM GEN
        unique case ( id_ex_reg_next.opcode )  
            op_b_lui    : id_ex_reg_next.imm_gen = {if_id_reg.out_inst[31:12], 12'h000};
            op_b_auipc  : id_ex_reg_next.imm_gen = {if_id_reg.out_inst[31:12], 12'h000} + if_id_reg.pc;
            op_b_jal    : id_ex_reg_next.imm_gen = {{12{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[19:12], if_id_reg.out_inst[20], if_id_reg.out_inst[30:21], 1'b0};
            op_b_jalr   : id_ex_reg_next.imm_gen = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[31:20]}; 
            op_b_br     : id_ex_reg_next.imm_gen = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[7], if_id_reg.out_inst[30:25], if_id_reg.out_inst[11:8], 1'b0};
            op_b_load   : id_ex_reg_next.imm_gen = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[31:20]};
            op_b_store  : id_ex_reg_next.imm_gen = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[31:25], if_id_reg.out_inst[11:7]};
            op_b_imm    : id_ex_reg_next.imm_gen = {{20{if_id_reg.out_inst[31]}}, if_id_reg.out_inst[31:20]};
            default     : id_ex_reg_next.imm_gen = 'x;
        endcase
        id_ex_reg_next.rvfi_sig.valid = '0;
        id_ex_reg_next.rvfi_sig.pc_rdata = if_id_reg.pc;
        id_ex_reg_next.rvfi_sig.pc_wdata = if_id_reg.pc_next;
        id_ex_reg_next.rvfi_sig.inst = if_id_reg.out_inst;
        id_ex_reg_next.rvfi_sig.rs1_addr = id_ex_reg_next.rs1_addr;
        id_ex_reg_next.rvfi_sig.rs2_addr = id_ex_reg_next.rs2_addr;
        id_ex_reg_next.rvfi_sig.rs1_rdata = '0;
        id_ex_reg_next.rvfi_sig.rs2_rdata = '0;
        id_ex_reg_next.rvfi_sig.rd_addr = id_ex_reg_next.rd;
        id_ex_reg_next.rvfi_sig.rd_wdata = '0; //set 0 till cdb
        id_ex_reg_next.rvfi_sig.mem_addr = '0; //set 0 till cdb
        id_ex_reg_next.rvfi_sig.mem_rmask = '0; //set 0 till cdb
        id_ex_reg_next.rvfi_sig.mem_wmask = '0; //set 0 till cdb
        id_ex_reg_next.rvfi_sig.mem_wdata = '0; //set 0 till cdb
        id_ex_reg_next.rvfi_sig.mem_rdata = '0; //set 0 till cdb


    end

endmodule : decode