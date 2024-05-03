module fetch_stage_tb;
    
    timeunit 1ps;
    timeprecision 1ps;

    import rv32i_types::*;

    //---------------------------------------------------------------------------------
    // TODO: Generate a clock:
    //---------------------------------------------------------------------------------
    bit clk;
    initial clk = 1'b1;
    always #5ns clk = ~clk; // Always drive clocks with blocking assignment.

    //---------------------------------------------------------------------------------
    // Waveform generation.
    //---------------------------------------------------------------------------------
    initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0, "+all");
    end

    bit rst;
    int timeout = 1000; // in cycles, change according to your needs

    // Explicit dual port connections when caches are not integrated into design yet (Before CP3)
    mem_itf mem_itf_i(.*);
    magic_dual_port #(.MEMFILE("/home/px4/mp_ooo/sp24_ece411_Unemployed_Trio/mp_ooo/sim/sim/memory.lst")) 
    mem(.itf_i(mem_itf_i));

    logic   enq, deq, empty, full;
    logic   [31:0]      out_inst, decode_inst;
    if_id_stage_reg_t   if_id_reg;

    fetch dut(
        .clk            (clk),
        .rst            (rst),

        .full           (full),
        .imem_resp      (mem_itf_i.resp),
        .imem_rdata     (mem_itf_i.rdata),
        .branch         ('0),
        .br_pc          (),
        .enq            (enq),
        .imem_addr      (mem_itf_i.addr),
        .imem_rmask     (mem_itf_i.rmask),

        .if_id_reg_next (if_id_reg)
    );

    instq iq(
        .clk            (clk),
        .rst            (rst),

        .enq            (enq),
        .deq            (deq),
        .if_id_reg      (if_id_reg),
        .branch         (),
        .empty          (empty),
        .full           (full),
        .if_id_reg_out  ()       
    );

    // decode decode(

    //     .stall          ('0),
    //     .decode_inst    (decode_inst),
    //     .empty          (empty),
    //     .if_id_reg      (),
    //     .deq            (deq),
    //     .id_ex_reg_next ()
    // );

    task do_reset();
        rst = 1'b1; // Special case: using a blocking assignment to set rst
                    // to 1'b1 at time 0.

        repeat (4) @(posedge clk); // Wait for 4 clock cycles.

        rst <= 1'b0; // Generally, non-blocking assignments when driving DUT
                    // signals.
    endtask : do_reset

    task monitor_values ();

        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000013 );
        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000093 );
        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000113 );
        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000193 );
        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000213 );
        @(posedge clk iff mem_itf_i.resp);
        assert( out_inst == 32'h00000293 );

        // DEPTH=5 so Queue is FULL

    endtask
    //undo enq , out_inst signal, if_id_reg for fetch module

    task check_queue ();
        //Hold Enq till Full
        deq <= '0;
        enq <= '1;
        out_inst <= 32'h11111111;
        if_id_reg <= {32'h60000000, 32'h60000004}; 
        @(posedge clk);
        out_inst <= 32'h22222222;
        @(posedge clk);
        out_inst <= 32'h33333333;
        @(posedge clk);
        out_inst <= 32'h44444444;
        @(posedge clk);
        out_inst <= 32'h55555555;
        @(posedge clk);
        assert( full == '1);

        // try to enq
        out_inst <= 32'h66666666;
        @(posedge clk)
        enq <= '0;
        // deque values
        deq <= '1;
        @(posedge clk)
        assert( decode_inst === 32'h11111111);
        @(posedge clk);
        assert( decode_inst == 32'h22222222);
        @(posedge clk);
        assert( decode_inst == 32'h33333333);
        @(posedge clk);
        assert( decode_inst == 32'h44444444);
        @(posedge clk);
        assert( decode_inst == 32'h55555555);
        @(posedge clk);
        // empty queue
        assert( decode_inst == 32'hx);
        
        // check enq and deq at the same time
        deq <= '0;
        enq <= '1;
        out_inst <= 32'h12121212;
        @(posedge clk);
        out_inst <= 32'h34343434;
        deq <= '1;
        assert( decode_inst <= 32'h12121212);
        @(posedge clk);
        deq <= '0;

        enq <= '0;
    endtask

    initial begin
        do_reset();
        @(posedge clk iff rst == 1'b0);

        monitor_values();
        //check_queue();
        
    end

    always @(posedge clk) begin

        if (timeout == 0) begin
            $error("TB Error: Timed out");
            $finish;
        end
        timeout <= timeout - 1;

    end

endmodule
