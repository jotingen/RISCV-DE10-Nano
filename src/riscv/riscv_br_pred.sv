module riscv_br_pred (
  input  logic              clk,
  input  logic              rst,

  input  logic [31:0]       pre_ifu_PC,
  output logic              pre_ifu_br_pred_taken,
  output logic [31:0]       pre_ifu_br_pred_PC_next,

  input  logic              alu_vld,
  input  logic              alu_retired,
  input  logic              alu_br,
  input  logic              alu_br_taken,
  input  logic              alu_br_miss,
  input  logic [31:0]       alu_PC,
  input  logic [31:0]       alu_PC_next
);


logic        alu_br_match;
logic [3:0]  alu_br_match_ndx;

logic [15:0]       br_pred_vld;
logic [15:0][3:0]  br_pred_take;
logic [15:0][31:0] br_pred_PC;
logic [15:0][31:0] br_pred_PC_taken;

logic        br_pred_0_vld;
logic [3:0]  br_pred_0_take;
logic [31:0] br_pred_0_PC;
logic [31:0] br_pred_0_PC_taken;

logic        br_pred_1_vld;
logic [3:0]  br_pred_1_take;
logic [31:0] br_pred_1_PC;
logic [31:0] br_pred_1_PC_taken;

logic        br_pred_2_vld;
logic [3:0]  br_pred_2_take;
logic [31:0] br_pred_2_PC;
logic [31:0] br_pred_2_PC_taken;

logic        br_pred_3_vld;
logic [3:0]  br_pred_3_take;
logic [31:0] br_pred_3_PC;
logic [31:0] br_pred_3_PC_taken;

logic        br_pred_4_vld;
logic [3:0]  br_pred_4_take;
logic [31:0] br_pred_4_PC;
logic [31:0] br_pred_4_PC_taken;

logic        br_pred_5_vld;
logic [3:0]  br_pred_5_take;
logic [31:0] br_pred_5_PC;
logic [31:0] br_pred_5_PC_taken;

logic        br_pred_6_vld;
logic [3:0]  br_pred_6_take;
logic [31:0] br_pred_6_PC;
logic [31:0] br_pred_6_PC_taken;

logic        br_pred_7_vld;
logic [3:0]  br_pred_7_take;
logic [31:0] br_pred_7_PC;
logic [31:0] br_pred_7_PC_taken;

logic        br_pred_8_vld;
logic [3:0]  br_pred_8_take;
logic [31:0] br_pred_8_PC;
logic [31:0] br_pred_8_PC_taken;

logic        br_pred_9_vld;
logic [3:0]  br_pred_9_take;
logic [31:0] br_pred_9_PC;
logic [31:0] br_pred_9_PC_taken;

logic        br_pred_10_vld;
logic [3:0]  br_pred_10_take;
logic [31:0] br_pred_10_PC;
logic [31:0] br_pred_10_PC_taken;

logic        br_pred_11_vld;
logic [3:0]  br_pred_11_take;
logic [31:0] br_pred_11_PC;
logic [31:0] br_pred_11_PC_taken;

logic        br_pred_12_vld;
logic [3:0]  br_pred_12_take;
logic [31:0] br_pred_12_PC;
logic [31:0] br_pred_12_PC_taken;

logic        br_pred_13_vld;
logic [3:0]  br_pred_13_take;
logic [31:0] br_pred_13_PC;
logic [31:0] br_pred_13_PC_taken;

logic        br_pred_14_vld;
logic [3:0]  br_pred_14_take;
logic [31:0] br_pred_14_PC;
logic [31:0] br_pred_14_PC_taken;

logic        br_pred_15_vld;
logic [3:0]  br_pred_15_take;
logic [31:0] br_pred_15_PC;
logic [31:0] br_pred_15_PC_taken;

