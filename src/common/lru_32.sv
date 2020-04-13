module lru_32 (
  input  logic              clk,
  input  logic              rst,

  input  logic              lru_touch,
  input  logic [4:0]        lru_touched,

  output logic [4:0]        lru
);


logic [3:0]        mru;
logic [0:0]        lru0;
logic [1:0]        lru1;
logic [3:0]        lru2;
logic [7:0]        lru3;
logic [15:0]       lru4;
logic [0:0]        lru0_touch_next;
logic [1:0]        lru1_touch_next;
logic [3:0]        lru2_touch_next;
logic [7:0]        lru3_touch_next;
logic [15:0]       lru4_touch_next;

always_comb
  begin
  mru = '0;
  casex ({lru0,lru1,lru2,lru3,lru4})
    'b0_?0_???0_???????0_???????????????0: begin
                                           mru = 'd31;
                                           end
    'b0_?0_???0_???????0_???????????????1: begin
                                           mru = 'd30;
                                           end
    'b0_?0_???0_???????1_??????????????0?: begin
                                           mru = 'd29;
                                           end
    'b0_?0_???0_???????1_??????????????1?: begin
                                           mru = 'd28;
                                           end
    'b0_?0_???1_??????0?_?????????????0??: begin
                                           mru = 'd27;
                                           end
    'b0_?0_???1_??????0?_?????????????1??: begin
                                           mru = 'd26;
                                           end
    'b0_?0_???1_??????1?_????????????0???: begin
                                           mru = 'd25;
                                           end
    'b0_?0_???1_??????1?_????????????1???: begin
                                           mru = 'd24;
                                           end
    'b0_?1_??0?_?????0??_???????????0????: begin
                                           mru = 'd23;
                                           end
    'b0_?1_??0?_?????0??_???????????1????: begin
                                           mru = 'd22;
                                           end
    'b0_?1_??0?_?????1??_??????????0?????: begin
                                           mru = 'd21;
                                           end
    'b0_?1_??0?_?????1??_??????????1?????: begin
                                           mru = 'd20;
                                           end
    'b0_?1_??1?_????0???_?????????0??????: begin
                                           mru = 'd19;
                                           end
    'b0_?1_??1?_????0???_?????????1??????: begin
                                           mru = 'd18;
                                           end
    'b0_?1_??1?_????1???_????????0???????: begin
                                           mru = 'd17;
                                           end
    'b0_?1_??1?_????1???_????????1???????: begin
                                           mru = 'd16;
                                           end
    'b1_0?_?0??_???0????_???????0????????: begin
                                           mru = 'd15;
                                           end
    'b1_0?_?0??_???0????_???????1????????: begin
                                           mru = 'd14;
                                           end
    'b1_0?_?0??_???1????_??????0?????????: begin
                                           mru = 'd13;
                                           end
    'b1_0?_?0??_???1????_??????1?????????: begin
                                           mru = 'd12;
                                           end
    'b1_0?_?1??_??0?????_?????0??????????: begin
                                           mru = 'd11;
                                           end
    'b1_0?_?1??_??0?????_?????1??????????: begin
                                           mru = 'd10;
                                           end
    'b1_0?_?1??_??1?????_????0???????????: begin
                                           mru = 'd9;
                                           end
    'b1_0?_?1??_??1?????_????1???????????: begin
                                           mru = 'd8;
                                           end
    'b1_1?_0???_?0??????_???0????????????: begin
                                           mru = 'd7;
                                           end
    'b1_1?_0???_?0??????_???1????????????: begin
                                           mru = 'd6;
                                           end
    'b1_1?_0???_?1??????_??0?????????????: begin
                                           mru = 'd5;
                                           end
    'b1_1?_0???_?1??????_??1?????????????: begin
                                           mru = 'd4;
                                           end
    'b1_1?_1???_0???????_?0??????????????: begin
                                           mru = 'd3;
                                           end
    'b1_1?_1???_0???????_?1??????????????: begin
                                           mru = 'd2;
                                           end
    'b1_1?_1???_1???????_0???????????????: begin
                                           mru = 'd1;
                                           end
    'b1_1?_1???_1???????_1???????????????: begin
                                           mru = 'd0;
                                           end
  endcase
  end
