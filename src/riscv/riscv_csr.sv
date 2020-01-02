module riscv_csr (
  input  logic              clk,
  input  logic              rst,

  input  logic              alu_vld,
  input  logic              alu_retired,
  input  logic              alu_br,
  input  logic              alu_br_miss,

  input  logic           csr_req,
  output logic           csr_ack,
  input  logic           csr_write,
  input  logic [31:0]    csr_addr,
  input  logic [31:0]    csr_mask,
  input  logic [31:0]    csr_data_wr,
  output logic [31:0]    csr_data_rd
);

logic [31:0] csr_C00;
logic [31:0] csr_C80;

logic [31:0] time_counter;
logic [31:0] csr_C01;
logic [31:0] csr_C81;

logic [31:0] csr_C02;
logic [31:0] csr_C82;

logic [31:0] csr_C03;
logic [31:0] csr_C83;

logic [31:0] csr_C04;
logic [31:0] csr_C84;


always_ff @(posedge clk)
  begin
  csr_ack  <= '0;
  csr_data_rd <= '0;

  //Counter
  {csr_C80,csr_C00} <= {csr_C80,csr_C00}+'d1;

  //Time
  if(time_counter >= 'd50000) //Tied to 50 MHz 
    begin 
    {csr_C81,csr_C01} <= {csr_C81,csr_C01}+'d1;
    end 
  else
    begin
    {csr_C81,csr_C01} <= {csr_C81,csr_C01};
    end 
  if(time_counter >= 50000) 
    begin
    time_counter <= '0;
    end
  else
    begin
    time_counter <= time_counter + 'd1;
    end

  //Instructions Retired
  if (alu_vld & alu_retired)
    begin 
    {csr_C82,csr_C02} <= {csr_C82,csr_C02}+'d1;
    end 
  else
    begin
    {csr_C82,csr_C02} <= {csr_C82,csr_C02};
    end 

  //Instructions Branch Type
  if (alu_vld & alu_retired & alu_br)
    begin 
    {csr_C83,csr_C03} <= {csr_C83,csr_C03}+'d1;
    end 
  else
    begin
    {csr_C83,csr_C03} <= {csr_C83,csr_C03};
    end 

  //Instructions Branch Missed
  if (alu_vld & alu_retired & alu_br_miss)
    begin 
    {csr_C84,csr_C04} <= {csr_C84,csr_C04}+'d1;
    end 
  else
    begin
    {csr_C84,csr_C04} <= {csr_C84,csr_C04};
    end 


  if(csr_req & ~csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC00: begin
             csr_data_rd <= csr_C00;
             end
      'hC01: begin
             csr_data_rd <= csr_C01;
             end
      'hC02: begin
             csr_data_rd <= csr_C02;
             end
      'hC03: begin
             csr_data_rd <= csr_C03;
             end
      'hC04: begin
             csr_data_rd <= csr_C04;
             end
      'hC80: begin
             csr_data_rd <= csr_C80;
             end
      'hC81: begin
             csr_data_rd <= csr_C81;
             end
      'hC82: begin
             csr_data_rd <= csr_C82;
             end
      'hC83: begin
             csr_data_rd <= csr_C83;
             end
      'hC84: begin
             csr_data_rd <= csr_C84;
             end
      default: begin
               end
    endcase
    end

  if(csr_req & csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC00: begin
             csr_C00 <= (csr_C00     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC01: begin
             csr_C01 <= (csr_C01     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC02: begin
             csr_C02 <= (csr_C02     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC03: begin
             csr_C03 <= (csr_C03     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC04: begin
             csr_C04 <= (csr_C04     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC80: begin
             csr_C80 <= (csr_C80     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC81: begin
             csr_C81 <= (csr_C81     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC82: begin
             csr_C82 <= (csr_C82     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC83: begin
             csr_C83 <= (csr_C83     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC84: begin
             csr_C84 <= (csr_C84     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      default: begin
               end
    endcase
    end


  if(rst)
    begin
    csr_C00  <= '0;
    csr_C80  <= '0;

    time_counter <= '0;
    csr_C01  <= '0;
    csr_C81  <= '0;

    csr_C02  <= '0;
    csr_C82  <= '0;

    csr_C03  <= '0;
    csr_C83  <= '0;

    csr_C04  <= '0;
    csr_C84  <= '0;
    end
  end

endmodule
