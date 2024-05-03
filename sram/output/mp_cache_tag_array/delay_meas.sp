* Cycle 0      Port All    0.00 ns:      : Idle cycle (no positive clock edge)
* Cycle 1      Port 0      0.00 ns:      : W data 1 address 0000
* Cycle 2      Port 0      0.00 ns:      : W data 0 address 1111 to write value
* Cycle 3      Port 0      0.00 ns:      : Clock only on port 0
* Cycle 4      Port 0      0.00 ns:      : R data 1 address 0000 to set dout caps
* Cycle 5      Port 0      0.00 ns:      : R data 0 address 1111 to check W0 worked
* Cycle 6      Port 0      0.00 ns:      : Clock only on port 0
* Cycle 7      Port All    0.00 ns:      : Idle cycle (if read takes >1 cycle)
* Cycle 8      Port 0      0.00 ns:      : W data 1 address 1111 to write value
* Cycle 9      Port 0      0.00 ns:      : Clock only on port 0
* Cycle 10     Port 0      0.00 ns:      : W data 0 address 0000 to clear din caps
* Cycle 11     Port 0      0.00 ns:      : Clock only on port 0
* Cycle 12     Port 0      0.00 ns:      : R data 0 address 0000 to clear dout caps
* Cycle 13     Port 0      0.00 ns:      : R data 1 address 1111 to check W1 worked
* Cycle 14     Port All    0.00 ns:      : Idle cycle (if read takes >1 cycle))
* Read ports 0
.meas tran delay_lh0 TRIG v(clk0) VAL=2.5 FALL=1 TD=0n TARG v(dout0_23) VAL=2.5 RISE=1 TD=0n

.meas tran delay_hl0 TRIG v(clk0) VAL=2.5 FALL=1 TD=0n TARG v(dout0_23) VAL=2.5 FALL=1 TD=0n

.meas tran slew_lh0 TRIG v(dout0_23) VAL=0.5 RISE=1 TD=0n TARG v(dout0_23) VAL=4.5 RISE=1 TD=0n

.meas tran slew_hl0 TRIG v(dout0_23) VAL=4.5 FALL=1 TD=0n TARG v(dout0_23) VAL=0.5 FALL=1 TD=0n

.meas tran read1_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran read0_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran disabled_read1_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran disabled_read0_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran v_bl_read_zero0 FIND v(xmp_cache_tag_array.xbank0.bl_0_23) AT=0.0n 

.meas tran v_br_read_zero0 FIND v(xmp_cache_tag_array.xbank0.br_0_23) AT=0.0n 

.meas tran v_bl_read_one0 FIND v(xmp_cache_tag_array.xbank0.bl_0_23) AT=0.0n 

.meas tran v_br_read_one0 FIND v(xmp_cache_tag_array.xbank0.br_0_23) AT=0.0n 

.meas tran v_delay_lh0 FIND v(dout0_23) AT=0.0n 

.meas tran v_delay_hl0 FIND v(dout0_23) AT=0.0n 

.meas tran delay_sen0 TRIG v(clk0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.s_en0) VAL=2.5 RISE=1 TD=0.0n

.meas tran v_q_a1111_b23_read_zero0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q) AT=0.0n 

.meas tran v_q_a1111_b23_read_one0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q) AT=0.0n 

.meas tran v_qbar_a1111_b23_read_zero0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q_bar) AT=0.0n 

.meas tran v_qbar_a1111_b23_read_one0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q_bar) AT=0.0n 

