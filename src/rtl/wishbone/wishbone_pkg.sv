package wishbone_pkg;

  typedef struct packed {
    logic             Cyc;
    logic             Stb;
    logic             We;
    logic [31:0]      Adr;
    logic  [3:0]      Sel;
    logic [31:0]      Data;
    logic             Tga;
    logic             Tgd;
    logic  [3:0]      Tgc;
  } bus_req_t;


  typedef struct packed {
    logic             Stall;
    logic             Ack;
    logic             Err;
    logic             Rty;
    logic [31:0]      Data;
    logic             Tga;
    logic             Tgd;
    logic  [3:0]      Tgc;
  } bus_rsp_t;

  typedef struct packed {
    logic             Cyc;
    logic             Stb;
    logic             We;
    logic [31:0]      Adr;
    logic  [3:0]      Sel;
    logic [127:0]     Data;
    logic             Tga;
    logic             Tgd;
    logic  [3:0]      Tgc;
  } dst_req_t;


  typedef struct packed {
    logic             Stall;
    logic             Ack;
    logic             Err;
    logic             Rty;
    logic [127:0]     Data;
    logic             Tga;
    logic             Tgd;
    logic  [3:0]      Tgc;
  } dst_rsp_t;

endpackage
