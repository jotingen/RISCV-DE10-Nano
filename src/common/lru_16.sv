module lru_16 (
  input  logic              clk,
  input  logic              rst,

  input  logic              lru_touch,
  input  logic [3:0]        lru_touched,

  output logic [3:0]        lru
);


logic [3:0]        mru;
logic [0:0]        lru0;
logic [1:0]        lru1;
logic [3:0]        lru2;
logic [7:0]        lru3;
logic [0:0]        lru0_touch_next;
logic [1:0]        lru1_touch_next;
logic [3:0]        lru2_touch_next;
logic [7:0]        lru3_touch_next;

always_comb
  begin
  mru = '0;
  casex ({lru0,lru1,lru2,lru3})
    'b0_?0_???0_???????0: begin
                          mru = 'd15;
                          end
    'b0_?0_???0_???????1: begin
                          mru = 'd14;
                          end
    'b0_?0_???1_??????0?: begin
                          mru = 'd13;
                          end
    'b0_?0_???1_??????1?: begin
                          mru = 'd12;
                          end
    'b0_?1_??0?_?????0??: begin
                          mru = 'd11;
                          end
    'b0_?1_??0?_?????1??: begin
                          mru = 'd10;
                          end
    'b0_?1_??1?_????0???: begin
                          mru = 'd9;
                          end
    'b0_?1_??1?_????1???: begin
                          mru = 'd8;
                          end
    'b1_0?_?0??_???0????: begin
                          mru = 'd7;
                          end
    'b1_0?_?0??_???1????: begin
                          mru = 'd6;
                          end
    'b1_0?_?1??_??0?????: begin
                          mru = 'd5;
                          end
    'b1_0?_?1??_??1?????: begin
                          mru = 'd4;
                          end
    'b1_1?_0???_?0??????: begin
                          mru = 'd3;
                          end
    'b1_1?_0???_?1??????: begin
                          mru = 'd2;
                          end
    'b1_1?_1???_0???????: begin
                          mru = 'd1;
                          end
    'b1_1?_1???_1???????: begin
                          mru = 'd0;
                          end
  endcase
  end
always_comb
  begin
  lru = '0;
  casex ({lru0,lru1,lru2,lru3})
    'b0_?0_???0_???????0: begin
                          lru = 'd0;
                          end
    'b0_?0_???0_???????1: begin
                          lru = 'd1;
                          end
    'b0_?0_???1_??????0?: begin
                          lru = 'd2;
                          end
    'b0_?0_???1_??????1?: begin
                          lru = 'd3;
                          end
    'b0_?1_??0?_?????0??: begin
                          lru = 'd4;
                          end
    'b0_?1_??0?_?????1??: begin
                          lru = 'd5;
                          end
    'b0_?1_??1?_????0???: begin
                          lru = 'd6;
                          end
    'b0_?1_??1?_????1???: begin
                          lru = 'd7;
                          end
    'b1_0?_?0??_???0????: begin
                          lru = 'd8;
                          end
    'b1_0?_?0??_???1????: begin
                          lru = 'd9;
                          end
    'b1_0?_?1??_??0?????: begin
                          lru = 'd10;
                          end
    'b1_0?_?1??_??1?????: begin
                          lru = 'd11;
                          end
    'b1_1?_0???_?0??????: begin
                          lru = 'd12;
                          end
    'b1_1?_0???_?1??????: begin
                          lru = 'd13;
                          end
    'b1_1?_1???_0???????: begin
                          lru = 'd14;
                          end
    'b1_1?_1???_1???????: begin
                          lru = 'd15;
                          end
  endcase
  end

always_comb
  begin
  lru0_touch_next = lru0;
  lru1_touch_next = lru1;
  lru2_touch_next = lru2;
  lru3_touch_next = lru3;
  if(lru_touched != mru)
    begin
    casex(lru_touched)
      'd0:  begin
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '1; //~lru1[0];
            lru2_touch_next[0] = '1; //~lru2[0];
            lru3_touch_next[0] = '1; //~lru3[0];
            end                           
      'd1:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '1; //~lru1[0];
            lru2_touch_next[0] = '1; //~lru2[0];
            lru3_touch_next[0] = '0; //~lru3[0];
            end                           
      'd2:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '1; //~lru1[0];
            lru2_touch_next[0] = '0; //~lru2[0];
            lru3_touch_next[1] = '1; //~lru3[1];
            end                           
      'd3:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '1; //~lru1[0];
            lru2_touch_next[0] = '0; //~lru2[0];
            lru3_touch_next[1] = '0; //~lru3[1];
            end                           
      'd4:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '0; //~lru1[0];
            lru2_touch_next[1] = '1; //~lru2[1];
            lru3_touch_next[2] = '1; //~lru3[2];
            end                           
      'd5:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '0; //~lru1[0];
            lru2_touch_next[1] = '1; //~lru2[1];
            lru3_touch_next[2] = '0; //~lru3[2];
            end                           
      'd6:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '0; //~lru1[0];
            lru2_touch_next[1] = '0; //~lru2[1];
            lru3_touch_next[3] = '1; //~lru3[3];
            end                           
      'd7:  begin                         
            lru0_touch_next[0] = '1; //~lru0[0];
            lru1_touch_next[0] = '0; //~lru1[0];
            lru2_touch_next[1] = '0; //~lru2[1];
            lru3_touch_next[3] = '0; //~lru3[3];
            end                           
      'd8:  begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '1; //~lru1[1];
            lru2_touch_next[2] = '1; //~lru2[2];
            lru3_touch_next[4] = '1; //~lru3[4];
            end                           
      'd9:  begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '1; //~lru1[1];
            lru2_touch_next[2] = '1; //~lru2[2];
            lru3_touch_next[4] = '0; //~lru3[4];
            end                           
      'd10: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '1; //~lru1[1];
            lru2_touch_next[2] = '0; //~lru2[2];
            lru3_touch_next[5] = '1; //~lru3[5];
            end                           
      'd11: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '1; //~lru1[1];
            lru2_touch_next[2] = '0; //~lru2[2];
            lru3_touch_next[5] = '0; //~lru3[5];
            end                           
      'd12: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '0; //~lru1[1];
            lru2_touch_next[3] = '1; //~lru2[3];
            lru3_touch_next[6] = '1; //~lru3[6];
            end                           
      'd13: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '0; //~lru1[1];
            lru2_touch_next[3] = '1; //~lru2[3];
            lru3_touch_next[6] = '0; //~lru3[6];
            end                           
      'd14: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '0; //~lru1[1];
            lru2_touch_next[3] = '0; //~lru2[3];
            lru3_touch_next[7] = '1; //~lru3[7];
            end                           
      'd15: begin                         
            lru0_touch_next[0] = '0; //~lru0[0];
            lru1_touch_next[1] = '0; //~lru1[1];
            lru2_touch_next[3] = '0; //~lru2[3];
            lru3_touch_next[7] = '0; //~lru3[7];
            end
    endcase
  end

  end

always_ff @(posedge clk)
  begin
  if(lru_touch)
    begin
    lru0 <= lru0_touch_next;
    lru1 <= lru1_touch_next;
    lru2 <= lru2_touch_next;
    lru3 <= lru3_touch_next;
    end
  else
    begin
    lru0 <= lru0;
    lru1 <= lru1;
    lru2 <= lru2;
    lru3 <= lru3;
    end


  if(rst)
    begin
    lru0 <= '0;
    lru1 <= '0;
    lru2 <= '0;
    lru3 <= '0;
    end
  end

endmodule
