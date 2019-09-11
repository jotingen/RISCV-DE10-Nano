module riscv_csr (
  input  logic              clk,
  input  logic              rst,

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

  if(rst)
    begin
    csr_C00  <= '0;
    csr_C80  <= '0;
    end
  end

endmodule