logic [3:0]        lru;
logic [0:0]        lru0;
logic [1:0]        lru1;
logic [3:0]        lru2;
logic [7:0]        lru3;
logic [0:0]        lru0_touch_next;
logic [1:0]        lru1_touch_next;
logic [3:0]        lru2_touch_next;
logic [7:0]        lru3_touch_next;
logic [0:0]        lru0_new_next;
logic [1:0]        lru1_new_next;
logic [3:0]        lru2_new_next;
logic [7:0]        lru3_new_next;

assign br_pred_0_vld       = br_pred_vld[0];      
assign br_pred_0_take      = br_pred_take[0];     
assign br_pred_0_PC        = br_pred_PC[0];       
assign br_pred_0_PC_taken  = br_pred_PC_taken[0]; 

assign br_pred_1_vld       = br_pred_vld[1];     
assign br_pred_1_take      = br_pred_take[1];    
assign br_pred_1_PC        = br_pred_PC[1];      
assign br_pred_1_PC_taken  = br_pred_PC_taken[1];

assign br_pred_2_vld       = br_pred_vld[2];     
assign br_pred_2_take      = br_pred_take[2];    
assign br_pred_2_PC        = br_pred_PC[2];      
assign br_pred_2_PC_taken  = br_pred_PC_taken[2];

assign br_pred_3_vld       = br_pred_vld[3];     
assign br_pred_3_take      = br_pred_take[3];    
assign br_pred_3_PC        = br_pred_PC[3];      
assign br_pred_3_PC_taken  = br_pred_PC_taken[3];

assign br_pred_4_vld       = br_pred_vld[4];     
assign br_pred_4_take      = br_pred_take[4];    
assign br_pred_4_PC        = br_pred_PC[4];      
assign br_pred_4_PC_taken  = br_pred_PC_taken[4];

assign br_pred_5_vld       = br_pred_vld[5];     
assign br_pred_5_take      = br_pred_take[5];    
assign br_pred_5_PC        = br_pred_PC[5];      
assign br_pred_5_PC_taken  = br_pred_PC_taken[5];

assign br_pred_6_vld       = br_pred_vld[6];     
assign br_pred_6_take      = br_pred_take[6];    
assign br_pred_6_PC        = br_pred_PC[6];      
assign br_pred_6_PC_taken  = br_pred_PC_taken[6];

assign br_pred_7_vld       = br_pred_vld[7];     
assign br_pred_7_take      = br_pred_take[7];    
assign br_pred_7_PC        = br_pred_PC[7];      
assign br_pred_7_PC_taken  = br_pred_PC_taken[7];

assign br_pred_8_vld       = br_pred_vld[8];     
assign br_pred_8_take      = br_pred_take[8];    
assign br_pred_8_PC        = br_pred_PC[8];      
assign br_pred_8_PC_taken  = br_pred_PC_taken[8];

assign br_pred_9_vld       = br_pred_vld[9];     
assign br_pred_9_take      = br_pred_take[9];    
assign br_pred_9_PC        = br_pred_PC[9];      
assign br_pred_9_PC_taken  = br_pred_PC_taken[9];

assign br_pred_10_vld      = br_pred_vld[10];     
assign br_pred_10_take     = br_pred_take[10];    
assign br_pred_10_PC       = br_pred_PC[10];      
assign br_pred_10_PC_taken = br_pred_PC_taken[10];

assign br_pred_11_vld      = br_pred_vld[11];     
assign br_pred_11_take     = br_pred_take[11];    
assign br_pred_11_PC       = br_pred_PC[11];      
assign br_pred_11_PC_taken = br_pred_PC_taken[11];

assign br_pred_12_vld      = br_pred_vld[12];     
assign br_pred_12_take     = br_pred_take[12];    
assign br_pred_12_PC       = br_pred_PC[12];      
assign br_pred_12_PC_taken = br_pred_PC_taken[12];

assign br_pred_13_vld      = br_pred_vld[13];     
assign br_pred_13_take     = br_pred_take[13];    
assign br_pred_13_PC       = br_pred_PC[13];      
assign br_pred_13_PC_taken = br_pred_PC_taken[13];

