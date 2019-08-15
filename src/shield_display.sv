module shield_display (
  input  logic clk,
  input  logic rst,
  output logic inv,
  output logic SCK,
  output logic RS_DC,
  output logic DATA,
  output logic CS
);

typedef struct packed {
  logic cmd;
  logic [7:0] data;
} packet_t;
  
logic    req;
packet_t [3:0] packet;
logic    [1:0] packet_cnt;
//Driver
logic rdy;
logic [10:0] driver_state;
logic [10:0] driver_state_next;

//Clock boundary
logic clk_pulse;
logic [3:0] clk_pulse_cnt;
always_ff @(posedge clk)
  begin
  if(rst)
    begin
    clk_pulse <= '0;
    clk_pulse_cnt <= '0;
    end
  else
    begin
    case (clk_pulse_cnt)
      'd0:      begin
                clk_pulse_cnt <= clk_pulse_cnt + 1;
                clk_pulse <= '1;
                end
      default:  begin
                clk_pulse_cnt <= clk_pulse_cnt + 1;
                clk_pulse <= '0;
                end
    endcase
    end
  end

//Clock signal
logic [3:0] sck_cnt;
always_ff @(posedge clk)
  begin
  if(rst)
    begin
    SCK <= '0;
    sck_cnt <= '0;
    end
  else
    begin
    case (sck_cnt)
      'd0:      begin
                if(clk_pulse)
                  sck_cnt <= sck_cnt + 1;
                else
                  sck_cnt <= sck_cnt;
                SCK <= '0;
                end
      'd4,'d5,'d6,'d7,'d8,'d9,'d10:  
                begin
                sck_cnt <= sck_cnt + 1;
                SCK <= '1;
                end
      'd5:      begin
                sck_cnt <= sck_cnt + 1;
                SCK <= '0;
                end
      default:  begin
                sck_cnt <= sck_cnt + 1;
                SCK <= '0;
                end
    endcase
    end
  end

assign req = '1;
assign packet[0].cmd  = '1;
assign packet[0].data = 'h29; // DISPON (29h): Display On
assign packet[1].cmd  = '1;
assign packet[1].data = 'h11; //SLPOUT (11h): Sleep Out 
assign packet[2].cmd  = '1;
assign packet[2].data = 'h21; // INVON (21h): Display Inversion On 
assign packet[3].cmd  = '1;
assign packet[3].data = 'h20; // INVOFF (20h): Display Inversion Off 

