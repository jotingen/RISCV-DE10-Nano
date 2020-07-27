// soc_system.v

// Generated using ACDS version 20.1 711

`timescale 1 ps / 1 ps
module soc_system (
		input  wire         clk_clk,                                //                       clk.clk
		output wire         ddr3_clk_clk,                           //                  ddr3_clk.clk
		input  wire         ddr3_hps_f2h_sdram0_clock_clk,          // ddr3_hps_f2h_sdram0_clock.clk
		input  wire [25:0]  ddr3_hps_f2h_sdram0_data_address,       //  ddr3_hps_f2h_sdram0_data.address
		input  wire         ddr3_hps_f2h_sdram0_data_read,          //                          .read
		output wire [127:0] ddr3_hps_f2h_sdram0_data_readdata,      //                          .readdata
		input  wire         ddr3_hps_f2h_sdram0_data_write,         //                          .write
		input  wire [127:0] ddr3_hps_f2h_sdram0_data_writedata,     //                          .writedata
		output wire         ddr3_hps_f2h_sdram0_data_readdatavalid, //                          .readdatavalid
		output wire         ddr3_hps_f2h_sdram0_data_waitrequest,   //                          .waitrequest
		input  wire [15:0]  ddr3_hps_f2h_sdram0_data_byteenable,    //                          .byteenable
		input  wire [8:0]   ddr3_hps_f2h_sdram0_data_burstcount,    //                          .burstcount
		output wire [14:0]  memory_mem_a,                           //                    memory.mem_a
		output wire [2:0]   memory_mem_ba,                          //                          .mem_ba
		output wire         memory_mem_ck,                          //                          .mem_ck
		output wire         memory_mem_ck_n,                        //                          .mem_ck_n
		output wire         memory_mem_cke,                         //                          .mem_cke
		output wire         memory_mem_cs_n,                        //                          .mem_cs_n
		output wire         memory_mem_ras_n,                       //                          .mem_ras_n
		output wire         memory_mem_cas_n,                       //                          .mem_cas_n
		output wire         memory_mem_we_n,                        //                          .mem_we_n
		output wire         memory_mem_reset_n,                     //                          .mem_reset_n
		inout  wire [31:0]  memory_mem_dq,                          //                          .mem_dq
		inout  wire [3:0]   memory_mem_dqs,                         //                          .mem_dqs
		inout  wire [3:0]   memory_mem_dqs_n,                       //                          .mem_dqs_n
		output wire         memory_mem_odt,                         //                          .mem_odt
		output wire [3:0]   memory_mem_dm,                          //                          .mem_dm
		input  wire         memory_oct_rzqin                        //                          .oct_rzqin
	);

	wire    ddr3_h2f_reset_reset; // ddr3:h2f_reset_reset_n -> pll:rst

	soc_system_ddr3 ddr3 (
		.clk_clk                           (clk_clk),                                //                  clk.clk
		.h2f_reset_reset_n                 (ddr3_h2f_reset_reset),                   //            h2f_reset.reset_n
		.hps_f2h_sdram0_clock_clk          (ddr3_hps_f2h_sdram0_clock_clk),          // hps_f2h_sdram0_clock.clk
		.hps_f2h_sdram0_data_address       (ddr3_hps_f2h_sdram0_data_address),       //  hps_f2h_sdram0_data.address
		.hps_f2h_sdram0_data_read          (ddr3_hps_f2h_sdram0_data_read),          //                     .read
		.hps_f2h_sdram0_data_readdata      (ddr3_hps_f2h_sdram0_data_readdata),      //                     .readdata
		.hps_f2h_sdram0_data_write         (ddr3_hps_f2h_sdram0_data_write),         //                     .write
		.hps_f2h_sdram0_data_writedata     (ddr3_hps_f2h_sdram0_data_writedata),     //                     .writedata
		.hps_f2h_sdram0_data_readdatavalid (ddr3_hps_f2h_sdram0_data_readdatavalid), //                     .readdatavalid
		.hps_f2h_sdram0_data_waitrequest   (ddr3_hps_f2h_sdram0_data_waitrequest),   //                     .waitrequest
		.hps_f2h_sdram0_data_byteenable    (ddr3_hps_f2h_sdram0_data_byteenable),    //                     .byteenable
		.hps_f2h_sdram0_data_burstcount    (ddr3_hps_f2h_sdram0_data_burstcount),    //                     .burstcount
		.memory_mem_a                      (memory_mem_a),                           //               memory.mem_a
		.memory_mem_ba                     (memory_mem_ba),                          //                     .mem_ba
		.memory_mem_ck                     (memory_mem_ck),                          //                     .mem_ck
		.memory_mem_ck_n                   (memory_mem_ck_n),                        //                     .mem_ck_n
		.memory_mem_cke                    (memory_mem_cke),                         //                     .mem_cke
		.memory_mem_cs_n                   (memory_mem_cs_n),                        //                     .mem_cs_n
		.memory_mem_ras_n                  (memory_mem_ras_n),                       //                     .mem_ras_n
		.memory_mem_cas_n                  (memory_mem_cas_n),                       //                     .mem_cas_n
		.memory_mem_we_n                   (memory_mem_we_n),                        //                     .mem_we_n
		.memory_mem_reset_n                (memory_mem_reset_n),                     //                     .mem_reset_n
		.memory_mem_dq                     (memory_mem_dq),                          //                     .mem_dq
		.memory_mem_dqs                    (memory_mem_dqs),                         //                     .mem_dqs
		.memory_mem_dqs_n                  (memory_mem_dqs_n),                       //                     .mem_dqs_n
		.memory_mem_odt                    (memory_mem_odt),                         //                     .mem_odt
		.memory_mem_dm                     (memory_mem_dm),                          //                     .mem_dm
		.memory_oct_rzqin                  (memory_oct_rzqin)                        //                     .oct_rzqin
	);

	soc_system_pll pll (
		.refclk   (clk_clk),               //  refclk.clk
		.rst      (~ddr3_h2f_reset_reset), //   reset.reset
		.outclk_0 (ddr3_clk_clk),          // outclk0.clk
		.locked   ()                       // (terminated)
	);

endmodule
