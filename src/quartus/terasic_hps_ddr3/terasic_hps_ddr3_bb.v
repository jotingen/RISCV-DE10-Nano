
module terasic_hps_ddr3 (
	clk_clk,
	h2f_reset_reset_n,
	hps_f2h_sdram0_clock_clk,
	hps_f2h_sdram0_data_address,
	hps_f2h_sdram0_data_read,
	hps_f2h_sdram0_data_readdata,
	hps_f2h_sdram0_data_write,
	hps_f2h_sdram0_data_writedata,
	hps_f2h_sdram0_data_readdatavalid,
	hps_f2h_sdram0_data_waitrequest,
	hps_f2h_sdram0_data_byteenable,
	hps_f2h_sdram0_data_burstcount,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin);	

	input		clk_clk;
	output		h2f_reset_reset_n;
	input		hps_f2h_sdram0_clock_clk;
	input	[25:0]	hps_f2h_sdram0_data_address;
	input		hps_f2h_sdram0_data_read;
	output	[127:0]	hps_f2h_sdram0_data_readdata;
	input		hps_f2h_sdram0_data_write;
	input	[127:0]	hps_f2h_sdram0_data_writedata;
	output		hps_f2h_sdram0_data_readdatavalid;
	output		hps_f2h_sdram0_data_waitrequest;
	input	[15:0]	hps_f2h_sdram0_data_byteenable;
	input	[8:0]	hps_f2h_sdram0_data_burstcount;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
endmodule
