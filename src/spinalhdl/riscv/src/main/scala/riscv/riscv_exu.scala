package riscv

import wishbone._

import spinal.core._
import spinal.lib._

class riscv_alu extends Component {
  val capture     = in(Bool)
  val instDecoded = in(InstDecoded())
  val x           = in(Vec(Bits(32 bits),32))
  val busy        = out(Bool)
  val rs1         = out(UInt(5 bits))
  val rs2         = out(UInt(5 bits))
  val rd          = out(UInt(5 bits))
  val done        = out(Bool)
  val wr          = out(Bool)
  val ndx         = out(UInt(5 bits))
  val data        = out(Bits(32 bits))
  val misfetch    = out(Bool)
  val PCNext      = out(UInt(32 bits))

  val inst = Reg(InstDecoded())
  inst.Vld init(False)

  busy <>   inst.Vld
  rs1  <> U(inst.Rs1)
  rs2  <> U(inst.Rs2)
  rd   <> U(inst.Rd )

  //Calculate new data
  val rs1Data = B(x(U(inst.Rs1)))
  val rs2Data = B(x(U(inst.Rs2)))
  switch(inst.Op) {
    is(InstOp.LUI   ) { data :=      inst.Immed                 }
    is(InstOp.AUIPC ) { data := B( U(inst.Immed) +  inst.Adr   )}
    is(InstOp.ADDI  ) { data := B( U(rs1Data) +   U(inst.Immed))}
    is(InstOp.SLTI  ) { data := B((S(rs1Data) <   S(inst.Immed) ) ? B("32'd1") | B("32'd0") )}
    is(InstOp.SLTIU ) { data := B((U(rs1Data) <   U(inst.Immed) ) ? B("32'd1") | B("32'd0") )}
    is(InstOp.XORI  ) { data := B(   rs1Data  ^     inst.Immed )}
    is(InstOp.ORI   ) { data := B(   rs1Data  |     inst.Immed )}
    is(InstOp.ANDI  ) { data := B(   rs1Data  &     inst.Immed )}
    is(InstOp.SLLI  ) { data := B(   rs1Data  |<< U(inst.Rs2)  )}
    is(InstOp.SRLI  ) { data := B(   rs1Data  |>> U(inst.Rs2)  )}
    is(InstOp.SRAI  ) { data := B( S(rs1Data) |>> U(inst.Rs2)  )}
    is(InstOp.ADD   ) { data := B( U(rs1Data) +   U(rs2Data)   )}
    is(InstOp.SUB   ) { data := B( U(rs1Data) -   U(rs2Data)   )}
    is(InstOp.SLL   ) { data := B(   rs1Data  |<< U(rs2Data)   )}
    is(InstOp.SLT   ) { data := B((S(rs1Data) <   S(rs2Data)    ) ? B("32'd1") | B("32'd0") )}
    is(InstOp.SLTU  ) { data := B((U(rs1Data) <   U(rs2Data)    ) ? B("32'd1") | B("32'd0") )}
    is(InstOp.XOR   ) { data := B(   rs1Data  ^     rs2Data    )}
    is(InstOp.SRL   ) { data := B(   rs1Data  |>> U(rs2Data)   )}
    is(InstOp.SRA   ) { data := B( S(rs1Data) |>> U(rs2Data)   )}
    is(InstOp.OR    ) { data := B(   rs1Data  |     rs2Data    )}
    is(InstOp.AND   ) { data := B(   rs1Data  &     rs2Data    )}
    default           { data := B("32'd0")}
  }

  done   := False
  wr     := False
  ndx    := U(inst.Rd)
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when(inst.Vld) {
    done     := True
    wr       := True
    inst.Vld := False
  }
  when(capture) {
    inst := instDecoded
  }

}

class riscv_bru extends Component {
  val capture     = in(Bool)
  val instDecoded = in(InstDecoded())
  val x           = in(Vec(Bits(32 bits),32))
  val busy        = out(Bool)
  val rs1         = out(UInt(5 bits))
  val rs2         = out(UInt(5 bits))
  val rd          = out(UInt(5 bits))
  val done        = out(Bool)
  val wr          = out(Bool)
  val ndx         = out(UInt(5 bits))
  val data        = out(Bits(32 bits))
  val misfetch    = out(Bool)
  val PCNext      = out(UInt(32 bits))

