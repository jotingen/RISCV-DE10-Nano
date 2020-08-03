package riscv

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
  switch(instDecoded.Op) {
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
  switch(instDecoded.Op) {
    is(InstOp.JAL  ) { wr     := True
                       data   := B(inst.Adr + 4)
                       PCNext := U(inst.Immed)}
    is(InstOp.JALR ) { wr     := True
                       data   := B(inst.Adr + 4)
                       PCNext := U(inst.Immed)}
    is(InstOp.BEQ  ) { when(rs1Data === rs2Data) {
                         PCNext := U(inst.Immed)
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BNE  ) { when(rs1Data =/= rs2Data) {
                         PCNext := U(inst.Immed)
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BLT  ) { when(S(rs1Data) < S(rs2Data)) {
                         PCNext := U(inst.Immed)
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BGE  ) { when(S(rs1Data) >= S(rs2Data)) {
                         PCNext := U(inst.Immed)
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }} 
    is(InstOp.BLTU ) { when(U(rs1Data) < U(rs2Data)) {
                         PCNext := U(inst.Immed)
                       } otherwise {
                         PCNext := inst.Adr + 4
                       }}
    is(InstOp.BGEU ) { when(U(rs1Data) >= U(rs2Data)) {
                         PCNext := U(inst.Immed)
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

//Hardware definition
class riscv_exu extends Component {
  val instDecoded = in(InstDecoded())
  val freeze      = out(Bool)
  val misfetch    = out(Bool)
  val misfetchAdr = out(UInt(32 bits))

  val x = Vec(Reg(Bits(32 bits)),32)
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

  //Simple hazard checking for now
  aluHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === alu.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === alu.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === alu.rd )
  bruHazard := (U(instDecoded.Rs1) =/= 0 && U(instDecoded.Rs1) === bru.rs1) ||
               (U(instDecoded.Rs2) =/= 0 && U(instDecoded.Rs2) === bru.rs2) ||
               (U(instDecoded.Rd ) =/= 0 && U(instDecoded.Rd ) === bru.rd )

  //detect any misfetches
  //TODO any reason why not just check bru?
  //TODO figure put how to mux UInt
  when(alu.done) {
    misfetch    := alu.misfetch
    misfetchAdr := alu.PCNext
  } elsewhen(bru.done) {
    misfetch    := bru.misfetch
    misfetchAdr := bru.PCNext
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
  }

  when(alu.done && alu.wr) {
    x(alu.ndx) := alu.data
  }
  when(bru.done && bru.wr) {
    x(bru.ndx) := bru.data
  }
    
}
