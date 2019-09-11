module rvfi_wrapper (
	input         clock,
	input         reset,
	`RVFI_OUTPUTS
);
	(* keep *) `rvformal_rand_reg        inst_ready;
	(* keep *) `rvformal_rand_reg [31:0] inst_rdata;

	(* keep *) wire        inst_valid;
	(* keep *) wire        inst_instr;
	(* keep *) wire [31:0] inst_addr;
	(* keep *) wire [31:0] inst_wdata;
	(* keep *) wire [3:0]  inst_wstrb;

	(* keep *) `rvformal_rand_reg        mem_ready;
	(* keep *) `rvformal_rand_reg [31:0] mem_rdata;

	(* keep *) wire        mem_valid;
	(* keep *) wire        mem_instr;
	(* keep *) wire [31:0] mem_addr;
	(* keep *) wire [31:0] mem_wdata;
	(* keep *) wire [3:0]  mem_wstrb;

	riscv uut (
		.clk        (clock    ),
		.rst        (reset    ),

		.o_instbus_req  (inst_valid),
		.i_instbus_ack  (inst_ready),
		.o_instbus_addr (inst_addr ),
		.o_instbus_data (inst_wdata),
		.i_instbus_data (inst_rdata),

		.o_membus_req  (mem_valid),
		.i_membus_ack  (mem_ready),
		.o_membus_addr (mem_addr ),
		.o_membus_data (mem_wdata),
		.i_membus_data (mem_rdata),

		`RVFI_CONN
	);

endmodule