always_comb
  begin
  lru = '0;
  casex ({lru0,lru1,lru2,lru3,lru4})
    'b0_?0_???0_???????0_???????????????0: begin
                                           lru = 'd0;
                                           end
    'b0_?0_???0_???????0_???????????????1: begin
                                           lru = 'd1;
                                           end
    'b0_?0_???0_???????1_??????????????0?: begin
                                           lru = 'd2;
                                           end
    'b0_?0_???0_???????1_??????????????1?: begin
                                           lru = 'd3;
                                           end
    'b0_?0_???1_??????0?_?????????????0??: begin
                                           lru = 'd4;
                                           end
    'b0_?0_???1_??????0?_?????????????1??: begin
                                           lru = 'd5;
                                           end
    'b0_?0_???1_??????1?_????????????0???: begin
                                           lru = 'd6;
                                           end
    'b0_?0_???1_??????1?_????????????1???: begin
                                           lru = 'd7;
                                           end
    'b0_?1_??0?_?????0??_???????????0????: begin
                                           lru = 'd8;
                                           end
    'b0_?1_??0?_?????0??_???????????1????: begin
                                           lru = 'd9;
                                           end
    'b0_?1_??0?_?????1??_??????????0?????: begin
                                           lru = 'd10;
                                           end
    'b0_?1_??0?_?????1??_??????????1?????: begin
                                           lru = 'd11;
                                           end
    'b0_?1_??1?_????0???_?????????0??????: begin
                                           lru = 'd12;
                                           end
    'b0_?1_??1?_????0???_?????????1??????: begin
                                           lru = 'd13;
                                           end
    'b0_?1_??1?_????1???_????????0???????: begin
                                           lru = 'd14;
                                           end
    'b0_?1_??1?_????1???_????????1???????: begin
                                           lru = 'd15;
                                           end
    'b1_0?_?0??_???0????_???????0????????: begin
                                           lru = 'd16;
                                           end
    'b1_0?_?0??_???0????_???????1????????: begin
                                           lru = 'd17;
                                           end
    'b1_0?_?0??_???1????_??????0?????????: begin
                                           lru = 'd18;
                                           end
    'b1_0?_?0??_???1????_??????1?????????: begin
                                           lru = 'd19;
                                           end
    'b1_0?_?1??_??0?????_?????0??????????: begin
                                           lru = 'd20;
                                           end
    'b1_0?_?1??_??0?????_?????1??????????: begin
                                           lru = 'd21;
                                           end
    'b1_0?_?1??_??1?????_????0???????????: begin
                                           lru = 'd22;
                                           end
    'b1_0?_?1??_??1?????_????1???????????: begin
                                           lru = 'd23;
                                           end
    'b1_1?_0???_?0??????_???0????????????: begin
                                           lru = 'd24;
                                           end
    'b1_1?_0???_?0??????_???1????????????: begin
                                           lru = 'd25;
                                           end
    'b1_1?_0???_?1??????_??0?????????????: begin
                                           lru = 'd26;
                                           end
    'b1_1?_0???_?1??????_??1?????????????: begin
                                           lru = 'd27;
                                           end
    'b1_1?_1???_0???????_?0??????????????: begin
                                           lru = 'd28;
                                           end
    'b1_1?_1???_0???????_?1??????????????: begin
                                           lru = 'd29;
                                           end
    'b1_1?_1???_1???????_0???????????????: begin
                                           lru = 'd30;
                                           end
    'b1_1?_1???_1???????_1???????????????: begin
                                           lru = 'd31;
                                           end
  endcase
  end

