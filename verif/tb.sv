`timescale 100ps / 100ps
module tb ();

//////////// CLOCK //////////
logic           FPGA_CLK1_50;
logic           FPGA_CLK2_50;
logic           FPGA_CLK3_50;

//////////// LED //////////
logic  [7:0]    LED;

//////////// KEY //////////
logic  [1:0]    KEY;

//////////// SW //////////
logic  [3:0]    SW;

//////////// ADC //////////
logic           ADC_CONVST;
logic           ADC_SCK;
logic           ADC_SDI;
logic           ADC_SDO;

//////////// ARDUINO //////////
logic  [15:0]   ARDUINO_IO;
logic            ARDUINO_RESET_N;

//////////// HDMI //////////
logic           HDMI_I2C_SCL;
logic           HDMI_I2C_SDA;
logic           HDMI_I2S;
logic           HDMI_LRCLK;
logic           HDMI_MCLK;
logic           HDMI_SCLK;
logic           HDMI_TX_CLK;
logic           HDMI_TX_DE;
logic  [23:0]   HDMI_TX_D;
logic           HDMI_TX_HS;
logic           HDMI_TX_INT;
logic           HDMI_TX_VS;

logic reset_en;
logic reset_n;

assign ARDUINO_RESET_N = (reset_en)? reset_n : 'hz;

de10nano dut (

//////////// CLOCK //////////
.FPGA_CLK1_50,
.FPGA_CLK2_50,
.FPGA_CLK3_50,

//////////// LED //////////
.LED,

//////////// KEY //////////
.KEY,

//////////// SW //////////
.SW,

//////////// ADC //////////
.ADC_CONVST,
.ADC_SCK,
.ADC_SDI,
.ADC_SDO,

//////////// ARDUINO //////////
.ARDUINO_IO,
.ARDUINO_RESET_N,

//////////// HDMI //////////
.HDMI_I2C_SCL,
.HDMI_I2C_SDA,
.HDMI_I2S,
.HDMI_LRCLK,
.HDMI_MCLK,
.HDMI_SCLK,
.HDMI_TX_CLK,
.HDMI_TX_DE,
.HDMI_TX_D,
.HDMI_TX_HS,
.HDMI_TX_INT,
.HDMI_TX_VS

);

initial
  begin
    $readmemh("../../tests/timer_3.v", dut.mem.mem_array_3);
    $readmemh("../../tests/timer_2.v", dut.mem.mem_array_2);
    $readmemh("../../tests/timer_1.v", dut.mem.mem_array_1);
    $readmemh("../../tests/timer_0.v", dut.mem.mem_array_0);
  end

initial 
  begin 
  FPGA_CLK1_50 = 0; 
  FPGA_CLK2_50 = 0; 
  FPGA_CLK3_50 = 0; 
  reset_en = '1;
  reset_n = '1;
  #200
  reset_n = '0;
  #2000
  reset_n = '1;
//  ARDUINO_RESET_N = 0; 
  end 
    
always 
  begin
  #100  
  FPGA_CLK1_50 =  ! FPGA_CLK1_50;
  FPGA_CLK2_50 =  ! FPGA_CLK2_50;
  FPGA_CLK3_50 =  ! FPGA_CLK3_50;
  end

final
  begin
  for(int addr = 0; addr < $size(dut.mem.mem_array_0); addr++)
    begin
    logic [31:0] data;
    typedef struct packed {
      logic  [6:0] funct7;
      logic  [4:0] rs2;
      logic  [4:0] rs1;
      logic  [2:0] funct3;
      logic  [4:0] rd;
      logic  [6:0] opcode;
    } inst_RType_s;
    typedef struct packed {
      logic [11:0] imm_11_0;
      logic  [4:0] rs1;
      logic  [2:0] funct3;
      logic  [4:0] rd;
      logic  [6:0] opcode;
    } inst_IType_s;
    typedef struct packed {
      logic  [6:0] imm_11_5;
      logic  [4:0] rs2;
      logic  [4:0] rs1;
      logic  [2:0] funct3;
      logic  [4:0] imm_4_0;
      logic  [6:0] opcode;
    } inst_SType_s;
    typedef struct packed {
      logic        imm_12;
      logic  [5:0] imm_10_5;
      logic  [4:0] rs2;
      logic  [4:0] rs1;
      logic  [2:0] funct3;
      logic  [3:0] imm_4_1;
      logic        imm_11;
      logic  [6:0] opcode;
    } inst_BType_s;
    typedef struct packed {
      logic [19:0] imm_31_12;
      logic  [4:0] rd;
      logic  [6:0] opcode;
    } inst_UType_s;
    typedef struct packed {
      logic        imm_20;
      logic  [9:0] imm_10_1;
      logic        imm_11;
      logic  [7:0] imm_19_12;
      logic  [4:0] rd;
      logic  [6:0] opcode;
    } inst_JType_s;
    inst_RType_s inst_R;
    inst_IType_s inst_I;
    inst_SType_s inst_S;
    inst_BType_s inst_B;
    inst_UType_s inst_U;
    inst_JType_s inst_J;
    string assembly;
     
    data = {dut.mem.mem_array_3[addr],
            dut.mem.mem_array_2[addr],
            dut.mem.mem_array_1[addr],
            dut.mem.mem_array_0[addr]};

    inst_R  = data;
    inst_I  = data;
    inst_S  = data;
    inst_B  = data;
    inst_U  = data;
    inst_J  = data;

    case (data[6:0])
      'b0110111 : assembly = $sformatf("%5s r%1d,0x%1x", "LUI", inst_U.rd, inst_U.imm_31_12);
      'b0010111 : assembly = $sformatf("%5s r%1d,0x%1x", "AUIPC", inst_U.rd, inst_U.imm_31_12);
      'b1101111 : assembly = $sformatf("%5s r%1d,0x%1x", "JAL", inst_J.rd, {inst_J.imm_20,inst_J.imm_19_12,inst_J.imm_11,inst_J.imm_10_1});
      'b1100111 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "JALR", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
      'b1100011 : begin 
                  case (inst_B.funct3)
                    'b000 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BEQ", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                    'b001 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BNE", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                    'b100 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BLT", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                    'b101 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BGE", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                    'b110 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BLTU", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                    'b111 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "BGEU", inst_B.rs1, inst_B.rs2, {inst_B.imm_12,inst_B.imm_11,inst_B.imm_10_5,inst_B.imm_4_1});
                  endcase
                  end
      'b0000011 : begin     
                  case (inst_I.funct3)
                    'b000 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "LB", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b001 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "LH", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b010 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "LW", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b100 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "LBU", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b101 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "LHU", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                  endcase
                  end
      'b0100011 : begin 
                  case (inst_S.funct3)
                    'b000 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "SB", inst_S.rs1, inst_S.rs2, {inst_S.imm_11_5, inst_S.imm_4_0});
                    'b001 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "SH", inst_S.rs1, inst_S.rs2, {inst_S.imm_11_5, inst_S.imm_4_0});
                    'b010 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "SW", inst_S.rs1, inst_S.rs2, {inst_S.imm_11_5, inst_S.imm_4_0});
                  endcase
                  end
      'b0010011 : begin 
                  case (inst_I.funct3)
                    'b000 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "ADDI", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b010 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "SLTI", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b011 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "SLTIU", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b100 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "XORI", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b110 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "ORI", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b111 : assembly = $sformatf("%5s r%1d,r%1d,0x%1x", "ANDI", inst_I.rd, inst_I.rs1, inst_I.imm_11_0);
                    'b001 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SLLI", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b101 : begin 
                            case (inst_R.funct7)
                              'b0000000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SRLI", inst_R.rd, inst_R.rs1, inst_R.rs2);
                              'b0100000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SRAI", inst_R.rd, inst_R.rs1, inst_R.rs2);
                            endcase
                            end
                  endcase
                  end
      'b0110011 : begin 
                  case (inst_R.funct3)
                    'b000 : begin 
                            case (inst_R.funct7)
                              'b0000000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "ADD", inst_R.rd, inst_R.rs1, inst_R.rs2);
                              'b0100000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SUB", inst_R.rd, inst_R.rs1, inst_R.rs2);
                            endcase
                            end
                    'b001 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SLL", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b010 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SLT", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b011 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SLTU", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b100 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "XOR", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b101 : begin 
                            case (inst_R.funct7)
                              'b0000000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SRL", inst_R.rd, inst_R.rs1, inst_R.rs2);
                              'b0100000 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "SRA", inst_R.rd, inst_R.rs1, inst_R.rs2);
                            endcase
                            end
                    'b110 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "OR", inst_R.rd, inst_R.rs1, inst_R.rs2);
                    'b111 : assembly = $sformatf("%5s r%1d,r%1d,r%1d", "AND", inst_R.rd, inst_R.rs1, inst_R.rs2);
                  endcase
                  end
      'b0001111 : assembly = $sformatf("%5s r%1d, %4b, %4b, %4b", "FENCE", inst_I.rd, inst_I.rs1, inst_I.imm_11_0[3:0], inst_I.imm_11_0[7:0], inst_I.imm_11_0[11:8]);
      'b1110011 : assembly = "ECALL TODO";
      'b1110011 : assembly = "EBREAK TODO";
      default   : assembly = "-----";
    endcase


    if(data !== 32'hxxxxxxxx)
      $display("(%6d)0x%08x: %08x %s", addr*4, addr*4, data, assembly);
    end                                                            
  end                                                              

endmodule