  val inst = Reg(InstDecoded())
  inst.Vld init(False)

  busy <>   inst.Vld
  rs1  <> U(inst.Rs1)
  rs2  <> U(inst.Rs2)
  rd   <> U(inst.Rd )


  //Calculate new data
  val rs1Data = B(x(U(inst.Rs1)))
  val rs2Data = B(x(U(inst.Rs2)))
  //TODO check for misaligned
  wr     := False
  data   := B("32'd0")
  switch(inst.Op) {
    is(InstOp.JAL  ) { wr     := True
                       data   := B(inst.Adr + 4)
                       PCNext := U(S(inst.Adr) + 
                                   S(inst.Immed(19 downto 0)))}
    is(InstOp.JALR ) { wr     := True
                       data   := B(inst.Adr + 4)
                       PCNext := U(S(rs1Data) + 
                                   S(inst.Immed(11 downto 0)))}
    is(InstOp.BEQ  ) { when(rs1Data === rs2Data) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BNE  ) { when(rs1Data =/= rs2Data) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BLT  ) { when(S(rs1Data) < S(rs2Data)) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BGE  ) { when(S(rs1Data) >= S(rs2Data)) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }} 
    is(InstOp.BLTU ) { when(U(rs1Data) < U(rs2Data)) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BGEU ) { when(U(rs1Data) >= U(rs2Data)) {
                         PCNext := U(S(inst.Adr) + 
                                     S(inst.Immed(12 downto 0)))
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }} 
    default          { PCNext := U(inst.Immed)}
  }

  done   := False
  ndx    := U(inst.Rd)
  misfetch := inst.AdrNext =/= PCNext
  when(inst.Vld) {
    done     := True
    inst.Vld := False
  }
  when(capture) {
    inst := instDecoded
  }
}

class riscv_lsu extends Component {
  val capture     = in(Bool)
  val instDecoded = in(InstDecoded())
  val x           = in(Vec(Bits(32 bits),32))
  val busy        = out(Bool)
  val rs1         = out(UInt(5 bits))
  val rs2         = out(UInt(5 bits))
  val rd          = out(UInt(5 bits))
  val done        = out(Bool)
  val wr          = out(Bool)
  val ndx         = out(UInt(5 bits))
  val data        = out(Bits(32 bits))
  val misfetch    = out(Bool)
  val PCNext      = out(UInt(32 bits))
  val busData     = master(WishBone())

  val inst = Reg(InstDecoded())
  inst.Vld init(False)

  val busDataReq = Reg(WishBoneReq()) 
  busData.req <> busDataReq

  busDataReq.cyc  init(False)
  busDataReq.stb  init(False)
  busDataReq.we   init(False)
  busDataReq.adr  init(0)
  busDataReq.sel  init(0)
  busDataReq.data init(0)
  busDataReq.tga  init(0)
  busDataReq.tgd  init(0)
  busDataReq.tgc  init(0)

  val pendingRsp = Reg(Bool)
  pendingRsp init(False)

  busy <>   inst.Vld
  rs1  <> U(inst.Rs1)
  rs2  <> U(inst.Rs2)
  rd   <> U(inst.Rd )

  //Calculate new data
  val rs1Data = B(x(U(inst.Rs1)))
  val rs2Data = B(x(U(inst.Rs2)))

  busDataReq.cyc  := False
  busDataReq.stb  := False
  busDataReq.we   := busDataReq.we  
  busDataReq.adr  := busDataReq.adr 
  busDataReq.sel  := busDataReq.sel 
  busDataReq.data := busDataReq.data
  busDataReq.tga  := busDataReq.tga 
  busDataReq.tgd  := busDataReq.tgd 
  busDataReq.tgc  := busDataReq.tgc 

