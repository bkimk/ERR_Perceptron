module reserveAM
import rv32i_types::*;
(
    input   logic                           clk,
    input   logic                           rst,      
    input   logic   [3:0]                   operation,          // From Operation Bus
    input   logic   [ROB_WIDTH-1:0]         ROBnum,             // ROB Num
    input   logic   [PR_WIDTH-1:0]          prs1,               // Physical Register 1
    input   logic   [PR_WIDTH-1:0]          prs2,               // Physical Register 2
    input   logic   [PR_WIDTH-1:0]          pDest,              // Physical Destination Register
    input   logic   [4:0]                   archDest,           // Architectural Destination Register
    input   logic                           prs1Ready,          // Rs1 From Physical Register File -> Ready
    input   logic                           prs2Ready,          // Rs2 From Physical Register File -> Ready
    input   logic                           add_we,             // Signal For Writing to Add RS
    input   logic                           mul_we,             // Signal For Writing to Mul RS    
    input   logic   [31:0]                  imm_gen,            // imm_gen
    input   logic   [6:0]                   opcode,             // opcode
    input   cdb_t                           cdb,                // cdb  
    input   logic                           branch,             // branch
    
    input   logic                           addFUReady,         // Add Functional Unit Ready
    input   logic                           mulFUReady,         // Multiply Functional Unit Ready

    output  logic                           add_full,           // Stall for Add Reservation Station
    output  logic                           mul_full,           // Stall for Mul Reservation Station
    output  ReservationEntry_t              addFU,              // ReservationEntry Struct to Add FU
    output  ReservationEntry_t              mulFU              // ReservationEntry Struct to Mul FU
    
);

    // Logic
    int                          addEmptyIdx;                // Empty Index for Add Reservation Station
    int                          mulEmptyIdx;                // Empty Index for Mul Reservation Station 
    int                          add_empty_idx;  
    int                          mul_empty_idx; 

    logic                       flag1;
    logic                       flag2;
    logic                       transparency_rs1;
    logic                       transparency_rs2;

    // Reservation Station Entry for ALU and MUL
    ReservationEntry_t addEntry [RS_NUM];
    ReservationEntry_t mulEntry [RS_NUM];

    // Setting Reservation Station Values
    always_ff @ (posedge clk) begin
        if (rst || branch) begin
            // Initialize addEntry + mulEntry
            addFU <= '0;
            mulFU <= '0;
            for (int i = 0; i < RS_NUM; i++) begin
                // AddEntry
                addEntry[i].valid <= '0;
                addEntry[i].Op <= '0;
                addEntry[i].prs1 <= '0;
                addEntry[i].prs2 <= '0;
                addEntry[i].prs1Ready <= '0;
                addEntry[i].prs2Ready <= '0;
                addEntry[i].pDest <= '0;
                addEntry[i].archDest <= '0;
                addEntry[i].imm_gen <= '0;
                addEntry[i].opcode <= '0;
                addEntry[i].Wrob <= '0;
                // MulEntry
                mulEntry[i].valid <= '0;
                mulEntry[i].Op <= '0;
                mulEntry[i].prs1 <= '0;
                mulEntry[i].prs2 <= '0;
                mulEntry[i].prs1Ready <= '0;
                mulEntry[i].prs2Ready <= '0;
                mulEntry[i].pDest <= '0;
                mulEntry[i].archDest <= '0;
                mulEntry[i].imm_gen <= '0;
                mulEntry[i].opcode <= '0;
                mulEntry[i].Wrob <= '0;
            end

        end else begin
            // Adding Element to Add Reservation Station
            if (add_we && !add_full) begin
                addEntry[add_empty_idx].valid <= 1'b1;
                addEntry[add_empty_idx].Op <= operation;
                addEntry[add_empty_idx].prs1 <= prs1;
                addEntry[add_empty_idx].prs2 <= prs2;
                if (transparency_rs1) addEntry[add_empty_idx].prs1Ready <= 1'b1;
                else addEntry[add_empty_idx].prs1Ready <= prs1Ready;
                if (transparency_rs2) addEntry[add_empty_idx].prs2Ready <= 1'b1;
                else addEntry[add_empty_idx].prs2Ready <= prs2Ready;
                addEntry[add_empty_idx].pDest <= pDest;
                addEntry[add_empty_idx].archDest <= archDest;
                addEntry[add_empty_idx].imm_gen <= imm_gen;
                addEntry[add_empty_idx].opcode <= opcode;
                addEntry[add_empty_idx].Wrob <= ROBnum;

            end
            // Adding Element to Multiply Reservation Station
            else if (mul_we && !mul_full) begin
                mulEntry[mul_empty_idx].valid <= 1'b1;
                mulEntry[mul_empty_idx].Op <= operation;
                mulEntry[mul_empty_idx].prs1 <= prs1;
                mulEntry[mul_empty_idx].prs2 <= prs2;
                if (transparency_rs1) mulEntry[mul_empty_idx].prs1Ready <= 1'b1;
                else mulEntry[mul_empty_idx].prs1Ready <= prs1Ready;
                if (transparency_rs2) mulEntry[mul_empty_idx].prs2Ready <= 1'b1;
                else mulEntry[mul_empty_idx].prs2Ready <= prs2Ready;
                mulEntry[mul_empty_idx].pDest <= pDest;
                mulEntry[mul_empty_idx].archDest <= archDest;
                mulEntry[mul_empty_idx].imm_gen <= imm_gen;
                mulEntry[mul_empty_idx].opcode <= opcode;
                mulEntry[mul_empty_idx].Wrob <= ROBnum;

            end
            // else begin
            //     addFU <= '0;
            //     mulFU <= '0;
            // end
            // Constantly Checking Common Data Bus for matching Physical Reg value
            for (int i = 0; i < RS_NUM; i++) begin
                // Constantly Checking Common Data Bus for matching Physical Reg value
                if (cdb.arch_reg != '0 && cdb.cdb_valid && cdb.phys_reg == addEntry[i].prs1 && addEntry[i].prs1Ready == 1'b0) begin      
                    addEntry[i].prs1Ready <= 1'b1;
                end
                if (cdb.arch_reg != '0 && cdb.cdb_valid && cdb.phys_reg == addEntry[i].prs2 && addEntry[i].prs2Ready == 1'b0) begin
                    addEntry[i].prs2Ready <= 1'b1;
                end 
                if (cdb.arch_reg != '0 && cdb.cdb_valid && cdb.phys_reg == mulEntry[i].prs1 && mulEntry[i].prs1Ready == 1'b0) begin
                    mulEntry[i].prs1Ready <= 1'b1;
                end
                if (cdb.arch_reg != '0 && cdb.cdb_valid && cdb.phys_reg == mulEntry[i].prs2 && mulEntry[i].prs2Ready == 1'b0) begin
                    mulEntry[i].prs2Ready <= 1'b1;
                end
            end
            for (int i = 0; i < RS_NUM; i++) begin
                // Checking if Ready to send Reservation Struct Entry to Functional Unit (Add)
                if (addEntry[i].prs1Ready && addEntry[i].prs2Ready && addFUReady) begin 
                    addFU <= addEntry[i];
                    addEntry[i] <= '0;
                    break;
                end
                if ( i == RS_NUM-1 ) begin
                    addFU <= '0;
                end
            end 
            for (int i = 0; i < RS_NUM; i++) begin
                // Checking if Ready to send Reservation Struct Entry to Functional Unit (Mul)
                if (mulEntry[i].prs1Ready && mulEntry[i].prs2Ready && mulFUReady) begin
                    mulFU <= mulEntry[i];
                    mulEntry[i] <= '0;
                    break;
                end
                if ( i == RS_NUM-1 ) begin
                    mulFU <= '0;
                end
            end
        end
    end

    // Getting Empty Index
    always_comb begin
        add_empty_idx = RS_NUM;
        mul_empty_idx = RS_NUM;
        flag1 = 1'b0;
        flag2 = 1'b0;
        add_full = 1'b0;
        mul_full = 1'b0;
        for (int i = 0; i < RS_NUM; i++) begin
            if (addEntry[i].valid == 1'b0) begin                // If Empty Index found, set emptyIndex + no longer full
                add_empty_idx = i;
                flag1 = 1'b1;
            end
            if (mulEntry[i].valid == 1'b0) begin                // If Empty Index found, set emptyIndex + no longer full
                mul_empty_idx = i;
                flag2 = 1'b1;
            end
            if (flag1 == 1'b0 && flag2 == 1'b0) begin
                break;
            end else begin
                if ( i == RS_NUM-1 ) begin
                    if (flag1 == 0) add_full = 1'b1;
                    if (flag2 == 0) mul_full = 1'b1;
                end
            end
        end
    end

    // Transparency with CDB
    always_comb begin
        transparency_rs1 = 1'b0;
        transparency_rs2 = 1'b0;
        if (cdb.arch_reg != '0 && cdb.phys_reg == prs1 && prs1Ready == 1'b0) begin      
            transparency_rs1 = 1'b1;
        end
        if (cdb.arch_reg != '0 && cdb.phys_reg == prs2 && prs2Ready == 1'b0) begin
            transparency_rs2 = 1'b1;
        end 
    end

endmodule : reserveAM












/*

module reserveAM
import rv32i_types::*;
(
    input   logic                           clk,
    input   logic                           rst,      
    input   logic   [3:0]                   operation,          // From Operation Bus
    input   logic   [ROB_WIDTH-1:0]         ROBnum,             // ROB Num
    input   logic   [PR_WIDTH-1:0]          prs1,               // Physical Register 1
    input   logic   [PR_WIDTH-1:0]          prs2,               // Physical Register 2
    input   logic   [PR_WIDTH-1:0]          pDest,              // Physical Destination Register
    input   logic   [4:0]                   archDest,           // Architectural Destination Register
    input   logic                           prs1Ready,          // Rs1 From Physical Register File -> Ready
    input   logic                           prs2Ready,          // Rs2 From Physical Register File -> Ready
    input   logic                           add_we,             // Signal For Writing to Add RS
    input   logic                           mul_we,             // Signal For Writing to Mul RS    
    input   logic                           imm_gen,            // imm_gen
    input   logic   [6:0]                   opcode,             // opcode
    input   cdb_t                           cdb,                // cdb  
    
    input   logic                           addFUReady,         // Add Functional Unit Ready
    input   logic                           mulFUReady,         // Multiply Functional Unit Ready

    output  logic                           addStall,           // Stall for Add Reservation Station
    output  logic                           mulStall,           // Stall for Mul Reservation Station
    output  ReservationEntry_t              addFU,              // ReservationEntry Struct to Add FU
    output  ReservationEntry_t              mulFU              // ReservationEntry Struct to Mul FU
    
);

    // Logic
    int                          addEmptyIdx;                // Empty Index for Add Reservation Station
    int                          mulEmptyIdx;                // Empty Index for Mul Reservation Station 
    logic   [RS_WIDTH-1:0]       addIsEmpty;  
    logic   [RS_WIDTH-1:0]       mulIsEmpty;    

    // Reservation Station Entry for Add + Multiply
    ReservationEntry_t addEntry [RS_NUM];
    ReservationEntry_t mulEntry [RS_NUM];

    // Setting Reservation Station Values
    always_ff @ (posedge clk) begin
        if ( rst ) begin
            // Initialize addEntry + mulEntry
            for (int i = 0; i < RS_NUM; i++) begin
                // AddEntry
                addEntry[i].valid <= '0;
                addEntry[i].Op <= '0;
                addEntry[i].prs1 <= '0;
                addEntry[i].prs2 <= '0;
                addEntry[i].prs1Ready <= '0;
                addEntry[i].prs2Ready <= '0;
                addEntry[i].pDest <= '0;
                addEntry[i].archDest <= '0;
                addEntry[i].imm_gen <= '0;
                addEntry[i].opcode <= '0;
                addEntry[i].Wrob <= '0;
                // MulEntry
                mulEntry[i].valid <= '0;
                mulEntry[i].Op <= '0;
                mulEntry[i].prs1 <= '0;
                mulEntry[i].prs2 <= '0;
                mulEntry[i].prs1Ready <= '0;
                mulEntry[i].prs2Ready <= '0;
                mulEntry[i].pDest <= '0;
                mulEntry[i].archDest <= '0;
                mulEntry[i].imm_gen <= '0;
                mulEntry[i].opcode <= '0;
                mulEntry[i].Wrob <= '0;
            end
            addIsEmpty <= '0;
            mulIsEmpty <= '0;
            mulStall <= 1'b0;
            addStall <= 1'b0;
        end
        else begin
            // Adding Element to Add Reservation Station
            if (add_we && addIsEmpty != RS_NUM) begin
                addEntry[addIsEmpty].valid <= 1'b1;
                addEntry[addIsEmpty].Op <= operation;
                addEntry[addIsEmpty].prs1 <= prs1;
                addEntry[addIsEmpty].prs2 <= prs2;
                addEntry[addIsEmpty].prs1Ready <= prs1Ready;
                addEntry[addIsEmpty].prs2Ready <= prs2Ready;
                addEntry[addIsEmpty].pDest <= pDest;
                addEntry[addIsEmpty].archDest <= archDest;
                addEntry[addIsEmpty].imm_gen <= imm_gen;
                addEntry[addIsEmpty].opcode <= opcode;
                addEntry[addIsEmpty].Wrob <= ROBnum;
                addIsEmpty <= addIsEmpty + 1'b1;
                mulStall <= 1'b0;
                addStall <= 1'b0;
            end
            // Adding Element to Multiply Reservation Station
            else if (mul_we && mulIsEmpty != RS_NUM) begin
                mulEntry[mulIsEmpty].valid <= 1'b1;
                mulEntry[mulIsEmpty].Op <= operation;
                mulEntry[mulIsEmpty].prs1 <= prs1;
                mulEntry[mulIsEmpty].prs2 <= prs2;
                mulEntry[mulIsEmpty].prs1Ready <= prs1Ready;
                mulEntry[mulIsEmpty].prs2Ready <= prs2Ready;
                mulEntry[mulIsEmpty].pDest <= pDest;
                mulEntry[mulIsEmpty].archDest <= archDest;
                mulEntry[mulIsEmpty].imm_gen <= imm_gen;
                mulEntry[mulIsEmpty].opcode <= opcode;
                mulEntry[mulIsEmpty].Wrob <= ROBnum;
                mulIsEmpty <= mulIsEmpty + 1'b1;
                mulStall <= 1'b0;
                addStall <= 1'b0;
            end
            else begin
                addFU <= '0;
                mulStall <= 1'b0;
                addStall <= 1'b0;
            end
            for (int i = 0; i < RS_NUM; i++) begin
                // Constantly Checking Common Data Bus for matching Physical Reg value
                if (cdb.arch_reg != '0 && cdb.phys_reg == addEntry[i].prs1 && addEntry[i].prs1Ready == 1'b0) begin      
                    addEntry[i].prs1Ready <= 1'b1;
                end
                if (cdb.arch_reg != '0 && cdb.phys_reg == addEntry[i].prs2 && addEntry[i].prs2Ready == 1'b0) begin
                    addEntry[i].prs2Ready <= 1'b1;
                end 
                if (cdb.arch_reg != '0 && cdb.phys_reg == mulEntry[i].prs1 && mulEntry[i].prs1Ready == 1'b0) begin
                    mulEntry[i].prs1Ready <= 1'b1;
                end
                if (cdb.arch_reg != '0 && cdb.phys_reg == mulEntry[i].prs2 && mulEntry[i].prs2Ready == 1'b0) begin
                    mulEntry[i].prs2Ready <= 1'b1;
                end
                // Checking if Ready to send Reservation Struct Entry to Functional Unit (Add)
                if (addIsEmpty == RS_NUM) begin
                    addStall <= 1'b1;
                end
                else if (addEntry[i].prs1Ready && addEntry[i].prs2Ready && addFUReady) begin 
                    
                    addStall <= 1'b0;
                    addFU <= addEntry[i];
                    addEntry[i] <= '0;
                    addIsEmpty <= addIsEmpty - 1'b1;
                    for (int j = i+1; j < RS_NUM-1; j++) begin
                        if (j == addIsEmpty && add_we && addIsEmpty != RS_NUM) continue;
                        addEntry[j] <= addEntry[j+1];
                    end
                end
                else if 
                // Checking if Ready to send Reservation Struct Entry to Functional Unit (Mul)
                if (mulIsEmpty == RS_NUM) begin
                    mulStall <= 1'b1;
                end
                else if (mulEntry[i].prs1Ready && mulEntry[i].prs2Ready && mulFUReady) begin
                    mulStall <= 1'b0;  
                    mulFU <= mulEntry[i];
                    mulEntry[i] <= '0;
                    mulIsEmpty <= mulIsEmpty - 1'b1;
                    for (int j = i+1; j < RS_NUM-1; j++) begin
                        mulEntry[j] <= mulEntry[j+1];
                    end
                end
            end
        end
    end

    // Getting Empty Index
    logic flag1;
    logic flag2;
    always_comb begin
        addEmptyIdx = 0;
        mulEmptyIdx = 0;
        flag1 = 0;
        flag2 = 0;
        for (int i = 0; i < RS_NUM; i++) begin
            if (addEntry[i].valid == 1'b0) begin                // If Empty Index found, set emptyIndex + no longer full
                addEmptyIdx = i;
                flag1 = 1;
            end
            if (mulEntry[i].valid == 1'b0) begin                // If Empty Index found, set emptyIndex + no longer full
                mulEmptyIdx = i;
                flag2 = 1;
            end
            if ()
        end
    end
    


endmodule : reserveAM
*/