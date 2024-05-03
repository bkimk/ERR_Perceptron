module reserveLS2
import rv32i_types::*;
(
    input   logic                           clk,
    input   logic                           rst,
    input   logic                           operation,          // 0 = load; 1 = store
    input   logic   [31:0]                  offset,             // offset             
    input   logic   [ROB_WIDTH-1:0]         ROBnum,             // ROB Num
    input   logic   [PR_WIDTH-1:0]          prs1,               // Physical Register 1
    input   logic   [PR_WIDTH-1:0]          prs2,               // Physical Register 2
    input   logic   [PR_WIDTH-1:0]          pDest,              // Physical Destination Register
    input   logic   [4:0]                   archDest,           // Architectural Destination Register
    input   logic                           prs1Ready,          // Physical Register 1 Ready Signal
    input   logic                           prs2Ready,          // Physical Register 2 Ready Signal
    input   logic                           ls_we,              // Signal For Writing to Load/Store Station
    input   cdb_t                           ls_res_input_cdb,   // CDB struct   
    //input   logic                           commit,             // commit signal from ROB
    //input   logic   [ROB_WIDTH-1:0]         commit_rob_idx,     // After commit, need phys_reg to dequeue store
    input   logic                           memory_fu_ready, 
    input   logic   [2:0]                   funct3, 
    input   logic                           branch,             // branch
    input   logic                           isStore,
    input   logic   [ROB_WIDTH-1:0]         storeRobIdx,

    output  logic                           loadStoreStall,     // Stall for load Reservation Station
    output  loadStoreReservationEntry_t     loadstoreFU         // Reservation StatiopStall for load/store Reservation Station
    
);

    // Head and Tail Declaration
    logic   [RS_WIDTH:0]   head, tail;

    // Flag for Checking Status of Reservation Station + Stall Signal
    logic                       flag1;

    // Load Store Reservation Station 
    loadStoreReservationEntry_t lsEntry [RS_NUM];

    // Setting of Load/Store Station entries + Moving Head/Tail
    always_ff @(posedge clk) begin 
        if (rst || branch) begin
            head <= '0;
            tail <= '0;
            loadstoreFU <= '0;  // Need to set loadstoreFU to 0 when branching
            for (int i = 0; i < RS_NUM; i++) begin
                // Populate Station on RST
                lsEntry[i].ls_valid <= '0;                     
                lsEntry[i].addr <= '0;
                lsEntry[i].data <= '0;
                lsEntry[i].dataReady <= '0;
                lsEntry[i].addrReady <= '0;
                lsEntry[i].offset <= '0;
                lsEntry[i].pDest <= '0;
                lsEntry[i].archDest <= '0;
                lsEntry[i].Wrob <= '0;
                lsEntry[i].commit <= '0;
                lsEntry[i].funct3 <= '0;
            end
        end
        else begin
            // Enqueue for load
            if (ls_we && loadStoreStall == 1'b0 && operation == 1'b0) begin
                lsEntry[tail].ls_valid <= 1'b1;    
                lsEntry[tail].operation <= operation;    
                lsEntry[tail].addr <= prs1; 
                lsEntry[tail].addrReady <= prs1Ready;
                lsEntry[tail].data <= 'x;
                lsEntry[tail].dataReady <= 'x;
                lsEntry[tail].offset <= offset;
                lsEntry[tail].pDest <= pDest;
                lsEntry[tail].archDest <= archDest;
                lsEntry[tail].Wrob <= ROBnum;
                lsEntry[tail].commit <= 'x;
                lsEntry[tail].funct3 <= funct3;
               
                if (tail == RS_NUM_LOGIC-1'b1) tail <= '0;
                else tail <= tail + 1'b1;
            end
            // Enqueue for store
            else if (ls_we && loadStoreStall == 1'b0 && operation == 1'b1) begin 
                lsEntry[tail].ls_valid <= 1'b1;
                lsEntry[tail].operation <= operation;
                lsEntry[tail].addr <= prs1; 
                lsEntry[tail].addrReady <= prs1Ready;
                lsEntry[tail].data <= prs2;
                lsEntry[tail].dataReady <= prs2Ready;
                lsEntry[tail].offset <= offset;
                lsEntry[tail].pDest <= 'x;
                lsEntry[tail].archDest <= 'x;
                lsEntry[tail].Wrob <= ROBnum; 
                lsEntry[tail].commit <= '0;
                lsEntry[tail].funct3 <= funct3;

                if (tail == RS_NUM_LOGIC-1'b1) tail <= '0;
                else tail <= tail + 1'b1;
            end

            // Dequeue
            // If head is pointing at a load
            if (lsEntry[head].operation == 1'b0 && lsEntry[head].addrReady == 1'b1 && memory_fu_ready == 1'b1) begin
                loadstoreFU <= lsEntry[head];
                lsEntry[head] <= '0;

                if (head == RS_NUM_LOGIC-1'b1) head <= '0; //I change to bit 0
                else head <= head + 1'b1;
            end
            // ROB is looking at a store so value is kept inside RS but pushed to FU
            else if (lsEntry[head].operation == 1'b1 && isStore && lsEntry[head].Wrob == storeRobIdx && memory_fu_ready
                    && lsEntry[head].addrReady && lsEntry[head].dataReady) begin
                loadstoreFU <= lsEntry[head];
                lsEntry[head] <= '0;

                if (head == RS_NUM_LOGIC-1'b1) head <= '0; //I change to bit 0
                else head <= head + 1'b1;
            end
            else begin
                loadstoreFU <= '0;
            end

            // Snooping Common Data Bus for matching Physical Reg value
            for (int i = 0; i < RS_NUM; i++) begin
                if (ls_res_input_cdb.cdb_valid != '0 && ls_res_input_cdb.arch_reg != '0 && ls_res_input_cdb.phys_reg == lsEntry[i].addr && lsEntry[i].addrReady == 1'b0) begin
                    lsEntry[i].addrReady <= 1'b1;
                end
                if (ls_res_input_cdb.cdb_valid != '0 && ls_res_input_cdb.arch_reg != '0 && ls_res_input_cdb.phys_reg == lsEntry[i].data && lsEntry[i].dataReady == 1'b0) begin
                    lsEntry[i].dataReady <= 1'b1;
                end
            end
            // // Snooping for commit signal from ROB to prep Store dequeue
            // if (lsEntry[head].operation == 1'b0 && lsEntry[head].commit == 1'b0 && commit && commit_rob_idx == lsEntry[head].Wrob) begin
            //     lsEntry[head].commit <= 1'b1;
            // end
        end
    end

    // IS LS Station FUll?
    always_comb begin
        loadStoreStall = 1'b1;          // Defaulted to Stall
        flag1 = 1'b0;
        for (int i = 0; i < RS_NUM; i++) begin
            if (lsEntry[i].ls_valid == 1'b0) begin                
                flag1 = 1'b1;
            end
            if ( i == RS_NUM-1 ) begin
                if (flag1) loadStoreStall = 1'b0;   // If empty index found -> No longer stalling
            end
        end
    end

endmodule : reserveLS2