  val adr = U(S(rs1Data) + S(inst.Immed))
  done   := False
  wr     := False
  ndx    := U(inst.Rd)
  data   := 0
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when(inst.Vld) {
    switch(inst.Op) {
      is(InstOp.LB  ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := False
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := True
                          switch(B(adr(1 downto 0))) {
                            is(B"2'd0") {data := B(S(busData.rsp.data( 7 downto  0).resized), 32 bits) }
                            is(B"2'd1") {data := B(S(busData.rsp.data(15 downto  8).resized), 32 bits) }
                            is(B"2'd2") {data := B(S(busData.rsp.data(23 downto 16).resized), 32 bits) }
                            is(B"2'd3") {data := B(S(busData.rsp.data(31 downto 24).resized), 32 bits) }
                          }
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.LH  ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := False
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          switch(B(adr(1))) {
                            is(B"1'd0") {busDataReq.sel  := B"4'b0011"}
                            is(B"1'd1") {busDataReq.sel  := B"4'b1100"}
                          }
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := True
                          switch(B(adr(1))) {
                            is(B"1'd0") {data := B(S(busData.rsp.data(15 downto  0).resized), 32 bits) }
                            is(B"1'd1") {data := B(S(busData.rsp.data(31 downto 16).resized), 32 bits) }
                          }
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.LW ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := False
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          busDataReq.sel  := B"4'b1111"
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := True
                          data := busData.rsp.data
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.LBU ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := False
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := True
                          switch(B(adr(1 downto 0))) {
                            is(B"2'd0") {data := B(U(busData.rsp.data( 7 downto  0).resized), 32 bits) }
                            is(B"2'd1") {data := B(U(busData.rsp.data(15 downto  8).resized), 32 bits) }
                            is(B"2'd2") {data := B(U(busData.rsp.data(23 downto 16).resized), 32 bits) }
                            is(B"2'd3") {data := B(U(busData.rsp.data(31 downto 24).resized), 32 bits) }
                          }
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.LHU) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := False
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          switch(B(adr(1))) {
                            is(B"1'd0") {busDataReq.sel  := B"4'b0011"}
                            is(B"1'd1") {busDataReq.sel  := B"4'b1100"}
                          }
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := True
                          switch(B(adr(1))) {
                            is(B"1'd0") {data := B(U(busData.rsp.data(15 downto  0).resized), 32 bits) }
                            is(B"1'd1") {data := B(U(busData.rsp.data(31 downto 16).resized), 32 bits) }
                          }
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.SB  ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := True
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          switch(B(adr(1 downto 0))) {
                            is(B"2'd0") {busDataReq.sel  := B"4'b0001"}
                            is(B"2'd1") {busDataReq.sel  := B"4'b0010"}
                            is(B"2'd2") {busDataReq.sel  := B"4'b0100"}
                            is(B"2'd3") {busDataReq.sel  := B"4'b1100"}
                          }
                          busDataReq.data := rs2Data
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := False
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.SH  ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := True
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          switch(B(adr(1))) {
                            is(B"1'd0") {busDataReq.sel  := B"4'b0011"}
                            is(B"1'd1") {busDataReq.sel  := B"4'b1100"}
                          }
                          busDataReq.data := rs2Data
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := False
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      is(InstOp.SW  ) { when(~pendingRsp) {
                          busDataReq.cyc  := True
                          busDataReq.stb  := True
                          busDataReq.we   := True
                          busDataReq.adr  := adr
                          busDataReq.adr(1 downto 0)  := 0
                          busDataReq.sel  := B"4'b1111"
                          busDataReq.data := rs2Data
                          pendingRsp := True
                        } elsewhen(busData.rsp.ack) {
                          done     := True
                          wr       := False
                          inst.Vld := False
                          pendingRsp := False
                        } otherwise {
                        } }
      default         {  }
    }
  }

  when(capture) {
    inst := instDecoded
  }

}

class riscv_mpu extends Component {
  val capture     = in(Bool)
  val instDecoded = in(InstDecoded())
  val x           = in(Vec(Bits(32 bits),32))
  val busy        = out(Bool)
  val rs1         = out(UInt(5 bits))
  val rs2         = out(UInt(5 bits))
  val rd          = out(UInt(5 bits))
  val done        = out(Bool)
  val wr          = out(Bool)
  val ndx         = out(UInt(5 bits))
  val data        = out(Bits(32 bits))
  val misfetch    = out(Bool)
  val PCNext      = out(UInt(32 bits))

