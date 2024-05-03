package rv32i_types;

    localparam int PR_WIDTH = 6;                                        // Number of bits required to represent physical registers
    localparam int ROB_WIDTH = 3;                                       // Number of bits required to represent ROB entries
    localparam int RS_WIDTH = 3;                                        // Number of bits required to represent Reservation Station entries
    localparam int PHYS_REG_NUM = 2**PR_WIDTH;                          // Number of physical registers = free list size
    localparam int RAT_NUM = 32;
    localparam int RRF_NUM = 32;
    localparam int RS_NUM = 2**RS_WIDTH;                                // Number of indices inside each Reservation Station
    localparam int ROB_NUM = 2**ROB_WIDTH;                              // Number of physical registers = free list size

    // For Logic Variable Comparisons
    localparam logic [RS_WIDTH:0] RS_NUM_LOGIC = 2**RS_WIDTH;       
    localparam logic [ROB_WIDTH:0] ROB_NUM_LOGIC = 2**ROB_WIDTH; 
    localparam logic [ROB_WIDTH-1:0] ROB_IDX_LOGIC = 2**ROB_WIDTH;    
    localparam logic [PR_WIDTH-1:0] PR_NUM_LOGIC = 2**PR_WIDTH;

    // Gshare
    localparam int GHR_WIDTH = 32;
    localparam int WEIGHTS_WIDTH = 8;
    localparam int P_TABLE_SIZE = 256;

    typedef enum logic [6:0] {
        op_b_lui    = 7'b0110111, // U load upper immediate 
        op_b_auipc  = 7'b0010111, // U add upper immediate PC 
        op_b_jal    = 7'b1101111, // J jump and link 
        op_b_jalr   = 7'b1100111, // I jump and link register 
        op_b_br     = 7'b1100011, // B branch 
        op_b_load   = 7'b0000011, // I load 
        op_b_store  = 7'b0100011, // S store 
        op_b_imm    = 7'b0010011, // I arith ops with register/immediate operands 
        op_b_reg    = 7'b0110011  // R arith ops with register operands AND 32M Extension
    } rv32i_op_b_t;

    typedef enum bit [2:0] {
        mul     = 3'b000,
        mulh    = 3'b001,
        mulhsu  = 3'b010,
        mulhu   = 3'b011, 
        div     = 3'b100,
        divu    = 3'b101, 
        rem     = 3'b110, 
        remu    = 3'b111
    } M_ext_funct3_t;

    typedef enum bit [2:0] {
        beq  = 3'b000,
        bne  = 3'b001,
        blt  = 3'b100,
        bge  = 3'b101,
        bltu = 3'b110,
        bgeu = 3'b111
    } branch_funct3_t;

    typedef enum bit [2:0] {
        lb  = 3'b000,
        lh  = 3'b001,
        lw  = 3'b010,
        lbu = 3'b100,
        lhu = 3'b101
    } load_funct3_t;

    typedef enum bit [2:0] {
        sb = 3'b000,
        sh = 3'b001,
        sw = 3'b010
    } store_funct3_t;

    typedef enum bit [2:0] {
        alu_add = 3'b000,
        alu_sll = 3'b001,
        alu_sra = 3'b010,
        alu_sub = 3'b011,
        alu_xor = 3'b100,
        alu_srl = 3'b101,
        alu_or  = 3'b110,
        alu_and = 3'b111
    } alu_ops;

    typedef enum bit [2:0] {
        add  = 3'b000, //check bit 30 for sub if op_reg opcode
        sll  = 3'b001,
        slt  = 3'b010,
        sltu = 3'b011,
        axor = 3'b100,
        sr   = 3'b101, //check bit 30 for logical/arithmetic
        aor  = 3'b110,
        aand = 3'b111
    } arith_funct3_t;

    typedef struct packed {
        logic                       valid;
        logic   [31:0]              inst;
        logic   [4:0]               rs1_addr;
        logic   [4:0]               rs2_addr;
        logic   [31:0]              rs1_rdata;
        logic   [31:0]              rs2_rdata;
        logic   [4:0]               rd_addr;
        logic   [31:0]              rd_wdata;
        logic   [31:0]              pc_rdata, pc_wdata;
        logic   [31:0]              mem_addr;
        logic   [3:0]               mem_rmask, mem_wmask;
        logic   [31:0]              mem_rdata, mem_wdata;
    } RVFI;
    

    typedef struct packed {
        logic   [31:0]  pc;
        logic   [31:0]  pc_next;
        logic   [31:0]  out_inst;
        logic           prediction;

    } if_id_stage_reg_t;

    typedef struct packed {
        logic   [31:0]  pc;
        logic   [31:0]  pc_next;

        logic           valid;
        logic   [31:0]  inst;

        logic           decoded;
        logic   [6:0]   opcode;
        logic   [6:0]   funct7;
        logic   [2:0]   funct3;
        logic   [3:0]   mem_rmask;
        logic   [3:0]   mem_wmask;
        logic           RegWrite;
        logic           MemtoReg;
        logic   [4:0]   rs1_addr;
        logic   [4:0]   rs2_addr;
        logic   [4:0]   rd;
        logic   [31:0]  imm_gen;
        logic           prediction;

        logic   [1:0]   reservation_choice;
        RVFI            rvfi_sig;
    } id_ex_stage_reg_t;

    typedef struct packed {
        logic                   cdb_valid;
        logic   [ROB_WIDTH-1:0] rob;
        logic   [4:0]           arch_reg;
        logic   [PR_WIDTH-1:0]  phys_reg;
        logic   [31:0]          data;           // LSB is for branch
        logic   [31:0]          ps1_rdata;
        logic   [31:0]          ps2_rdata;
        logic                   is_store;
        logic                   is_branch;
        logic                   is_jalr;
        logic   [31:0]          branch_imm;

        logic   [31:0]          mem_addr;
        logic   [31:0]          mem_wdata;
        logic   [31:0]          mem_rdata;
        logic   [3:0]           mem_rmask;
        logic   [3:0]           mem_wmask;
    } cdb_t;
    
    typedef struct packed {
        logic                   rob_valid;  // Valid entry inside ROB
        logic   [ROB_WIDTH-1:0] idx;        // Rob Row Idx
        logic   [PR_WIDTH-1:0]  pReg;       // 
        logic   [4:0]           archReg;    // Destination Register
        logic                   br;         // Branch Signal
        logic   [31:0]          br_imm;     // Branch Imm
        logic   [31:0]          pc;         // pc val
        logic                   st;         // Store Signal
        logic                   jmp;        // jalr/jal singal
        logic                   prediction; // gshare predict
        logic                   is_branch;
        
        RVFI                    rvfi_sig;
    } ROBEntry_t;

    typedef struct packed {
        logic                       valid;                  // Is valid instruction inside RS
        logic   [31:0]              imm_gen;                // imm_gen
        logic   [6:0]               opcode;                 // opcode
        logic   [3:0]               Op;                     // Operation
        logic   [PR_WIDTH-1:0]      prs1;                   // Physical Reg 1
        logic   [PR_WIDTH-1:0]      prs2;                   // Physical Reg 2
        logic                       prs1Ready;              // rs1 Ready Signal
        logic                       prs2Ready;              // rs2 Ready Signal
        logic   [PR_WIDTH-1:0]      pDest;                  // Physical Register Destination 
        logic   [4:0]               archDest;               // Architectural Destination Register                     
        logic   [ROB_WIDTH-1:0]     Wrob;                   // ROB #
    } ReservationEntry_t;

    // Load Reservation Station Entry
    typedef struct packed {
        logic                       ls_valid;               // Is valid entry inside LS
        logic                       operation;              // 0 = load; 1 = store
        logic   [PR_WIDTH-1:0]      addr;                   // Address
        logic                       addrReady;              // Address is Ready
        logic   [PR_WIDTH-1:0]      data;                   // Data to be stored
        logic                       dataReady;              // Is Data inside the Reservation Station Ready?  
        logic   [31:0]              offset;                 // offset
        logic   [PR_WIDTH-1:0]      pDest;                  // Physical Register Destination 
        logic   [4:0]               archDest;               // Architectural Destination Register  
        logic   [ROB_WIDTH-1:0]     Wrob;                   // ROB #    
        logic                       inProgress;             // Store is pushed to FU
        logic                       commit;                 // Has Store been Commited
        logic   [2:0]               funct3;                 // Choosing for specific operation
    } loadStoreReservationEntry_t;


endpackage