assign br_pred_14_vld      = br_pred_vld[14];     
assign br_pred_14_take     = br_pred_take[14];    
assign br_pred_14_PC       = br_pred_PC[14];      
assign br_pred_14_PC_taken = br_pred_PC_taken[14];

assign br_pred_15_vld      = br_pred_vld[15];     
assign br_pred_15_take     = br_pred_take[15];    
assign br_pred_15_PC       = br_pred_PC[15];      
assign br_pred_15_PC_taken = br_pred_PC_taken[15];

always_comb
  begin
  lru0_new_next = lru0;
  lru1_new_next = lru1;
  lru2_new_next = lru2;
  lru3_new_next = lru3;
  lru = '0;
  casex ({lru0,lru1,lru2,lru3})
    'b0_0?_0???_0???????: begin
                          lru = 'd0;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[0] = ~lru2[0];
                          lru3_new_next[0] = ~lru3[0];
                          end
    'b0_0?_0???_1???????: begin
                          lru = 'd1;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[0] = ~lru2[0];
                          lru3_new_next[0] = ~lru3[0];
                          end
    'b0_0?_1???_?0??????: begin
                          lru = 'd2;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[0] = ~lru2[0];
                          lru3_new_next[1] = ~lru3[1];
                          end
    'b0_0?_1???_?1??????: begin
                          lru = 'd3;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[0] = ~lru2[0];
                          lru3_new_next[1] = ~lru3[1];
                          end
    'b0_1?_?0??_??0?????: begin
                          lru = 'd4;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[1] = ~lru2[1];
                          lru3_new_next[2] = ~lru3[2];
                          end
    'b0_1?_?0??_??1?????: begin
                          lru = 'd5;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[1] = ~lru2[1];
                          lru3_new_next[2] = ~lru3[2];
                          end
    'b0_1?_?1??_???0????: begin
                          lru = 'd6;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[1] = ~lru2[1];
                          lru3_new_next[3] = ~lru3[3];
                          end
    'b0_1?_?1??_???1????: begin
                          lru = 'd7;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[0] = ~lru1[0];
                          lru2_new_next[1] = ~lru2[1];
                          lru3_new_next[3] = ~lru3[3];
                          end
    'b1_?0_??0?_????0???: begin
                          lru = 'd8;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[2] = ~lru2[2];
                          lru3_new_next[4] = ~lru3[4];
                          end
    'b1_?0_??0?_????1???: begin
                          lru = 'd9;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[2] = ~lru2[2];
                          lru3_new_next[4] = ~lru3[4];
                          end
    'b1_?0_??1?_?????0??: begin
                          lru = 'd10;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[2] = ~lru2[2];
                          lru3_new_next[5] = ~lru3[5];
                          end
    'b1_?0_??1?_?????1??: begin
                          lru = 'd11;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[2] = ~lru2[2];
                          lru3_new_next[5] = ~lru3[5];
                          end
    'b1_?1_???0_??????0?: begin
                          lru = 'd12;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[3] = ~lru2[3];
                          lru3_new_next[6] = ~lru3[6];
                          end
    'b1_?1_???0_??????1?: begin
                          lru = 'd13;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[3] = ~lru2[3];
                          lru3_new_next[6] = ~lru3[6];
                          end
    'b1_?1_???1_???????0: begin
                          lru = 'd14;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[3] = ~lru2[3];
                          lru3_new_next[7] = ~lru3[7];
                          end
    'b1_?1_???1_???????1: begin
                          lru = 'd15;
                          lru0_new_next[0] = ~lru0[0];
                          lru1_new_next[1] = ~lru1[1];
                          lru2_new_next[3] = ~lru2[3];
                          lru3_new_next[7] = ~lru3[7];
                          end
  endcase
  end

