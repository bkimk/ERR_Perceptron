module cpu
import rv32i_types::*;
(
    // Explicit dual port connections when caches are not integrated into design yet (Before CP3)
    // input   logic           clk,
    // input   logic           rst,

    // output  logic   [31:0]  imem_addr,
    // output  logic   [3:0]   imem_rmask,
    // input   logic   [31:0]  imem_rdata,
    // input   logic           imem_resp,

    // output  logic   [31:0]  dmem_addr,
    // output  logic   [3:0]   dmem_rmask,
    // output  logic   [3:0]   dmem_wmask,
    // input   logic   [31:0]  dmem_rdata,
    // output  logic   [31:0]  dmem_wdata,
    // input   logic           dmem_resp

    // Single memory port connection when caches are integrated into design (CP3 and after)
    input   logic           clk,
    input   logic           rst,

    output  logic   [31:0]  bmem_addr,
    output  logic           bmem_read,
    output  logic           bmem_write,
    output  logic   [63:0]  bmem_wdata,
    input   logic           bmem_ready,

    input   logic   [31:0]  bmem_raddr,
    input   logic   [63:0]  bmem_rdata,
    input   logic           bmem_rvalid

);

    if_id_stage_reg_t   if_id_reg_next, if_id_reg_out;
    id_ex_stage_reg_t   id_ex_reg,      id_ex_reg_next;

    logic               full, empty, enq, deq;
    logic   [31:0]      decode_inst;

    //-----------------------------------------------------------------
    //Rename/Dispatch logic to ROB, RAT, RS
    //----------------------------------------------------------------
    logic                       rat_reg_we,  rob_reg_we;
    logic                       add_reg_we,  mul_reg_we, ls_reg_we;
    ROBEntry_t                  rob_entry;
    ReservationEntry_t          res_entry; 
    logic                       free_deq, free_empty, AddStall, MulStall, RobStall, LSStall;
    logic       [4:0]           rat_arch_rd, rat_arch_rs1, rat_arch_rs2;
    logic       [PR_WIDTH-1:0]  free_rd, rat_phys_rs1, rat_phys_rs2, rat_phys_rd;
    logic                       rat_ps1_valid, rat_ps2_valid;
    logic                       re_dis_stall;
    logic       [ROB_WIDTH-1:0] rob_idx;
    logic                       isStore;
    logic   [ROB_WIDTH-1:0]     storeRobIdx;
    //------------------------------------------------------------------
    // Execute to Writeback logic
    //------------------------------------------------------------------
    cdb_t                       alu_CDB, mul_CDB,  mem_CDB, arbit_CDB;
    logic       [31:0]          alu_op1, alu_op2, mul_op1, mul_op2, mem_op1, mem_op2;
    logic                       alu_ready, mul_ready, mem_ready, alu_ack, mul_ack, mem_ack;
    ReservationEntry_t          resAddOut, resMulOut;
    loadStoreReservationEntry_t resMemOut;
    //------------------------------------------------------------------
    // Commit Logic
    //------------------------------------------------------------------
    logic                       commit;
    logic                       free_enq;
    logic       [PR_WIDTH-1:0]  freed_phys_reg;
    ROBEntry_t                  commit_rob;
    //------------------------------------------------------------------
    // Branching Logic
    //------------------------------------------------------------------
    logic                   branch;
    logic   [PR_WIDTH-1:0]  arch_phys_map_copy [RRF_NUM];

    always_ff @( posedge clk ) begin
        if ( rst ) begin
            id_ex_reg <= '0;
        end else if (re_dis_stall) begin
            id_ex_reg <= id_ex_reg;     
        end else if (branch) begin
            id_ex_reg <= '0;
        end else begin
            id_ex_reg <= id_ex_reg_next;    //pass on for decode into rename/dispatch stage
        end
    end
    //------------------------------------------------------------------
    // Cache Logic
    //------------------------------------------------------------------
    logic   [31:0]  imem_addr;
    logic   [3:0]   imem_rmask;
    logic   [31:0]  imem_rdata;
    logic           imem_resp;

    logic   [3:0]   imem_wmask;
    logic   [31:0]  imem_wdata;

    assign imem_wmask = '0;
    assign imem_wdata = '0;

    logic   [31:0]  dmem_addr;
    logic   [3:0]   dmem_rmask;
    logic   [3:0]   dmem_wmask;
    logic   [31:0]  dmem_rdata;
    logic   [31:0]  dmem_wdata;
    logic           dmem_resp;

    logic   [31:0]  inst_dfp_addr;
    logic           inst_dfp_read;
    logic           inst_dfp_write;
    logic   [255:0] inst_dfp_rdata;
    logic   [255:0] inst_dfp_wdata;
    logic           inst_dfp_resp;

    logic   [31:0]  data_dfp_addr;
    logic           data_dfp_read;
    logic           data_dfp_write;
    logic   [255:0] data_dfp_rdata;
    logic   [255:0] data_dfp_wdata;
    logic           data_dfp_resp;
    logic           i_cache, d_cache;