  val inst = Reg(InstDecoded())
  inst.Vld init(False)

  val multiplier                 = new multiplier()
  val multiplier_unsigned        = new multiplier_unsigned()
  val multiplier_signed_unsigned = new multiplier_signed_unsigned()

  val cycleMax = U(2)
  val cycle    = Reg(UInt(2 bits))

  busy <>   inst.Vld
  rs1  <> U(inst.Rs1)
  rs2  <> U(inst.Rs2)
  rd   <> U(inst.Rd )

  //Calculate new data
  val rs1Data = B(x(U(inst.Rs1)))
  val rs2Data = B(x(U(inst.Rs2)))
  multiplier.dataa                 <> S(rs1Data)
  multiplier_unsigned.dataa        <> U(rs1Data)
  multiplier_signed_unsigned.dataa <> S(rs1Data)
  multiplier.datab                 <> S(rs2Data)
  multiplier_unsigned.datab        <> U(rs2Data)
  multiplier_signed_unsigned.datab <> U(rs2Data).resized
  data   := 0
  when(inst.Vld) {
    switch(inst.Op) {
      is(InstOp.MUL   ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(multiplier.result(31 downto 0))
                          } }
      is(InstOp.MULH  ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(multiplier.result(63 downto 32))
                          } } 
      is(InstOp.MULHSU) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(multiplier_unsigned.result(63 downto 32))
                          } } 
      is(InstOp.MULHU ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(multiplier_signed_unsigned.result(63 downto 32))
                          } } 
      default           { cycle := cycleMax
                          data := B("32'd0")}
    }
  }

  done   := False
  wr     := False
  ndx    := U(inst.Rd)
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when(inst.Vld && (cycle >= cycleMax)) {
    done     := True
    wr       := True
    inst.Vld := False
  }
  when(capture) {
    cycle := 0
    inst  := instDecoded
  }

}

class riscv_dvu extends Component {
  val capture     = in(Bool)
  val instDecoded = in(InstDecoded())
  val x           = in(Vec(Bits(32 bits),32))
  val busy        = out(Bool)
  val rs1         = out(UInt(5 bits))
  val rs2         = out(UInt(5 bits))
  val rd          = out(UInt(5 bits))
  val done        = out(Bool)
  val wr          = out(Bool)
  val ndx         = out(UInt(5 bits))
  val data        = out(Bits(32 bits))
  val misfetch    = out(Bool)
  val PCNext      = out(UInt(32 bits))

  val inst = Reg(InstDecoded())
  inst.Vld init(False)

  val divider          = new divider()
  val divider_unsigned = new divider_unsigned()

  val cycleMax = U(10)
  val cycle    = Reg(UInt(4 bits))

  busy <>   inst.Vld
  rs1  <> U(inst.Rs1)
  rs2  <> U(inst.Rs2)
  rd   <> U(inst.Rd )

  //Calculate new data
  val rs1Data = B(x(U(inst.Rs1)))
  val rs2Data = B(x(U(inst.Rs2)))
  divider.numer          <> S(rs1Data)
  divider_unsigned.numer <> U(rs1Data)
  divider.denom          <> S(rs2Data)
  divider_unsigned.denom <> U(rs2Data)
  data   := 0
  when(inst.Vld) {
    switch(inst.Op) {
      is(InstOp.DIV   ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(divider.quotient)
                          } }
      is(InstOp.DIVU  ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(divider_unsigned.quotient)
                          } } 
      is(InstOp.REM   ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(divider.remain)
                          } } 
      is(InstOp.REMU  ) { when(cycle < cycleMax) {
                            cycle := cycle + 1
                          } otherwise {
                            data := B(divider_unsigned.remain)
                          } } 
      default           { cycle := cycleMax
                          data := B("32'd0")}
    }
  }

  done   := False
  wr     := False
  ndx    := U(inst.Rd)
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when(inst.Vld && (cycle >= cycleMax)) {
    done     := True
    wr       := True
    inst.Vld := False
  }
  when(capture) {
    cycle := 0
    inst  := instDecoded
  }

}

