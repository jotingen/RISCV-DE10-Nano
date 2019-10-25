module riscv_csr (
  input  logic              clk,
  input  logic              rst,

  input  logic              alu_vld,
  input  logic              alu_retired,

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
logic [31:0] csr_C04;
logic [31:0] csr_C84;

logic [31:0] csr_C08;
logic [31:0] csr_C88;


always_ff @(posedge clk)
  begin
  csr_ack  <= '0;
  csr_data_rd <= '0;

  if(csr_req & ~csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC00: begin
             csr_data_rd <= csr_C00;
             end
      'hC80: begin
             csr_data_rd <= csr_C80;
             end
      default: begin
               end
    endcase
    end

  //Counter
  {csr_C80,csr_C00} <= {csr_C80,csr_C00}+'d1;

  if(csr_req & csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC00: begin
             csr_C00 <= (csr_C00     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC80: begin
             csr_C80 <= (csr_C80     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      default: begin
               end
    endcase
    end


  //Time
  if(time_counter >= 'd50000) //Tied to 50 MHz 
    begin 
    {csr_C84,csr_C04} <= {csr_C84,csr_C04}+'d1;
    end 
  else
    begin
    {csr_C84,csr_C04} <= {csr_C84,csr_C04};
    end 

  if(csr_req & csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC04: begin
             csr_C04 <= (csr_C04     & ~csr_mask) | 
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
    {csr_C88,csr_C08} <= {csr_C88,csr_C08}+'d1;
    end 
  else
    begin
    {csr_C88,csr_C08} <= {csr_C88,csr_C08};
    end 

  if(csr_req & csr_write)
    begin
    csr_ack <= '1;
    unique
    case (csr_addr)
      'hC08: begin
             csr_C08 <= (csr_C08     & ~csr_mask) | 
                        (csr_data_wr & ~csr_mask);
             end
      'hC88: begin
             csr_C88 <= (csr_C88     & ~csr_mask) | 
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
    csr_C04  <= '0;
    csr_C84  <= '0;

    csr_C08  <= '0;
    csr_C88  <= '0;
    end
  end

endmodule