//------------------------------------------------------------------
// Cache Logic
//------------------------------------------------------------------
    logic   [31:0]                  branch_pc;
    logic                           gshare_is_br;
    logic                           committing_br;
    logic                           prediction;
    logic   [31:0]                  branch_imm;
    logic   [31:0]                  gshare_br_pc;           // From ROB to Fetch. For False Prediction
    logic   [31:0]                  comitting_br_pc;

    //------------------------------------------------------------------
    // Branch:
    //  - invalidate all inputs on branch mispredict, 
    //  - For fetch, made so that it wouldnt enq if it was a branch line #69
    //  - For instq, prevented output if branch was high
    //  - Decode valid bit should be set to 0 with instq changes
    //  - Skipped redis; just make sure all outputs are invalidated
    //  - David look at rat
    //  - Cleared ROB
    //  - Cleared All Reservation Stations on branch
    //  - For memory fu set branch condition to be same as reset
    //  - Getting branching data from ROB itself not phys reg
    //  - in alu cmp give cdb a is_branch + branch_imm for the pc value
    //  - in mutliplier, need David to set all curr data to invalid + output to invalid
    //  - set arbiter to output cdb = 0 if branch
    //  - make rrf output copy of itself to rat
    //  - set branch head/tail pointer in freelist
    //  - someone fix counter inside free list for enq/deq simultaneous
    //  - Change for loops inside RS and ROB very inefficient rn
    //------------------------------------------------------------------

    //------------------------------------------------------------------
    // Cache Description:
    //  For CP3, we implemented basic cache which iterates four cycles to 
    //  combine the 64 bits of data into 256 bits to load from and save to
    //  the main memory from the cache.
    //  
    //  Post CP3: we will implement a cache line arbiter which will combine
    //  the main memory outputs into a single 256 lines and pass that out.
    //  This is way better in terms of critical path.
    //  
    //------------------------------------------------------------------
    cache inst_cache_inst (
        .clk(clk), 
        .rst(rst),
        .branch(branch),
        .in_arbit(i_cache), 

        .ufp_addr(imem_addr), 
        .ufp_rmask(imem_rmask), 
        .ufp_wmask(imem_wmask), 
        .ufp_rdata(imem_rdata), 
        .ufp_wdata(imem_wdata), 
        .ufp_resp(imem_resp), 

        .dfp_addr(inst_dfp_addr), 
        .dfp_read(inst_dfp_read), 
        .dfp_write(inst_dfp_write), 
        .dfp_rdata(inst_dfp_rdata), 
        .dfp_wdata(inst_dfp_wdata), 
        .dfp_resp(inst_dfp_resp)
    );

    cache data_cache_inst (
        .clk(clk), 
        .rst(rst), 
        .branch(branch),
        .in_arbit(d_cache),

        .ufp_addr(dmem_addr), 
        .ufp_rmask(dmem_rmask), 
        .ufp_wmask(dmem_wmask), 
        .ufp_rdata(dmem_rdata), 
        .ufp_wdata(dmem_wdata), 
        .ufp_resp(dmem_resp), 

        .dfp_addr(data_dfp_addr), 
        .dfp_read(data_dfp_read), 
        .dfp_write(data_dfp_write), 
        .dfp_rdata(data_dfp_rdata), 
        .dfp_wdata(data_dfp_wdata), 
        .dfp_resp(data_dfp_resp)
    );

    cache_arbiter cache_arbiter_inst (
        .clk(clk), 
        .rst(rst), 
        .i_cache(i_cache),
        .d_cache(d_cache),

        .inst_dfp_addr(inst_dfp_addr), 
        .inst_dfp_read(inst_dfp_read), 
        .inst_dfp_write(inst_dfp_write), 
        .inst_dfp_rdata(inst_dfp_rdata), 
        .inst_dfp_wdata(inst_dfp_wdata), 
        .inst_dfp_resp(inst_dfp_resp), 

        .data_dfp_addr(data_dfp_addr), 
        .data_dfp_read(data_dfp_read), 
        .data_dfp_write(data_dfp_write), 
        .data_dfp_rdata(data_dfp_rdata), 
        .data_dfp_wdata(data_dfp_wdata), 
        .data_dfp_resp(data_dfp_resp), 

        .bmem_addr(bmem_addr), 
        .bmem_read(bmem_read), 
        .bmem_write(bmem_write), 
        .bmem_wdata(bmem_wdata), 
        .bmem_ready(bmem_ready), 

        .bmem_raddr(bmem_raddr), 
        .bmem_rdata(bmem_rdata), 
        .bmem_rvalid(bmem_rvalid)
    );


    fetch fetch (
        .clk(clk), 
        .rst(rst), 
        .full(full),
        .imem_resp(imem_resp),
        .imem_rdata(imem_rdata),
        .branch(branch),                // Now used for false prediction
        .br_pc(gshare_br_pc),           // From ROB
        .prediction(prediction),        // From gshare
        .predict_pc(branch_imm),        // From Instq

        .enq(enq),
        .imem_addr(imem_addr), 
        .imem_rmask(imem_rmask), 
        .if_id_reg_next(if_id_reg_next)
        
    );

    perceptron perceptron_inst (
        .clk(clk),
        .rst(rst),
    // From Instq
        .branch_pc(branch_pc),                     // Lower bits of branch address
        .is_branch(gshare_is_br),                  // Indicates a branch instruction
    // From ROB
        .branch_taken(branch),                     // Actual branch outcome (taken/not taken)
        .committing_br(committing_br),             // Inst Commit
        .comitting_br_pc(comitting_br_pc),

    // Prediction output
        .prediction(prediction)
    );
      
    instq instq_inst (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .enq(enq),
        .deq(deq),
        .if_id_reg(if_id_reg_next),

        // For Gshare
        .prediction(prediction),

        .branch_pc(branch_pc),               // Branch Instruction
        .gshare_is_br(gshare_is_br),            // Branch Inst Flag    
        .branch_imm(branch_imm),             // Branch Immediate

        .empty(empty),
        .full(full),
        .if_id_reg_out(if_id_reg_out)
    );

    decode decode (
        .branch(branch),
        .empty(empty),
        .if_id_reg(if_id_reg_out),
        .re_dis_stall(re_dis_stall),
        .deq(deq),
        .id_ex_reg_next(id_ex_reg_next)
    );

    re_dis  re_dis(
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .id_rename_dispatch(id_ex_reg),
        .arch_rs1(rat_arch_rs1),
        .arch_rs2(rat_arch_rs2),
        .free_deq(free_deq),
        .free_empty(free_empty),
        .AddStall(AddStall),
        .MulStall(MulStall),
        .RobStall(RobStall),
        .LSStall(LSStall), 
        .free_rd(free_rd),
        .phys_rs1(rat_phys_rs1),
        .phys_rs2(rat_phys_rs2),
        .ps1_valid(rat_ps1_valid),
        .ps2_valid(rat_ps2_valid),
        .rob_idx(rob_idx),
        .opcode(id_ex_reg.opcode), 
        .imm_gen(id_ex_reg.imm_gen), 
        .prediction(id_ex_reg.prediction),
        .pc(id_ex_reg.pc),

        // Output/Dispatch
        .rat_reg_we(rat_reg_we),
        .phys_rd(rat_phys_rd),
        .arch_rd(rat_arch_rd),
        .rob_reg_we(rob_reg_we),
        .rob_entry(rob_entry),
        .add_reg_we(add_reg_we),
        .mul_reg_we(mul_reg_we),
        .ls_reg_we(ls_reg_we), 
        .res_entry(res_entry),
        .re_dis_stall(re_dis_stall)
    );

    rat rat(
        // TODO: What to do regarding valid bits
        // May be able to disregard these outputs if never used on branch in re-dis
        .clk(clk),
        .rst(rst), 
        .cdb(arbit_CDB), 
        .dispatch_regf_we(rat_reg_we), 
        .dispatch_rd(rat_arch_rd), 
        .dispatch_pd(rat_phys_rd), 
        .rs1(rat_arch_rs1), 
        .rs2(rat_arch_rs2), 
        .branch(branch),
        .commit(commit_rob),
        .arch_phys_map_copy(arch_phys_map_copy),

        .ps1(rat_phys_rs1), 
        .ps1_valid(rat_ps1_valid), 
        .ps2(rat_phys_rs2), 
        .ps2_valid(rat_ps2_valid)
    );

    rob rob_inst(
        .clk(clk),
        .rst(rst),
        .enq(rob_reg_we),         
        .archReg(rob_entry.archReg),
        .pReg(rob_entry.pReg),
        .cdb(arbit_CDB),     
        .in_rvfi(rob_entry.rvfi_sig),
        .br_imm(rob_entry.br_imm),
        .st(rob_entry.st),
        .is_branch(rob_entry.is_branch),
        .jmp(rob_entry.jmp),
        .prediction(rob_entry.prediction),
        .pc(rob_entry.pc),

        .robNum(rob_idx),         
        .robEntry(commit_rob),    
        .robHasSpace(RobStall),
        .commit(commit),
        .branch(branch),
        .committing_br(committing_br),
        .comitting_br_pc(comitting_br_pc),
        .gshare_br_pc(gshare_br_pc),
        .isStore(isStore),
        .storeRobIdx(storeRobIdx)

    );

    reserveAM reserveAM_inst(
        .clk(clk),
        .rst(rst),
        .operation(res_entry.Op),     
        .ROBnum(res_entry.Wrob),           
        .prs1(res_entry.prs1),       
        .prs2(res_entry.prs2), 
        .pDest(res_entry.pDest),             
        .archDest(res_entry.archDest),                  
        .prs1Ready(res_entry.prs1Ready),       
        .prs2Ready(res_entry.prs2Ready),        
        .add_we(add_reg_we),         
        .mul_we(mul_reg_we),    
        .imm_gen(res_entry.imm_gen),
        .opcode(res_entry.opcode),            
        .cdb(arbit_CDB),    
        .branch(branch),                         

        .addFUReady(alu_ready),         
        .mulFUReady(mul_ready),         

        .add_full(AddStall),           
        .mul_full(MulStall),          
        .addFU(resAddOut),             
        .mulFU(resMulOut)

    );


    reserveLS2 reserveLS2_inst(
        .clk(clk), 
        .rst(rst), 
        .operation(res_entry.opcode[5]), 
        .offset(res_entry.imm_gen), 
        .ROBnum(res_entry.Wrob), 
        .prs1(res_entry.prs1), 
        .prs2(res_entry.prs2),
        .pDest(res_entry.pDest), 
        .archDest(res_entry.archDest), 
        .prs1Ready(res_entry.prs1Ready), 
        .prs2Ready(res_entry.prs2Ready), 
        .ls_we(ls_reg_we), 
        .ls_res_input_cdb(arbit_CDB), 
        //.commit(commit), 
        //.commit_rob_idx(commit_rob.idx), 
        .memory_fu_ready(mem_ready), 
        .funct3(res_entry.Op[2:0]), 
        .branch(branch),
        .isStore(isStore),
        .storeRobIdx(storeRobIdx),

        .loadStoreStall(LSStall), 
        .loadstoreFU(resMemOut)

    );

    memory_fu memory_fu_inst(
        .clk(clk), 
        .rst(rst), 
        .LoadStore_RS_package(resMemOut), 
        .a(mem_op1), 
        .b(mem_op2), 
        .cdb_mem_ack(mem_ack), 
        .dmem_rdata(dmem_rdata), 
        .dmem_resp(dmem_resp), 
        .branch(branch),

        .dmem_addr(dmem_addr), 
        .dmem_rmask(dmem_rmask), 
        .dmem_wmask(dmem_wmask), 
        .dmem_wdata(dmem_wdata), 
        .mem_cdb_output(mem_CDB), 
        .mem_fu_ready(mem_ready)
    );

    phys_reg phys_reg_inst(
        // TODO: what to do regarding phys_reg file with branching
        .clk(clk),
        .rst(rst), 
        .cdb_regf_we(arbit_CDB.cdb_valid),
        .cdb_pd(arbit_CDB.phys_reg), 
        .cdb_pd_value(arbit_CDB.data), 
        .cdb_is_store(arbit_CDB.is_store), 
        .alu_ps1(resAddOut.prs1), 
        .alu_ps2(resAddOut.prs2), 
        .mul_ps1(resMulOut.prs1), 
        .mul_ps2(resMulOut.prs2), 
        .mem_ps1(resMemOut.addr), 
        .mem_ps2(resMemOut.data), 
        // .br_pc(commit_rob.pReg),

        .alu_ps1_value(alu_op1), 
        .alu_ps2_value(alu_op2), 
        .mul_ps1_value(mul_op1), 
        .mul_ps2_value(mul_op2), 
        .mem_ps1_value(mem_op1), 
        .mem_ps2_value(mem_op2)
        // .br_pc_val(br_pc_val)
    );

    alu_cmp alu_cmp_inst(
        .clk(clk),
        .rst(rst),
        .RS_package(resAddOut), 
        .a(alu_op1),     
        .b(alu_op2),
        //.branch(branch),
        .cdb_alu_ack(alu_ack),    
        .cdb_output(alu_CDB), 
        .ready(alu_ready)

    );
    shift_add_multiplier mult(
        // TODO: Use branch signal to set incoming signals as invalid + curr as invalid
        .clk(clk),
        .rst(rst),
        .start(resMulOut.valid),
        .mul_type(resMulOut.Op[1:0]),
        .a(mul_op1),
        .b(mul_op2),
        .branch(branch),
        .arch_reg(resMulOut.archDest),
        .phys_reg(resMulOut.pDest),
        .rob(resMulOut.Wrob),
        .cdb_mul_ack(mul_ack),    
        
        .mul_cdb_output(mul_CDB),
        .done(mul_ready)

    );
    arbit arbit(
        .clk(clk), 
        .rst(rst),
        .alu_cdb(alu_CDB),
        .mul_cdb(mul_CDB),
        .mem_cdb(mem_CDB),
        .branch(branch),

        .cdb(arbit_CDB),
        .alu_ack(alu_ack),
        .mul_ack(mul_ack),
        .mem_ack(mem_ack)

    );

    rrf rrf_inst(
        .clk(clk),
        .rst(rst),
        .commit(commit_rob),
        .regf_we(commit), 
        .branch(branch),

        .old_phys_reg_index(freed_phys_reg), 
        .enqueue(free_enq),
        .arch_phys_map_copy(arch_phys_map_copy)
    );

    free_list free_list_inst(
        .clk(clk),
        .rst(rst), 
        .enqueue(free_enq),
        .dequeue(free_deq),
        .freed_phys_reg(freed_phys_reg),
        .branch(branch),
        .jmp(commit_rob.jmp),

        .is_empty(free_empty),
        .free_phys_reg(free_rd)

    );

    
    
    endmodule : cpu