//Hardware definition
class riscv_exu extends Component {
  val instDecoded = in(InstDecoded())
  val freeze      = out(Bool)
  val misfetch    = out(Bool)
  val misfetchAdr = out(UInt(32 bits))
  val busData     = master(WishBone())

  val x = Vec(Reg(Bits(32 bits)),32)
  x(0) init(0)
  //for(entry <- x) {
  //  entry init(0)
  //}

  val alu       = new riscv_alu()
  val aluOp     = new Bool
  val aluHazard = new Bool
  alu.instDecoded <> instDecoded
  alu.x           <> x
  alu.capture := False

  val bru       = new riscv_bru()
  val bruOp     = new Bool
  val bruHazard = new Bool
  bru.instDecoded <> instDecoded
  bru.x           <> x
  bru.capture := False

  val lsu       = new riscv_lsu()
  val lsuOp     = new Bool
  val lsuHazard = new Bool
  lsu.instDecoded <> instDecoded
  lsu.x           <> x
  lsu.busData     <> busData
  lsu.capture := False

  val mpu       = new riscv_mpu()
  val mpuOp     = new Bool
  val mpuHazard = new Bool
  mpu.instDecoded <> instDecoded
  mpu.x           <> x
  mpu.capture := False

  val dvu       = new riscv_dvu()
  val dvuOp     = new Bool
  val dvuHazard = new Bool
  dvu.instDecoded <> instDecoded
  dvu.x           <> x
  dvu.capture := False

  aluOp := instDecoded.Op === InstOp.LUI   ||
           instDecoded.Op === InstOp.AUIPC ||
           instDecoded.Op === InstOp.ADD   ||
           instDecoded.Op === InstOp.ADDI  ||
           instDecoded.Op === InstOp.SLTI  ||
           instDecoded.Op === InstOp.SLTIU ||
           instDecoded.Op === InstOp.XORI  ||
           instDecoded.Op === InstOp.ORI   ||
           instDecoded.Op === InstOp.ANDI  ||
           instDecoded.Op === InstOp.SLLI  ||
           instDecoded.Op === InstOp.SRLI  ||
           instDecoded.Op === InstOp.SRAI  ||
           instDecoded.Op === InstOp.ADD   ||
           instDecoded.Op === InstOp.SUB   ||
           instDecoded.Op === InstOp.SLL   ||
           instDecoded.Op === InstOp.SLT   ||
           instDecoded.Op === InstOp.SLTU  ||
           instDecoded.Op === InstOp.XOR   ||
           instDecoded.Op === InstOp.SRL   ||
           instDecoded.Op === InstOp.SRA   ||
           instDecoded.Op === InstOp.OR    ||
           instDecoded.Op === InstOp.AND
  bruOp := instDecoded.Op === InstOp.JAL   ||
           instDecoded.Op === InstOp.JALR  ||
           instDecoded.Op === InstOp.BEQ   ||
           instDecoded.Op === InstOp.BNE   ||
           instDecoded.Op === InstOp.BLT   ||
           instDecoded.Op === InstOp.BGE   ||
           instDecoded.Op === InstOp.BLTU  ||
           instDecoded.Op === InstOp.BGEU 
  lsuOp := instDecoded.Op === InstOp.LB    ||
           instDecoded.Op === InstOp.LH    ||
           instDecoded.Op === InstOp.LW    ||
           instDecoded.Op === InstOp.LBU   ||
           instDecoded.Op === InstOp.LHU   ||
           instDecoded.Op === InstOp.SB    ||
           instDecoded.Op === InstOp.SH    ||
           instDecoded.Op === InstOp.SW 
  mpuOp := instDecoded.Op === InstOp.MUL    ||
           instDecoded.Op === InstOp.MULH   ||
           instDecoded.Op === InstOp.MULHSU ||
           instDecoded.Op === InstOp.MULHU 
  dvuOp := instDecoded.Op === InstOp.DIV   ||
           instDecoded.Op === InstOp.DIVU  ||
           instDecoded.Op === InstOp.REM   ||
           instDecoded.Op === InstOp.REMU