always_comb
  begin
  lru0_touch_next = lru0;
  lru1_touch_next = lru1;
  lru2_touch_next = lru2;
  lru3_touch_next = lru3;

  lru0_touch_next[alu_br_match_ndx/16] = ~((alu_br_match_ndx/8)%2);
  lru1_touch_next[alu_br_match_ndx/8]  = ~((alu_br_match_ndx/4)%2);
  lru2_touch_next[alu_br_match_ndx/4]  = ~((alu_br_match_ndx/2)%2);
  lru3_touch_next[alu_br_match_ndx/2]  = ~((alu_br_match_ndx/1)%2);
  end

always_comb
  begin
  pre_ifu_br_pred_taken = '0;
  pre_ifu_br_pred_PC_next  = '0;
  for(int i = 0; i < 16; i++)
    begin
    if(br_pred_vld[i] & br_pred_PC[i]==pre_ifu_PC)
      begin
      pre_ifu_br_pred_taken = |br_pred_take[i][1:0];
      pre_ifu_br_pred_PC_next  = br_pred_PC_taken[i];
      end
    end
  end

always_comb
  begin
  alu_br_match     = '0;
  alu_br_match_ndx = '0;
  if(alu_vld & alu_retired & alu_br)
    begin
    for(int i = 0; i < 16; i++)
      begin
      if(br_pred_vld[i] & br_pred_PC[i]==alu_PC)
        begin
        alu_br_match = '1;
        alu_br_match_ndx = i;
        end
      end
    end
  end

always_ff @(posedge clk)
  begin
  if(alu_vld & alu_retired & alu_br)
    begin
    if(alu_br_match)
      begin
      //Updates entry
      br_pred_PC_taken[alu_br_match_ndx] <= alu_PC_next;
      if(( alu_br_taken &  alu_br_miss) |
         (~alu_br_taken & ~alu_br_miss))
        begin
        unique
        case(br_pred_take[alu_br_match_ndx])
          4'b1000: br_pred_take[alu_br_match_ndx] <= 4'b1000;
          4'b0100: br_pred_take[alu_br_match_ndx] <= 4'b1000;
          4'b0010: br_pred_take[alu_br_match_ndx] <= 4'b0100;
          4'b0001: br_pred_take[alu_br_match_ndx] <= 4'b0010;
          default: br_pred_take[alu_br_match_ndx] <= 4'b0100;
        endcase
        end
      else
        begin
        unique
        case(br_pred_take[alu_br_match_ndx])
          4'b1000: br_pred_take[alu_br_match_ndx] <= 4'b0100;
          4'b0100: br_pred_take[alu_br_match_ndx] <= 4'b0010;
          4'b0010: br_pred_take[alu_br_match_ndx] <= 4'b0001;
          4'b0001: br_pred_take[alu_br_match_ndx] <= 4'b0001;
          default: br_pred_take[alu_br_match_ndx] <= 4'b0010;
        endcase
        end
      lru0 <= lru0_touch_next;
      lru1 <= lru1_touch_next;
      lru2 <= lru2_touch_next;
      lru3 <= lru3_touch_next;
      end
    else
      begin
      //Creates/replaces entry
      br_pred_vld[lru]      <= '1;
      br_pred_PC[lru]       <= alu_PC;
      br_pred_PC_taken[lru] <= alu_PC_next;
      if(( alu_br_taken &  alu_br_miss) |
         (~alu_br_taken & ~alu_br_miss))
        begin
        br_pred_take[lru] <= 4'b0100;
        end
      else
        begin
        br_pred_take[lru] <= 4'b0010;
        end
      lru0 <= lru0_new_next;
      lru1 <= lru1_new_next;
      lru2 <= lru2_new_next;
      lru3 <= lru3_new_next;
      end
    end


  if(rst)
    begin
    br_pred_vld      <= '0;
    br_pred_take     <= '0;
    br_pred_PC       <= '0;
    br_pred_PC_taken <= '0;
    
    lru0 <= '0;
    lru1 <= '0;
    lru2 <= '0;
    lru3 <= '0;
    end
  end

endmodule