.meas tran delay_clk0_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int_sen_id0 TRIG v(clk0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int_sen_id1 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int_sen_id2 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int_sen_id3 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int_sen_id4 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int_to_xmp_cache_tag_array.clk_buf0_sen_id5 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.clk_buf0) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.clk_buf0_to_xmp_cache_tag_array.xcontrol0.clk_bar_sen_id6 TRIG v(xmp_cache_tag_array.clk_buf0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.clk_bar) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.clk_bar_to_xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int_sen_id7 TRIG v(xmp_cache_tag_array.xcontrol0.clk_bar) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int_to_xmp_cache_tag_array.xcontrol0.gated_clk_bar_sen_id8 TRIG v(xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.gated_clk_bar) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.gated_clk_bar_to_xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int_sen_id9 TRIG v(xmp_cache_tag_array.xcontrol0.gated_clk_bar) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int_to_xmp_cache_tag_array.wl_en0_sen_id10 TRIG v(xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.wl_en0) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.wl_en0_to_xmp_cache_tag_array.xbank0.xport_address0.xrbl_driver.zb_int_sen_id11 TRIG v(xmp_cache_tag_array.wl_en0) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xbank0.xport_address0.xrbl_driver.zb_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xbank0.xport_address0.xrbl_driver.zb_int_to_xmp_cache_tag_array.xbank0.rbl_wl0_sen_id12 TRIG v(xmp_cache_tag_array.xbank0.xport_address0.xrbl_driver.zb_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xbank0.rbl_wl0) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xbank0.rbl_wl0_to_xmp_cache_tag_array.rbl_bl0_sen_id13 TRIG v(xmp_cache_tag_array.xbank0.rbl_wl0) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.rbl_bl0) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.rbl_bl0_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_1_sen_id14 TRIG v(xmp_cache_tag_array.rbl_bl0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_1) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_1_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_2_sen_id15 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_1) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_2) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_2_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_3_sen_id16 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_2) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_3) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_3_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_4_sen_id17 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_3) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_4) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_4_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_5_sen_id18 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_4) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_5) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_5_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_6_sen_id19 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_5) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_6) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_6_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_7_sen_id20 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_6) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_7) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_7_to_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_8_sen_id21 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_7) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_8) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_8_to_xmp_cache_tag_array.xcontrol0.rbl_bl_delay_sen_id22 TRIG v(xmp_cache_tag_array.xcontrol0.xdelay_chain.dout_8) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.rbl_bl_delay) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.rbl_bl_delay_to_xmp_cache_tag_array.xcontrol0.xbuf_s_en_and.zb_int_sen_id23 TRIG v(xmp_cache_tag_array.xcontrol0.rbl_bl_delay) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xbuf_s_en_and.zb_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xbuf_s_en_and.zb_int_to_xmp_cache_tag_array.s_en0_sen_id24 TRIG v(xmp_cache_tag_array.xcontrol0.xbuf_s_en_and.zb_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.s_en0) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.s_en0_to_dout0_23_sen_id25 TRIG v(xmp_cache_tag_array.s_en0) VAL=2.5 RISE=1 TD=0.0n TARG v(dout0_23) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_clk0_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int_bl_id26 TRIG v(clk0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int_bl_id27 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb1_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int_bl_id28 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb2_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int_bl_id29 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb3_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int_to_xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int_bl_id30 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb4_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int_to_xmp_cache_tag_array.clk_buf0_bl_id31 TRIG v(xmp_cache_tag_array.xcontrol0.xclkbuf.zb5_int) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.clk_buf0) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.clk_buf0_to_xmp_cache_tag_array.xcontrol0.clk_bar_bl_id32 TRIG v(xmp_cache_tag_array.clk_buf0) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.clk_bar) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.clk_bar_to_xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int_bl_id33 TRIG v(xmp_cache_tag_array.xcontrol0.clk_bar) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int_to_xmp_cache_tag_array.xcontrol0.gated_clk_bar_bl_id34 TRIG v(xmp_cache_tag_array.xcontrol0.xand2_gated_clk_bar.zb_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.gated_clk_bar) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.gated_clk_bar_to_xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int_bl_id35 TRIG v(xmp_cache_tag_array.xcontrol0.gated_clk_bar) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int_to_xmp_cache_tag_array.wl_en0_bl_id36 TRIG v(xmp_cache_tag_array.xcontrol0.xbuf_wl_en.zb1_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.wl_en0) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.wl_en0_to_xmp_cache_tag_array.xbank0.xport_address0.xwordline_driver.xwl_driver_and15.zb_int_bl_id37 TRIG v(xmp_cache_tag_array.wl_en0) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xbank0.xport_address0.xwordline_driver.xwl_driver_and15.zb_int) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xbank0.xport_address0.xwordline_driver.xwl_driver_and15.zb_int_to_xmp_cache_tag_array.xbank0.wl_0_15_bl_id38 TRIG v(xmp_cache_tag_array.xbank0.xport_address0.xwordline_driver.xwl_driver_and15.zb_int) VAL=2.5 FALL=1 TD=0.0n TARG v(xmp_cache_tag_array.xbank0.wl_0_15) VAL=2.5 RISE=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xbank0.wl_0_15_to_xmp_cache_tag_array.xbank0.bl_0_23_bl_id39 TRIG v(xmp_cache_tag_array.xbank0.wl_0_15) VAL=2.5 RISE=1 TD=0.0n TARG v(xmp_cache_tag_array.xbank0.bl_0_23) VAL=2.5 FALL=1 TD=0.0n

.meas tran delay_xmp_cache_tag_array.xbank0.bl_0_23_to_dout0_23_bl_id40 TRIG v(xmp_cache_tag_array.xbank0.bl_0_23) VAL=2.5 FALL=1 TD=0.0n TARG v(dout0_23) VAL=2.5 FALL=1 TD=0.0n

* Write ports 0
.meas tran write1_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran write0_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran disabled_write1_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran disabled_write0_power0 avg par('(-1*v(vdd)*I(vvdd))') from=0n to=0n

.meas tran v_q_a1111_b23_write_zero0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q) AT=0.0n 

.meas tran v_q_a1111_b23_write_one0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q) AT=0.0n 

.meas tran v_qbar_a1111_b23_write_zero0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q_bar) AT=0.0n 

.meas tran v_qbar_a1111_b23_write_one0 FIND v(xmp_cache_tag_array.xbank0.xbitcell_array.xreplica_bitcell_array.xbitcell_array.xbit_r15_c23.Q_bar) AT=0.0n 