  //Simple hazard checking for now
  aluHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === alu.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === alu.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === alu.rd )
  bruHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === bru.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === bru.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === bru.rd )
  lsuHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === lsu.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === lsu.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === lsu.rd )
  mpuHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === mpu.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === mpu.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === mpu.rd )
  dvuHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === dvu.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === dvu.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === dvu.rd )

  //detect any misfetches
  //TODO any reason why not just check bru?
  //TODO figure put how to mux UInt
  when(alu.done) {
    misfetch    := alu.misfetch
    misfetchAdr := alu.PCNext
  } elsewhen(bru.done) {
    misfetch    := bru.misfetch
    misfetchAdr := bru.PCNext
  } elsewhen(lsu.done) {
    misfetch    := lsu.misfetch
    misfetchAdr := lsu.PCNext
  } elsewhen(mpu.done) {
    misfetch    := mpu.misfetch
    misfetchAdr := mpu.PCNext
  } elsewhen(dvu.done) {
    misfetch    := dvu.misfetch
    misfetchAdr := dvu.PCNext
  } otherwise {
    misfetch    := False
    misfetchAdr := 0
  }

  freeze := False
  when(instDecoded.Vld && ~misfetch) {
    when(aluOp) {
      when((alu.busy && ~alu.done) || (alu.busy && alu.done && aluHazard)) { 
        freeze := True
      } otherwise {
        alu.capture := True
      }
    }
    when(bruOp) {
      when((bru.busy && ~bru.done) || (bru.busy && bru.done && bruHazard)) { 
        freeze := True
      } otherwise {
        bru.capture := True
      }
    }
    when(lsuOp) {
      when((lsu.busy && ~lsu.done) || (lsu.busy && lsu.done && lsuHazard)) { 
        freeze := True
      } otherwise {
        lsu.capture := True
      }
    }
    when(mpuOp) {
      when((mpu.busy && ~mpu.done) || (mpu.busy && mpu.done && mpuHazard)) { 
        freeze := True
      } otherwise {
        mpu.capture := True
      }
    }
    when(dvuOp) {
      when((dvu.busy && ~dvu.done) || (dvu.busy && dvu.done && dvuHazard)) { 
        freeze := True
      } otherwise {
        dvu.capture := True
      }
    }
  }

  when(alu.done && alu.wr && (alu.ndx =/= 0)) {
    x(alu.ndx) := alu.data
  }
  when(bru.done && bru.wr && (bru.ndx =/= 0)) {
    x(bru.ndx) := bru.data
  }
  when(lsu.done && lsu.wr && (lsu.ndx =/= 0)) {
    x(lsu.ndx) := lsu.data
  }
  when(mpu.done && mpu.wr && (mpu.ndx =/= 0)) {
    x(mpu.ndx) := mpu.data
  }
  when(dvu.done && dvu.wr && (dvu.ndx =/= 0)) {
    x(dvu.ndx) := dvu.data
  }
    
}

class multiplier extends BlackBox {
  val clock    = in (Bool)
  val dataa    = in (SInt(32 bits))
  val datab    = in (SInt(32 bits))
  val result   = out(SInt(64 bits))
  mapCurrentClockDomain(clock=clock)
}

class multiplier_unsigned extends BlackBox {
  val clock    = in (Bool)
  val dataa    = in (UInt(32 bits))
  val datab    = in (UInt(32 bits))
  val result   = out(UInt(64 bits))
  mapCurrentClockDomain(clock=clock)
}

class multiplier_signed_unsigned extends BlackBox {
  val clock    = in (Bool)
  val dataa    = in (SInt(32 bits))
  val datab    = in (UInt(33 bits))
  val result   = out(SInt(65 bits))
  mapCurrentClockDomain(clock=clock)
}

class divider extends BlackBox {
  val clock    = in (Bool)
  val denom    = in (SInt(32 bits))
  val numer    = in (SInt(32 bits))
  val quotient = out(SInt(32 bits))
  val remain   = out(SInt(32 bits))
  mapCurrentClockDomain(clock=clock)
}

class divider_unsigned extends BlackBox {
  val clock    = in (Bool)
  val denom    = in (UInt(32 bits))
  val numer    = in (UInt(32 bits))
  val quotient = out(UInt(32 bits))
  val remain   = out(UInt(32 bits))
  mapCurrentClockDomain(clock=clock)
}
