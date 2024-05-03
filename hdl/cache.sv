module cache (
    input   logic           clk,
    input   logic           rst,
    input   logic           branch,
    input   logic           in_arbit,
    // cpu side signals, ufp -> upward facing port
    input   logic   [31:0]  ufp_addr,
    input   logic   [3:0]   ufp_rmask,
    input   logic   [3:0]   ufp_wmask,
    output  logic   [31:0]  ufp_rdata,
    input   logic   [31:0]  ufp_wdata,
    output  logic           ufp_resp,

    // memory side signals, dfp -> downward facing port
    output  logic   [31:0]  dfp_addr,
    output  logic           dfp_read,
    output  logic           dfp_write,
    input   logic   [255:0] dfp_rdata,
    output  logic   [255:0] dfp_wdata,
    input   logic           dfp_resp
);

            logic   [22:0]  tag_value;
            logic   [3:0]   set_index;
            logic   [4:0]   data_offset;

            logic           check_way_A, check_way_B, check_way_C, check_way_D;
            logic           hit;
            logic   [1:0]   way_selector;
            logic   [1:0]   cur_PLRU_target;

            logic           data_we[4]; 
            logic   [255:0] data_in[4];
            logic   [255:0] data_out[4];
            logic           tag_we[4];
            logic   [23:0]  tag_in[4];
            logic   [23:0]  tag_out[4];
            logic           valid_we[4];
            logic           valid_out[4];

            logic   [31:0]  data_wmask;
            logic   [255:0] cache_full_data_out;

            logic [2:0] PLRU;
            logic [2:0] PLRU_next;
            logic       loadPLRU;
            logic       branch_hold;
    
    generate for (genvar i = 0; i < 4; i++) begin : arrays
        mp_cache_data_array data_array (
            .clk0       (clk),
            .csb0       (1'b0),
            .web0       (data_we[i]),
            .wmask0     (data_wmask),
            .addr0      (set_index),
            .din0       (data_in[i]),
            .dout0      (data_out[i])
        );
        mp_cache_tag_array tag_array (
            .clk0       (clk),
            .csb0       (1'b0),
            .web0       (tag_we[i]),
            .addr0      (set_index),
            .din0       (tag_in[i]),
            .dout0      (tag_out[i])
        );
        ff_array #(.WIDTH(1)) valid_array (
            .clk0       (clk),
            .rst0       (rst),
            .csb0       (1'b0),
            .web0       (valid_we[i]),
            .addr0      (set_index),
            .din0       (1'b1),
            .dout0      (valid_out[i])
        );
    end endgenerate

    enum int unsigned {
        s_idle, s_compare_tag, s_allocate, s_stall, s_write_back
    } state, state_next;

    ff_array #(.WIDTH(3)) PLRU_array (
        .clk0       (clk),
        .rst0       (rst),
        .csb0       (1'b0),
        .web0       (!loadPLRU),
        .addr0      (set_index),
        .din0       (PLRU_next),
        .dout0      (PLRU)
    );

    always_ff @( posedge clk ) begin
        if ( rst ) begin
            state <= s_idle;
            branch_hold <= '0;
        end else if (branch || branch_hold) begin
                if (state == s_allocate && in_arbit && !dfp_resp) begin
                    state <= s_allocate;
                    branch_hold <= '1;
                end else begin
                    state <= s_idle;
                    branch_hold <= '0;
                end
        end else begin
            state <= state_next;
            branch_hold <= '0;
        end

    end

    assign tag_value = ufp_addr[31:9];
    assign set_index = ufp_addr[8:5];
    assign data_offset = ufp_addr[4:0];
    // Check if the data is in the cache
    assign check_way_A = valid_out[0] & ( tag_value[22:0] == tag_out[0][22:0] );
    assign check_way_B = valid_out[1] & ( tag_value[22:0] == tag_out[1][22:0] );
    assign check_way_C = valid_out[2] & ( tag_value[22:0] == tag_out[2][22:0] );
    assign check_way_D = valid_out[3] & ( tag_value[22:0] == tag_out[3][22:0] );
    assign hit = check_way_A || check_way_B || check_way_C || check_way_D;
    always_comb begin
        if ( check_way_A ) begin
            way_selector = 2'd0;
        end else if ( check_way_B ) begin
            way_selector = 2'd1;
        end else if ( check_way_C ) begin
            way_selector = 2'd2;
        end else if ( check_way_D ) begin
            way_selector = 2'd3;
        end else begin
            way_selector = 2'd0;
        end
        if ( PLRU[0] == 1'b0 && PLRU[1] == 1'b0 ) begin
            cur_PLRU_target = 2'd0;
        end else if ( PLRU[0] == 1'b0 && PLRU[1] == 1'b1 ) begin
            cur_PLRU_target = 2'd1;
        end else if ( PLRU[0] == 1'b1 && PLRU[2] == 1'b0 ) begin
            cur_PLRU_target = 2'd2;
        end else if ( PLRU[0] == 1'b1 && PLRU[2] == 1'b1 ) begin
            cur_PLRU_target = 2'd3;
        end else begin
            cur_PLRU_target = 2'd0;
        end
        if ( rst ) begin
            PLRU_next = '0;
        end else begin
            if ( hit & (state == s_compare_tag) ) begin
                unique case ( way_selector )
                    0: begin PLRU_next = {PLRU[2], 1'b1, 1'b1}; end
                    1: begin PLRU_next = {PLRU[2], 1'b0, 1'b1}; end
                    2: begin PLRU_next = {1'b1, PLRU[1], 1'b0}; end
                    3: begin PLRU_next = {1'b0, PLRU[1], 1'b0}; end
                    default: PLRU_next = PLRU;
                endcase
            end else begin
                PLRU_next = PLRU;
            end
        end
    end

    always_comb begin
        // Default Values
        state_next = state;
        cache_full_data_out = '0;
        ufp_rdata = '0;
        ufp_resp = '0;

        dfp_addr = '0;
        dfp_wdata = '0;
        dfp_write = '0;
        dfp_read = '0;

        data_we[0] = 1'b1;
        data_we[1] = 1'b1;
        data_we[2] = 1'b1;
        data_we[3] = 1'b1;

        data_in[0] = '0;
        data_in[1] = '0;
        data_in[2] = '0;
        data_in[3] = '0;

        tag_we[0] = 1'b1;
        tag_we[1] = 1'b1;
        tag_we[2] = 1'b1;
        tag_we[3] = 1'b1;

        tag_in[0] = '0;
        tag_in[1] = '0;
        tag_in[2] = '0;
        tag_in[3] = '0;

        valid_we[0] = 1'b1;
        valid_we[1] = 1'b1;
        valid_we[2] = 1'b1;
        valid_we[3] = 1'b1;

        data_wmask = '0;
        loadPLRU = '0;
        unique case ( state )
            s_idle: begin
                if ( (ufp_rmask != 0) || (ufp_wmask != 0)) begin
                    state_next = s_compare_tag;
                end else begin
                    state_next = state;
                end
            end
            s_compare_tag: begin
                // If it is a hit, do calculation & go to s_idle
                if ( hit ) begin
                    cache_full_data_out = data_out[way_selector];
                    if ( ufp_rmask != 0 ) begin
                        ufp_rdata = cache_full_data_out[data_offset[4:2]*32 +: 32];
                    end else begin
                        data_we[ way_selector ] = 1'b0;
                        data_wmask = { 28'd0, ufp_wmask } << 4*data_offset[4:2];
                        data_in[ way_selector ] = {8{ufp_wdata}};
                        tag_we[ way_selector ] = 1'b0;
                        tag_in[ way_selector ] = { 1'b1, tag_value };
                        valid_we[ way_selector ] = 1'b0;
                    end
                    ufp_resp = 1'b1;
                    state_next = s_idle;
                    loadPLRU = 1'b1;
                end else begin
                    if ( tag_out[ cur_PLRU_target ][23] == 1'b1 ) begin
                        state_next = s_write_back;
                    end else begin
                        state_next = s_allocate;
                    end
                end
            end
            s_allocate: begin
                dfp_addr = {tag_value, set_index, 5'b00000};
                dfp_write = 1'b0;
                dfp_read = 1'b1;
                if ( dfp_resp == 1'b0 ) begin
                    state_next = state;
                end else if (!(branch || branch_hold))begin
                    data_we[ cur_PLRU_target ] = 1'b0;
                    data_wmask = 32'hFFFFFFFF;
                    data_in[ cur_PLRU_target ] = dfp_rdata;
                    tag_we[ cur_PLRU_target ] = 1'b0;
                    tag_in[ cur_PLRU_target ] = { 1'b0, tag_value };
                    valid_we[ cur_PLRU_target ] = 1'b0;
                    state_next = s_stall;
                end
            end
            s_stall: begin
                state_next = s_compare_tag;
            end
            s_write_back: begin
                dfp_addr = {tag_out[ cur_PLRU_target ][22:0], set_index, 5'b00000};
                dfp_write = 1'b1;
                dfp_read = 1'b0;
                cache_full_data_out = data_out[ cur_PLRU_target ];
                dfp_wdata = cache_full_data_out;
                if ( !dfp_resp ) begin
                    state_next = state;
                end else begin
                    state_next = s_allocate;
                end
            end
            default: begin
                state_next = s_idle;
            end
        endcase
    end
/*
So I don' think we can use the commit to determine if we can move on in the fsm of the allocate stage bc 
if we are in the beginning and theree is nothing in the rob so no commits. ( we could have another hardcoded signal 
checking if rob is empty then maybe we look for a commit signal)

Need to make the cache indifferent to the behavior of a  instruction or data. So main goal is to bring back the correct data/instuction
on a branch as the ufp addr changes midway and we dont know what state the cache could be in.

Note: The timing for when the correct address comes depening on the arbiter bc if its fetching  based on pc, the new pc address
will come next cycle and if its looking for a load/store it will wait a couple of cycles.

Actually the current arbiter is wrong in the sense that if we are doing an instuction fetch and it completes it will have switch
to asking for a data instuction and continually switch if no requests from either cache. In that case if it completes the invalid 

On a reset both caches appear to be available for a request even if they are both in the middle of one. So we should keep in line and reset the cache state.
We can't do this immediately if we are in allocate and we must wait for it to finish the allocate state and then get set back to idle.
The problem comes when taking in the new pc value (it will always be a pc fetch after a branch). We also need a way to tell which cache is arbit 
working on bc if we are in the allocate state for both cache, we might be waiting for a resp that will never come if arbit isn't working on it.

So we need a way to ignore the incoming new pc if we are in allocate (I believe the pc will latch )

Also if on branch we are processing the old pc and it gets a cache hit and returns next cycle. We don't need branch_next to clear out the instq
again bc the cache state will get reset to idle and not ouput anything
*/

endmodule