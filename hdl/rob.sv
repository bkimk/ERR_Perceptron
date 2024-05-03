module rob
import rv32i_types::*;

(
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       enq,
    input   logic   [4:0]               archReg,
    input   logic   [PR_WIDTH-1:0]      pReg,
    input   cdb_t                       cdb,
    input   RVFI                        in_rvfi,
    input   logic   [31:0]              br_imm,
    input   logic                       st,
    input   logic                       jmp,
    input   logic                       is_branch,
    input   logic                       prediction,
    input   logic   [31:0]              pc,

    output  logic   [ROB_WIDTH-1:0]     robNum,         // Next Empty Rob Num
    output  ROBEntry_t                  robEntry,       // ROB Entry that is being removed
    output  logic                       robHasSpace,    // Stall for when ROB is full
    output  logic                       commit,         // commit
    output  logic                       branch,         // Branch is combinational
    output  logic                       committing_br,  // Commited inst is branch
    output  logic   [31:0]              comitting_br_pc,    // pc of branch instruction being committed
    output  logic   [31:0]              gshare_br_pc,   // False Prediction
    output  logic                       isStore,        // Is top of queue a store
    output  logic   [ROB_WIDTH-1:0]     storeRobIdx     // ROB idx of store at top of queue
    
);


    // Head and Tail Declaration (Use logic to make it synthesizable)
    logic   [ROB_WIDTH-1:0]   head, tail;

    // Local Logic Variable
    logic   [ROB_WIDTH:0] rob_count;

    // ROB 
    ROBEntry_t ROB [ROB_NUM];

    // prediction counters
    logic [19:0] total_branches;
    logic [19:0] true_positives;
    logic [19:0] true_negatives;
    logic [19:0] false_positives;
    logic [19:0] false_negatives;

    // prediction accuracy
    always_ff @ (posedge clk) begin
        if (rst) begin
            total_branches <= '0;
            true_positives <= '0;
            true_negatives <= '0;
            false_positives <= '0;
            false_negatives <= '0;
        end
        else begin
            if (ROB[head].rob_valid && ROB[head].rvfi_sig.inst[6:0] == op_b_br) begin
                total_branches <= total_branches + 1'b1;
                if ((ROB[head].br && ROB[head].prediction)) begin
                    true_positives <= true_positives + 1'b1;
                end
                else if ((!ROB[head].br && !ROB[head].prediction)) begin
                    true_negatives <= true_negatives + 1'b1;
                end
                else if ((!ROB[head].br && ROB[head].prediction)) begin
                    false_positives <= false_positives + 1'b1;
                end
                else if ((ROB[head].br && !ROB[head].prediction)) begin
                    false_negatives <= false_negatives + 1'b1;
                end
            end
        end
    end
    
    // Setting branch (mispredict) signal
    always_comb begin
        robEntry = '0;
        branch = '0;
        gshare_br_pc = '0;
        if (ROB[head].rob_valid)
            robEntry = ROB[head];
        // Missed Branch
        if (ROB[head].rob_valid && !ROB[head].prediction && ROB[head].br) begin
            branch = 1'b1;
            gshare_br_pc = ROB[head].br_imm;
        end
        // False Prediction
        else if (ROB[head].rob_valid && ROB[head].prediction && !ROB[head].br) begin
            branch = 1'b1;
            gshare_br_pc = ROB[head].pc + 3'b100;
        end
    end

    // Setting of ROB entries + Moving Head/Tail
    always_ff @(posedge clk) begin 
        if (rst || branch) begin
            head <= '0;
            tail <= '0;
            // if (ROB[head].rob_valid == 1'b1) commit <= 1'b1;
            // else commit <= 1'b0;
            rob_count <= '0;
            // stall <= '0;
            for (int i = 0; i < ROB_NUM; i++) begin
                ROB[i].rob_valid <= '0;
                ROB[i].archReg <= '0;
                ROB[i].pReg <= '0;
                ROB[i].rvfi_sig <= '0;
                ROB[i].idx <= 6'(unsigned'(i));
                ROB[i].br <= '0;
                ROB[i].br_imm <= '0;
                ROB[i].st <= '0;
                ROB[i].jmp <= '0;
                ROB[i].prediction <= '0;
                ROB[i].pc <= '0;
                ROB[i].is_branch <= '0;
            end
        end
        else begin
            // Enqueue
            if (enq && robHasSpace) begin            
                ROB[tail].archReg <= archReg;
                ROB[tail].pReg <= pReg;
                ROB[tail].rvfi_sig <= in_rvfi;
                ROB[tail].br <='0;             
                ROB[tail].br_imm <=  br_imm;
                ROB[tail].st <= st;
                ROB[tail].jmp <= jmp;
                ROB[tail].prediction <= prediction;
                ROB[tail].pc <= pc;
                ROB[tail].is_branch <= is_branch;

                if (tail == ROB_IDX_LOGIC -1'b1 ) tail <= '0; //I change to bit 0
                else tail <= tail + 1'b1;
            end
            // dequeuing
            if (ROB[head].rob_valid) begin   
                ROB[head].rob_valid <= '0;
                ROB[head].archReg <= '0;
                ROB[head].pReg <= '0;
                ROB[head].rvfi_sig <= '0;
                ROB[head].br <= '0;
                ROB[head].br_imm <= '0;
                ROB[head].st <= '0;
                ROB[head].is_branch <= '0;
                ROB[head].jmp <= '0;
                ROB[head].prediction <= '0;
                ROB[head].pc <= '0;

                if (head == ROB_IDX_LOGIC-1'b1) head <= '0; // I change to bit 0
                else head <= head + 1'b1;
            end

            if (enq && robHasSpace && ROB[head].rob_valid == 1'b1 ) begin
                rob_count <= rob_count; 
            end
            else if (enq && robHasSpace) begin
                rob_count <= rob_count + 1'b1;
            end
            else if (ROB[head].rob_valid == 1'b1) begin
                rob_count <= rob_count - 1'b1;
            end 
            // enqueuing but full
            // if (enq && robHasSpace == 1'b0) begin     
            //     stall <= 1'b1;
            // end
            // empty
            // if (robHasSpace == 1'b1) begin
            //     stall <= 1'b0;
            // end
            // Always Check Add CDB for Data value
            for (int unsigned i = 0; i < ROB_NUM; i++) begin
                if ( cdb.cdb_valid == 1'b1 && cdb.rob == ROB[i].idx ) begin
                    ROB[i].rob_valid <= 1'b1;
                    ROB[i].br <= (cdb.is_branch);           // MSB for branch & valid branch isnt
                    if (cdb.is_jalr) ROB[i].br_imm <= ROB[i].br_imm + cdb.ps1_rdata;
                    ROB[i].rvfi_sig.valid <= 1'b1;
                    ROB[i].rvfi_sig.rd_wdata <= cdb.data;
                    ROB[i].rvfi_sig.rs1_rdata <= cdb.ps1_rdata;
                    ROB[i].rvfi_sig.rs2_rdata <= cdb.ps2_rdata;
                    ROB[i].rvfi_sig.mem_addr <= cdb.mem_addr;
                    ROB[i].rvfi_sig.mem_wdata <= cdb.mem_wdata;
                    ROB[i].rvfi_sig.mem_rdata <= cdb.mem_rdata;
                    ROB[i].rvfi_sig.mem_rmask <= cdb.mem_rmask;
                    ROB[i].rvfi_sig.mem_wmask <= cdb.mem_wmask;
                end
            end
            // // Always Check Mul CDB for Data value
            // for (int i = 0; i < ROB_WIDTH; i++) begin
            //     if (mul_cdb.rob == ROB[i].idx) begin
            //         ROB[i].data <= mul_cdb.data;
            //         ROB[i].rob_valid <= 1'b1;
            //     end
            // end
            // // Always Check LS CDB for Data value
            // for (int i = 0; i < ROB_WIDTH; i++) begin
            //     if (mem_cdb.rob == ROB[i].idx) begin
            //         ROB[i].data <= mem_cdb.data;
            //         ROB[i].rob_valid <= 1'b1;
            //     end
            // end
        end
    end

    // Commit
    always_comb begin
        commit = '0;
        committing_br = '0;
        comitting_br_pc = '0;
        if (enq && robHasSpace && ROB[head].rob_valid == 1'b1 ) begin
            commit = 1'b1;
            if (ROB[head].is_branch) begin
                committing_br = 1'b1;
                comitting_br_pc = ROB[head].pc;
            end
            else committing_br = 1'b0;
        end
        else if (enq && robHasSpace) begin
            commit = 1'b0;
        end
        else if (ROB[head].rob_valid == 1'b1) begin
            commit = 1'b1;
            if (ROB[head].is_branch) begin
                committing_br = 1'b1;
                comitting_br_pc = ROB[head].pc;
            end
            else committing_br = 1'b0;
        end 
    end

    always_comb begin
        // Determine if ROB is Full + set Curr Rob Number
        if ( rob_count == ROB_NUM_LOGIC ) begin    // IF head == tail and pc holds all zeros
            robHasSpace = 1'b0;
            robNum = 'x;
        end
        else begin
            robHasSpace = 1'b1;
            robNum = tail;
        end
    end

    always_comb begin
        isStore = '0;
        storeRobIdx = '0;
        if (ROB[head].st) begin
            isStore = 1'b1;
            storeRobIdx = ROB[head].idx;
        end
    end

endmodule 