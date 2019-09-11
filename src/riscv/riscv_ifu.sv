
module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  input  logic             alu_vld,
  input  logic             alu_br_miss,
  input  logic [31:0]      PC_in,

  output logic             ifu_vld,
  output logic [31:0]      ifu_inst,
  output logic [31:0]      ifu_inst_PC,

  output logic             o_instbus_req,
  output logic             o_instbus_write,
  output logic [31:0]      o_instbus_addr,
  output logic [31:0]      o_instbus_data,

  input  logic             i_instbus_ack,
  input  logic [31:0]      i_instbus_addr,
  input  logic [31:0]      i_instbus_data

);

logic init;
logic [31:0] PC;
logic [31:0] PC_next;
always_ff @(posedge clk)
  begin
  init <= init;

  PC_next <= PC + 'd4;
  if(alu_vld & alu_br_miss)
    PC_next <= PC_in;
  PC <= PC;

  o_instbus_req <= '0;
  o_instbus_write <= o_instbus_write;
  o_instbus_addr  <= o_instbus_addr;
  o_instbus_data  <= o_instbus_data;

  ifu_vld <= '0;
  ifu_inst <= ifu_inst;
  ifu_inst_PC <= ifu_inst_PC;

	//Send out recieved instruction
  if(i_instbus_ack)
    begin
    ifu_vld <= '1;
    if(alu_br_miss)
      ifu_vld <= '0;
	  ifu_inst <= i_instbus_data;
    ifu_inst_PC <= i_instbus_addr;
    end

  if(alu_vld)
    begin
    if(i_instbus_ack | init)
      begin
      init <= '0;
      o_instbus_req <= '1;
      o_instbus_write <= '0;
      if(alu_br_miss)
        o_instbus_addr <= PC;
      else
        o_instbus_addr <= PC_in;
      o_instbus_data <= '0;
      PC <= PC_next;
      end
    end
  else
    begin
    //Reset init if we get response from memory but pipe is frozen
    if(i_instbus_ack)
      begin
      init <= '1;
      end
    end

  if(rst)
    begin
    init <= '1;

		PC <= '0;

    ifu_vld <= '0;
    ifu_inst <= '0;
    ifu_inst_PC <= '0;

    o_instbus_req <= '0;
    o_instbus_write <= '0;
    o_instbus_addr <= '0;
    o_instbus_data <= '0;
    end
  end


endmodule