always_comb
  begin
  lru0_touch_next = lru0;
  lru1_touch_next = lru1;
  lru2_touch_next = lru2;
  lru3_touch_next = lru3;
  lru4_touch_next = lru3;
  if(lru_touched != mru)
    begin
    casex(lru_touched)
      'd0:  begin
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '1;
            lru3_touch_next[0] = '1;
            lru4_touch_next[0] = '1;
            end                     
      'd1:  begin
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '1;
            lru3_touch_next[0] = '1;
            lru4_touch_next[0] = '0;
            end                     
      'd2:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '1;
            lru3_touch_next[0] = '0;
            lru4_touch_next[1] = '1;
            end                     
      'd3:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '1;
            lru3_touch_next[0] = '0;
            lru4_touch_next[1] = '0;
            end                     
      'd4:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '0;
            lru3_touch_next[1] = '1;
            lru4_touch_next[2] = '1;
            end                     
      'd5:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '0;
            lru3_touch_next[1] = '1;
            lru4_touch_next[2] = '0;
            end                     
      'd6:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '0;
            lru3_touch_next[1] = '0;
            lru4_touch_next[3] = '1;
            end                     
      'd7:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '1;
            lru2_touch_next[0] = '0;
            lru3_touch_next[1] = '0;
            lru4_touch_next[3] = '0;
            end                     
      'd8:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '1;
            lru3_touch_next[2] = '1;
            lru4_touch_next[4] = '1;
            end                     
      'd9:  begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '1;
            lru3_touch_next[2] = '1;
            lru4_touch_next[4] = '0;
            end                     
      'd10: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '1;
            lru3_touch_next[2] = '0;
            lru4_touch_next[5] = '1;
            end                     
      'd11: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '1;
            lru3_touch_next[2] = '0;
            lru4_touch_next[5] = '0;
            end                     
      'd12: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '0;
            lru3_touch_next[3] = '1;
            lru4_touch_next[6] = '1;
            end                     
      'd13: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '0;
            lru3_touch_next[3] = '1;
            lru4_touch_next[6] = '0;
            end                     
      'd14: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '0;
            lru3_touch_next[3] = '0;
            lru4_touch_next[7] = '1;
            end                     
      'd15: begin                   
            lru0_touch_next[0] = '1;
            lru1_touch_next[0] = '0;
            lru2_touch_next[1] = '0;
            lru3_touch_next[3] = '0;
            lru4_touch_next[7] = '0;
            end                     
      'd16: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '1;
            lru3_touch_next[4] = '1;
            lru4_touch_next[8] = '1;
            end                     
      'd17: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '1;
            lru3_touch_next[4] = '1;
            lru4_touch_next[8] = '0;
            end                     
      'd18: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '1;
            lru3_touch_next[4] = '0;
            lru4_touch_next[9] = '1;
            end                     
      'd19: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '1;
            lru3_touch_next[4] = '0;
            lru4_touch_next[9] = '0;
            end                     
      'd20: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '0;
            lru3_touch_next[5] = '1;
            lru4_touch_next[10] = '1;
            end                     
      'd21: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '0;
            lru3_touch_next[5] = '1;
            lru4_touch_next[10] = '0;
            end                     
      'd22: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '0;
            lru3_touch_next[5] = '0;
            lru4_touch_next[11] = '1;
            end                     
      'd23: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '1;
            lru2_touch_next[2] = '0;
            lru3_touch_next[5] = '0;
            lru4_touch_next[11] = '0;
            end                     
      'd24: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '1;
            lru3_touch_next[6] = '1;
            lru4_touch_next[12] = '1;
            end                     
      'd25: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '1;
            lru3_touch_next[6] = '1;
            lru4_touch_next[12] = '0;
            end                     
      'd26: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '1;
            lru3_touch_next[6] = '0;
            lru4_touch_next[13] = '1;
            end                     
      'd27: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '1;
            lru3_touch_next[6] = '0;
            lru4_touch_next[13] = '0;
            end                     
      'd28: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '0;
            lru3_touch_next[7] = '1;
            lru4_touch_next[14] = '1;
            end                     
      'd29: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '0;
            lru3_touch_next[7] = '1;
            lru4_touch_next[14] = '0;
            end                     
      'd30: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '0;
            lru3_touch_next[7] = '0;
            lru4_touch_next[15] = '1;
            end
      'd31: begin                   
            lru0_touch_next[0] = '0;
            lru1_touch_next[1] = '0;
            lru2_touch_next[3] = '0;
            lru3_touch_next[7] = '0;
            lru4_touch_next[15] = '0;
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
    lru4 <= lru4_touch_next;
    end
  else
    begin
    lru0 <= lru0;
    lru1 <= lru1;
    lru2 <= lru2;
    lru3 <= lru3;
    lru4 <= lru4;
    end


  if(rst)
    begin
    lru0 <= '0;
    lru1 <= '0;
    lru2 <= '0;
    lru3 <= '0;
    lru4 <= '0;
    end
  end

endmodule
