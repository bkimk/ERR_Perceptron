/*
module reserveLS
import rv32i_types::*;
(
    input   logic                       clk,
    input   logic                       rst,
    input   logic   [11:0]              offset,             // offset             
    input   logic                       issuedNum,          // Will be used for Issued Logic
    input   logic   [ROB_WIDTH-1:0]     ROBnum,             // TODO: Change for when ROB size has been determined
    input   logic   [PR_WIDTH-1:0]      prs1,               // Physical Register 1
    input   logic   [PR_WIDTH-1:0]      prs2,               // Physical Register 2
    input   logic                       prs1Ready,          // Physical Register 1 Ready Signal
    input   logic                       prs2Ready,          // Physical Register 2 Ready Signal
    input   logic   [PR_WIDTH-1:0]      pDest,              // Physical Destination Register
    input   logic   [4:0]               archDest,           // Architectural Destination Register
    input   logic                       load_we,            // Signal For Writing to Load RS
    input   logic                       store_we,           // Signal For Writing to Store RS    
    input   logic                       dmem_resp,          // Ready Signal for DPort; Should be latched dmem_resp
    input   cdb_t                       cdb,                // CDB struct   
    input   ROBEntry_t                  robEntry,           // ROB Entry
    input   logic                       commit,             // commit signal from ROB

    output  logic                       loadStall,          // Stall for load Reservation Station
    output  logic                       storeStall,         // Stall for store Reservation Station
    output  loadReservationEntry        loadFU,             // ReservationEntry Struct to Add FU
    output  storeReservationEntry       storeFU             // ReservationEntry Struct to Mul FU
    
);

    // Head and Tail Declaration
    logic   [RS_WIDTH-1:0]              loadHead, loadTail, storeHead1, storeHead2, storeTail;
    
    // Count for Load and Store Reservation Stations
    logic   [RS_WIDTH-1:0]              load_count, store_count;

    // Load/Store Reservation Station Declaration
    loadReservationEntry  loadStation [RS_NUM];
    storeReservationEntry storeStation [RS_NUM];

    // Setting of Load/Store Station entries + Moving Head/Tail
    always_ff @(posedge clk) begin 
        if (rst) begin
            loadHead <= '0;
            loadTail <= '0;
            storeHead <= '0;
            storeTail <= '0;
            load_count <= '0;
            store_count <= '0;
            for (int i = 0; i < RS_NUM; i++) begin
                // Load Entries
                loadStation[i].issued <= '0;                     
                loadStation[i].addr <= '0;
                loadStation[i].addrReady <= '0;
                loadStation[i].offset <= '0;
                loadStation[i].pDest <= '0;
                loadStation[i].archDest <= '0;
                loadStation[i].Wrob <= '0;
                // Store Entries
                storeStation[i].issued <= '0;
                storeStation[i].addr <= '0;
                storeStation[i].addrReady <= '0;
                storeStation[i].data <= '0;
                storeStation[i].dataReady <= '0;
                storeStation[i].offset <= '0;
                storeStation[i].commit <= '0;
                storeStation[i].Wrob <= '0;
            end
        end
        else begin
            // Load Write Enable And Load Station is not Full
            // Enqueue for load
            if (load_we && loadStall == 1'b0) begin
                loadStation[loadTail].issued <= issuedNum;
                loadStation[loadTail].addr <= prs1;
                loadStation[loadTail].addrReady <= prs1Ready;
                loadStation[loadTail].offset <= offset;
                loadStation[loadTail].pDest <= pDest;
                loadStation[loadTail].archDest <= archDest;
                loadStation[loadTail].Wrob <= ROBnum;
                load_count <= load_count + 1'b1;
                if (loadTail == RS_NUM-1) loadTail <= 0;
                else loadTail <= loadTail + 1;
            end
            // Store Write Enable And Store Station is not Full
            // Enqueue for Store
            if (store_we && storeStall == 1'b0) begin
                storeStation[storeTail].issued <= issuedNum;
                storeStation[storeTail].addr <= prs1;
                storeStation[storeTail].addrReady <= prs1Ready;
                storeStation[storeTail].data <= prs2;
                storeStation[storeTail].dataReady <= prs2Ready;
                storeStation[storeTail].offset <= offset;
                storeStation[storeTail].Wrob <= ROBnum;
                store_count <= store_count + 1'b1;
                if (storeTail == RS_NUM-1) storeTail <= 0;
                else storeTail <= storeTail + 1;
            end
            // If dmem_resp is ready && load is older then oldest store && addr is Ready => Send to FU
            // Dequeue for Load
            if (dmem_resp && storeStation[storeHead].issued < loadStation[loadHead].issued && loadStation[storeHead].addrReady == 1'b1)  begin  
                loadFU <= loadStation[loadHead];
                loadStation[loadHead] <= '0;
                load_count <= load_count - 1'b1;
                if (loadHead == RS_NUM-1) loadHead <= 0;
                else loadHead <= loadHead + 1;
            end
            // if commit && ROB number matches => send to FU
            // Dequeue for Store
            else if (dmem_resp && commit && storeStation[storeHead].Wrob == robEntry.idx) begin
                storeFU <= storeStation[storeHead];         // SHould be looking at the top most head; CHANGE
                storeStation[storeHead] <= '0;
                store_count <= store_count - 1'b1;
            end
            // If store is older then oldest load (Means oldest instruction in load + store queue) && addr is Ready && data is ready
            // Second head moves down for store
            if (storeStation[storeHead].issued > loadStation[loadHead].issued && storeStation[storeHead].addrReady == 1'b1 && storeStation[storehead].dataReady == 1'b1)  begin  
                // Incorporate 2nd head
            end
            for (int i = 0; i < RS_NUM; i++) begin
                // Constantly Checking Common Data Bus for matching ROB value
                // TODO: Need to figure out a way to add ROB # to Register Struct Value
                if (cdb.phys_reg == loadStation[i].addr && loadStation[i].addrReady == 1'b0) begin
                    loadStation[i].addr <= cdb.data;
                    loadStation[i].addrReady <= 1'b1;
                end
                if (cdb.phys_reg == storeStation[i].addr && storeStation[i].addrReady == 1'b0) begin
                    storeStation[i].addr <= cdb.data;
                    storeStation[i].addrReady <= 1'b1;
                end
                if (cdb.phys_reg == storeStation[i].data && storeStation[i].dataReady == 1'b0) begin
                    storeStation[i].data <= cdb.data;
                    storeStation[i].dataReady <= 1'b1;
                end
            end
        end
    end

    always_comb begin
        // Determine if load Station is Full
        if (load_count == RS_NUM) begin     
            loadStall = 1'b1;
        end
        else begin
            loadStall = 1'b0;
        end
        // Determine if store Station is Full
        if (store_count == RS_NUM) begin
            storeStall = 1'b1;
        end
        else begin
            storeStall = 1'b0;
        end
    end

endmodule : reserveLS
// Questions:
//      When to send store straight to ROB vs through functional unit or Dport
//      Do I need 2 heads for store to keep track of those that haven't been committed + those that are waiting to be pushed to ROB
//      Do I need an age field? Doesn't queue implementation already keep track of age? How big should age be? Can i also just use index
//      Do I have to compare store addresses to load addresses to check for dependencies? If i have a queue implementation will i have to do that
// TODO:
//      Make sure all heads + tails lined up as they should
*/