logic [20:0] cooldown_cnt;
logic  [2:0] data_cnt;
always_ff @(posedge clk)
  begin
  CS       <= CS   ;
  RS_DC    <= RS_DC;
  DATA     <= DATA ;
  data_cnt <= data_cnt;
  cooldown_cnt <= cooldown_cnt;
  packet_cnt <= packet_cnt;
  inv <= inv;
  if(clk_pulse)
    begin
    integer unsigned packet_ndx;
    integer unsigned data_ndx;

    if(packet_cnt == 2'b00)
      packet_ndx = 0;
    if(packet_cnt == 2'b01)
      packet_ndx = 1;
    if(packet_cnt == 2'b10)
      packet_ndx = 2;
    if(packet_cnt == 2'b11)
      packet_ndx = 3;

    if(data_cnt == 3'b000)
      data_ndx = 7;
    if(data_cnt == 3'b001)
      data_ndx = 6;
    if(data_cnt == 3'b010)
      data_ndx = 5;
    if(data_cnt == 3'b011)
      data_ndx = 4;
    if(data_cnt == 3'b100)
      data_ndx = 3;
    if(data_cnt == 3'b101)
      data_ndx = 2;
    if(data_cnt == 3'b110)
      data_ndx = 1;
    if(data_cnt == 3'b111)
      data_ndx = 0;
    case (data_cnt)
      '0:       begin
                if(cooldown_cnt != 0)
                  begin
                  CS    <= '1;
                  cooldown_cnt <= cooldown_cnt - 1;
                  end
                else if(req)
                  begin
                  CS    <= '0;
                  RS_DC <= ~packet[packet_ndx].cmd;
                  DATA  <= packet[packet_ndx].data[data_ndx];
                  data_cnt <= data_cnt + 1;
                  cooldown_cnt <= 'd625000;
                  inv <= ~inv;
                  end
                else
                  begin
                  CS <= '1;
                  end
                end
      'd7:      begin
                DATA  <= packet[packet_ndx].data[data_ndx];
                data_cnt <= data_cnt + 1;
                if(packet_cnt==2'b11)
                  packet_cnt <= 2'b10;
                else
                  packet_cnt <= packet_cnt + 1;
                end
      default:  begin
                DATA  <= packet[packet_ndx].data[data_ndx];
                data_cnt <= data_cnt + 1;
                end
    endcase
    end
  if(rst)
    begin
    CS       <= '1;
    RS_DC    <= '0;
    DATA     <= '0;
    data_cnt <= '0;       
    cooldown_cnt <= 'd625000; //Power on with a cooldown timer 
    packet_cnt <= '0;
    inv <= '0;
    end
  end
          


//  logic [2:0] sck_cnt;
//  logic start;
//  
//  always_comb
//    begin
//    start = sck_cnt == '0;
//    end
//  
//  always_ff @(posedge clk)
//    begin
//    if(rst)
//      begin
//      SCK <= '0;
//      sck_cnt <= '0;
//      end
//    else if(clk_pulse)
//      begin
//      if(sck_cnt == 'd5)
//        begin
//        SCK <= '1;
//        sck_cnt <= '0;
//        end
//      else if(sck_cnt == 'd6)
//        begin
//        SCK <= '0;
//        sck_cnt <= '0;
//        end
//      else
//        begin
//        SCK <= '0;
//        sck_cnt <= sck_cnt + 1;
//        end
//      end
//    end
//  
//  //Every 200 cycles, flip inversion
//  //logic inv;
//  //logic [20:0] inv_cnt;
//  logic [3:0] inv_cnt;
//  
//  always_ff @(posedge clk)
//    begin
//    if(rst)
//      begin
//      inv <= '0;
//      inv_cnt <= '0;
//      end
//    else if(clk_pulse)
//      begin
//      if(start)
//        begin
//        if(inv_cnt == '1)
//          begin
//          inv <= ~inv;
//          inv_cnt <= '0;
//          end
//        else
//          begin
//          inv <= inv;
//          inv_cnt <= inv_cnt + 1;
//          end
//        end
//      else
//        begin
//        inv <= inv;
//        inv_cnt <= inv_cnt;
//        end
//      end
//    end
//      
//  //INVOFF 10.1.14 0 ? 1 - 0 0 1 0 0 0 0 0 (20h) Display inversion off
//  //INVON 10.1.15 0 ? 1 - 0 0 1 0 0 0 0 1 (21h) Display inversion on
//  
//  logic [11:0] state;
//  logic swreset;
//  
//  always_ff @(posedge clk)
//    begin
//    if(rst)
//      begin
//      state <= '0;
//      swreset <= '0;
//      CS    <= '1;
//      RS_DC <= '0;
//      DATA  <= '0;
//      end
//    else if(clk_pulse)
//      begin
//      case(state)
//        //Detect invert pulse
//        'd0 : begin
//              if(swreset == '0)
//                begin
//                swreset <= '1;
//                state <= 'd57;
//                end
//              else if(inv_cnt == '1)
//  	      state <= state + 1;
//              else
//  	      state <= state;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0; //7
//              end
//        //align to clock
//        'd1 : begin
//              if(sck_cnt == 'd5)
//                begin
//  	      state <= state + 1;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              else
//                begin
//  	      state <= state;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              end
//        'd2 : begin
//              state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;
//              end
//        'd3,'d4,'d5,'d6,'d7,'d8 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //7
//              end
//        'd9,'d10,'d11,'d12,'d13,'d14 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //6
//              end
//        'd15,'d16,'d17,'d18,'d19,'d20 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '1; //5
//              end
//        'd21,'d22,'d23,'d24,'d25,'d26 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //4
//              end
//        'd27,'d28,'d29,'d30,'d31,'d32 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //3
//              end
//        'd33,'d34,'d35,'d36,'d37,'d38 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //2
//              end
//        'd39,'d40,'d41,'d42,'d43,'d44 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //1
//              end
//        'd45,'d46,'d47,'d48,'d49,'d50 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              if(inv)
//                begin
//  	      DATA <= '0; //0
//                end
//              else   
//                begin
//  	      DATA <= '1; //0
//                end
//              end
//        'd51,'d52,'d53,'d54 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd55 : begin
//  	    state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd56 : begin
//  	    state <= '0;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        //SWRESET
//        //align to clock
//        'd57 : begin
//              if(sck_cnt == 'd5)
//                begin
//  	      state <= state + 1;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              else
//                begin
//  	      state <= state;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              end
//        'd58 : begin
//              state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;
//              end
//        'd59,'d60,'d61,'d62,'d63,'d64 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //7
//              end
//        'd65,'d66,'d67,'d68,'d69,'d70 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //6
//              end
//        'd71,'d72,'d73,'d74,'d75,'d76 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //5
//              end
//        'd77,'d78,'d79,'d80,'d81,'d82 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //4
//              end
//        'd83,'d84,'d85,'d86,'d87,'d88 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //3
//              end
//        'd89,'d90,'d91,'d92,'d93,'d94 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //2
//              end
//        'd95,'d96,'d97,'d98,'d99,'d100 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //1
//              end
//        'd101,'d102,'d103,'d104,'d105,'d106 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//  	    DATA <= '1; //0
//              end
//        'd107,'d108,'d109,'d110 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd111 : begin
//  	    state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd112 : begin
//  	    state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        //DISPON
//        //align to clock
//        'd113 : begin
//              if(sck_cnt == 'd5)
//                begin
//  	      state <= state + 1;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              else
//                begin
//  	      state <= state;
//                CS <= '1;
//                RS_DC <= '0;
//                DATA <= '0; 
//                end
//              end
//        'd114 : begin
//              state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;
//              end
//        'd115,'d116,'d117,'d118,'d119,'d120 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //7
//              end
//        'd121,'d122,'d123,'d124,'d125,'d126 : begin
//              state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //6
//              end
//        'd127,'d128,'d129,'d130,'d131,'d132 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '1; //5
//              end
//        'd133,'d134,'d135,'d136,'d137,'d138 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //4
//              end
//        'd139,'d140,'d141,'d142,'d143,'d144 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '1; //3
//              end
//        'd145,'d146,'d147,'d148,'d149,'d150 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //2
//              end
//        'd151,'d152,'d153,'d154,'d155,'d156 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0; //1
//              end
//        'd157,'d158,'d159,'d160,'d161,'d162 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//  	    DATA <= '1; //0
//              end
//        'd163,'d164,'d165,'d166 : begin
//  	    state <= state + 1;
//              CS <= '0;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd167 : begin
//  	    state <= state + 1;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        'd168 : begin
//  	    state <= '0;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//        default : begin
//  	    state <= '0;
//              CS <= '1;
//              RS_DC <= '0;
//              DATA <= '0;     
//              end
//      endcase
//      end
//    end
//  //sccb sccb (
//  //.clk_i(clk),
//  //.rstsw_i(rst),
//  //.SDA(RS_DC),
//  //.SCL(SCK)
//  //);

endmodule
