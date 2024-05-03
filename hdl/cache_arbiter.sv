//------------------------------------------------------------------
// Cache_arbiter Description:
//  The cache_arbiter takes in requests from both imem_cache & dmem_cache.
//  It uses round-robin algorithm to allow equal opportunity for 
//  inst_cache and data_cache to access bmem.
//  
//  Bmem characteristic: input should only be high for 1 cycle while
//  bmem_ready signal is high. There are queue in bmem such that 
//  multiple reads returned out-of-order while multiple writes are
//  executed in-order.
//------------------------------------------------------------------
module cache_arbiter (
    input   logic           clk, 
    input   logic           rst, 
    output  logic           i_cache,
    output  logic           d_cache,    
    // inputs and outputs of inst_cache
    input   logic   [31:0]  inst_dfp_addr, 
    input   logic           inst_dfp_read,
    input   logic           inst_dfp_write,
    output  logic   [255:0] inst_dfp_rdata, 
    input   logic   [255:0] inst_dfp_wdata,
    output  logic           inst_dfp_resp, 

    // inputs and outputs of data_cache
    input   logic   [31:0]  data_dfp_addr, 
    input   logic           data_dfp_read,
    input   logic           data_dfp_write,
    output  logic   [255:0] data_dfp_rdata, 
    input   logic   [255:0] data_dfp_wdata,
    output  logic           data_dfp_resp, 

    // inputs and outputs of bmem
    output  logic   [31:0]  bmem_addr,
    output  logic           bmem_read,
    output  logic           bmem_write,
    output  logic   [63:0]  bmem_wdata,     // data is written 4x consequtively w/ 64 bits each
    input   logic           bmem_ready,     // bmem signal that states it can take in more operation

    input   logic   [31:0]  bmem_raddr,     // which address data it is returning (since out-of-order, it is required)
    input   logic   [63:0]  bmem_rdata,     // 64 bit data that it returned. Will return in 4x consecutive cycles
    input   logic           bmem_rvalid     // valid signal that is high when returning read
);
    logic   [31:0]  lint_addr;
    // avoid lint
    assign          lint_addr = bmem_raddr;
    logic           imem_read_request_sent; // flag that inst_cache's request has been sent
    logic           dmem_read_request_sent; // flag that data_cache's request has been sent
    logic   [1:0]   read_iteration;         // iterating 4 times to read data
    logic   [1:0]   write_iteration;        // iterating 4 times to write data

    logic           [255:0] full_cache_line;
    logic                   full_cache_line_ready;
    logic           [255:0] semi_cache_line;

    logic   dummy;
    assign dummy = (inst_dfp_wdata != 0) ? 1'b1 : 1'b0;
    // Declaration of State Names
    enum int unsigned {
        s_inst, s_data
    } state, state_next;

    // Shifting to Next State, setting the request_sent flags low/high, incrementing iteration
    always_ff @( posedge clk ) begin
        if (rst) begin
            state <= s_inst;
        end else begin
            state <= state_next;
        end
        unique case ( state )
            s_inst: 
                begin
                    // imem_read_request_sent should be set high to prevent spamming of same request
                    if ( rst ) begin
                        imem_read_request_sent <= 1'b0;
                    end else if ( read_iteration == 2'd3 ) begin
                        imem_read_request_sent <= 1'b0;
                    end else if ( ( inst_dfp_read ) && bmem_ready ) begin
                        imem_read_request_sent <= 1'b1;
                    end
                    // Read process is done for 4 clk cycles from the initial rvalid signal
                    if ( rst ) begin
                        read_iteration <= 2'd0;
                    end else if ( bmem_rvalid && read_iteration != 2'd3 ) begin
                        read_iteration <= read_iteration + 2'd1;
                    end else if ( read_iteration == 2'd3 ) begin
                        read_iteration <= 2'd0;
                    end
                    if ( rst ) begin
                        semi_cache_line <= '0;
                    end else if ( bmem_rvalid ) begin
                        unique case ( read_iteration )
                            2'd0: semi_cache_line <= {semi_cache_line[255:64], bmem_rdata};
                            2'd1: semi_cache_line <= {semi_cache_line[255:128], bmem_rdata, semi_cache_line[63:0]};
                            2'd2: semi_cache_line <= {semi_cache_line[255:192], bmem_rdata, semi_cache_line[127:0]};
                            2'd3: semi_cache_line <= {bmem_rdata, semi_cache_line[191:0]};
                            default: semi_cache_line <= '0;
                        endcase
                    end
                    dmem_read_request_sent <= 1'b0;
                    write_iteration <= 2'd0;
                end
            s_data: 
                begin
                    // dmem_read_request_sent should be set high to prevent spamming of same request
                    if ( rst ) begin
                        dmem_read_request_sent <= 1'b0;
                    end else if ( read_iteration == 2'd3 || write_iteration == 2'd3 ) begin
                        dmem_read_request_sent <= 1'b0;
                    end else if ( ( data_dfp_read ) && bmem_ready ) begin
                        dmem_read_request_sent <= 1'b1;
                    end

                    // Read process is done for 4 clk cycles from the initial rvalid signal
                    if ( rst ) begin
                        read_iteration <= 2'd0;
                    end else if ( bmem_rvalid && read_iteration != 2'd3 ) begin
                        read_iteration <= read_iteration + 2'd1;
                    end else if ( read_iteration == 2'd3 ) begin
                        read_iteration <= 2'd0;
                    end
                    if ( rst ) begin
                        semi_cache_line <= '0;
                    end else if ( bmem_rvalid ) begin
                        unique case ( read_iteration )
                            2'd0: semi_cache_line <= {semi_cache_line[255:64], bmem_rdata};
                            2'd1: semi_cache_line <= {semi_cache_line[255:128], bmem_rdata, semi_cache_line[63:0]};
                            2'd2: semi_cache_line <= {semi_cache_line[255:192], bmem_rdata, semi_cache_line[127:0]};
                            2'd3: semi_cache_line <= {bmem_rdata, semi_cache_line[191:0]};
                            default: semi_cache_line <= '0;
                        endcase
                    end
                    // Write process is done for 4 clk cycles from the initial write request
                    if ( rst ) begin
                        write_iteration <= 2'd0;
                    end else if ( data_dfp_write ) begin
                        write_iteration <= write_iteration + 2'd1;
                    end else begin
                        write_iteration <= 2'd0;
                    end
                    imem_read_request_sent <= 1'b0;
                end
            default: ;
        endcase
    end

    // Setting output values, retrieving data
    always_comb begin
        // default values
        inst_dfp_rdata = 256'b0;
        inst_dfp_resp = 1'b0;
        data_dfp_rdata = 256'b0;
        data_dfp_resp = 1'b0;

        bmem_addr = 32'b0;
        bmem_read = 1'b0;
        bmem_write = 1'b0;
        bmem_wdata = 64'b0;

        state_next = s_inst;
        full_cache_line = '0;
        full_cache_line_ready = '0;
        i_cache = '0;
        d_cache = '0;
        unique case ( state )
            s_inst: begin
                i_cache = '1;
                // instruction cache will only read. Thus, write does not matter.
                if ( (inst_dfp_read || inst_dfp_write) ) begin
                    // Spamming request until bmem_receives it.
                    if ( !imem_read_request_sent ) begin
                        bmem_addr = inst_dfp_addr;
                        bmem_read = inst_dfp_read;
                        bmem_write = inst_dfp_write;
                        bmem_wdata = '0;
                    end
                    // If receive data a valid data, combine the data and then output it to inst_cache
                    if ( bmem_rvalid ) begin
                        // for each iteration, different part of 256 bits are being allocated into cache
                        unique case ( read_iteration )
                            2'd0: full_cache_line = {full_cache_line[255:64], bmem_rdata};
                            2'd1: full_cache_line = {full_cache_line[255:128], bmem_rdata, full_cache_line[63:0]};
                            2'd2: full_cache_line = {full_cache_line[255:192], bmem_rdata, full_cache_line[127:0]};
                            2'd3: 
                                begin
                                    full_cache_line = {bmem_rdata, semi_cache_line[191:0]};
                                    full_cache_line_ready = 1'b1;
                                end
                            default: full_cache_line = '0;
                        endcase
                        // if ( bmem_raddr == inst_dfp_addr && full_cache_line_ready ) begin
                        if ( full_cache_line_ready ) begin
                            inst_dfp_rdata = full_cache_line;
                            inst_dfp_resp = bmem_rvalid;
                        end
                    end
                    // Have to iterate through 4 times to send all data to inst_cache
                    if (read_iteration == 2'd3) begin
                        state_next = s_data;
                    end else begin
                        state_next = s_inst;
                    end
                end else begin  // Case when there is no request from imem_cache
                    state_next = s_data;
                end
            end
            s_data: begin
                d_cache = '1;
                // Case 1: Reading from bmem. Very similar to imem_cache read.
                if ( data_dfp_read ) begin
                    // Spamming request until bmem_receives it.
                    if ( !dmem_read_request_sent ) begin
                        bmem_addr = data_dfp_addr;
                        bmem_read = data_dfp_read;
                    end
                    // If receive data a valid data, combine the data and then output it to inst_cache
                    if ( bmem_rvalid ) begin
                        // for each iteration, different part of 256 bits are being allocated into cache
                        unique case ( read_iteration )
                            2'd0: full_cache_line = {full_cache_line[255:64], bmem_rdata};
                            2'd1: full_cache_line = {full_cache_line[255:128], bmem_rdata, full_cache_line[63:0]};
                            2'd2: full_cache_line = {full_cache_line[255:192], bmem_rdata, full_cache_line[127:0]};
                            2'd3: 
                                begin
                                    full_cache_line = {bmem_rdata, semi_cache_line[191:0]};
                                    full_cache_line_ready = 1'b1;
                                end
                            default: full_cache_line = '0;
                        endcase
                        // if ( bmem_raddr == data_dfp_addr && full_cache_line_ready ) begin
                        if (  full_cache_line_ready ) begin
                            data_dfp_rdata = full_cache_line;
                            data_dfp_resp = bmem_rvalid;
                        end
                    end
                    // Have to iterate through 4 times to send all data to data_cache
                    if (read_iteration == 2'd3) begin
                        state_next = s_inst;
                    end else begin
                        state_next = s_data;
                    end
                // Case 2: Writing to bmem.
                end else if ( data_dfp_write ) begin
                    // Write to bmem for 4 consecutive cycles.
                    // data_dfp_wdata will change for each cycle.
                    bmem_addr = data_dfp_addr;
                    bmem_write = data_dfp_write;
                    unique case ( write_iteration )
                        2'd0: bmem_wdata = data_dfp_wdata[63:0];
                        2'd1: bmem_wdata = data_dfp_wdata[127:64];
                        2'd2: bmem_wdata = data_dfp_wdata[191:128];
                        2'd3: bmem_wdata = data_dfp_wdata[255:192];
                        default: bmem_wdata = '0;
                    endcase
                    state_next = s_data;
                    if ( write_iteration == 2'd3 ) begin
                        state_next = s_inst; // When we are done, move to next state.
                        data_dfp_resp = 1'b1;
                    end
                end else begin      // Case 3: No read/write request to bmem
                    state_next = s_inst;
                end
            end
            default: ;
        endcase
    end

endmodule