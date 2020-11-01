package riscv

import rvfimon._
import wishbone._

import spinal.core._
import spinal.lib._

//Hardware definition
class riscv_exu extends Component {
  val instDecoded = in( InstDecoded() )
  val freeze = out( Bool )
  val misfetch = out( Bool )
  val misfetchAdr = out( UInt( 32 bits ) )
  val busData = master( WishBone() )

  val rvfi = out( Vec( RvfiMon(), 6 ) )
  for (i <- 5 to 5) {
    rvfi( i ).valid := False
    rvfi( i ).order := 0
    rvfi( i ).insn := 0
    rvfi( i ).trap := False
    rvfi( i ).halt := False
    rvfi( i ).intr := False
    rvfi( i ).mode := 0
    rvfi( i ).rs1_addr := 0
    rvfi( i ).rs2_addr := 0
    rvfi( i ).rs1_rdata := 0
    rvfi( i ).rs2_rdata := 0
    rvfi( i ).rd_addr := 0
    rvfi( i ).rd_wdata := 0
    rvfi( i ).pc_rdata := 0
    rvfi( i ).pc_wdata := 0
    rvfi( i ).mem_addr := 0
    rvfi( i ).mem_rmask := 0
    rvfi( i ).mem_wmask := 0
    rvfi( i ).mem_rdata := 0
    rvfi( i ).mem_wdata := 0
    rvfi( i ).csr_mcycle_rmask := 0
    rvfi( i ).csr_mcycle_wmask := 0
    rvfi( i ).csr_mcycle_rdata := 0
    rvfi( i ).csr_mcycle_wdata := 0
    rvfi( i ).csr_minstret_rmask := 0
    rvfi( i ).csr_minstret_wmask := 0
    rvfi( i ).csr_minstret_rdata := 0
    rvfi( i ).csr_minstret_wdata := 0
  }

  val order = Reg( UInt( 64 bits ) )
  order init ( 0)

  val x = Vec( Reg( Bits( 32 bits ) ), 32 )
  x( 0 ) init ( 0)
  //for(entry <- x) {
  //  entry init(0)
  //}

  val hazard = new Bool

  val alu = new riscv_alu()
  val aluOp = new Bool
  val aluHazard = new Bool
  alu.instDecoded <> instDecoded
  alu.x <> x
  alu.order <> order
  alu.rvfi <> rvfi( 0 )
  alu.capture := False

  val bru = new riscv_bru()
  val bruOp = new Bool
  val bruHazard = new Bool
  bru.instDecoded <> instDecoded
  bru.x <> x
  bru.order <> order
  bru.rvfi <> rvfi( 1 )
  bru.capture := False

  val lsu = new riscv_lsu()
  val lsuOp = new Bool
  val lsuHazard = new Bool
  lsu.instDecoded <> instDecoded
  lsu.x <> x
  lsu.order <> order
  lsu.rvfi <> rvfi( 2 )
  lsu.busData <> busData
  lsu.capture := False

  val mpu = new riscv_mpu()
  val mpuOp = new Bool
  val mpuHazard = new Bool
  mpu.instDecoded <> instDecoded
  mpu.x <> x
  mpu.order <> order
  mpu.rvfi <> rvfi( 3 )
  mpu.capture := False

  val dvu = new riscv_dvu()
  val dvuOp = new Bool
  val dvuHazard = new Bool
  dvu.instDecoded <> instDecoded
  dvu.x <> x
  dvu.order <> order
  dvu.rvfi <> rvfi( 4 )
  dvu.capture := False

  aluOp := instDecoded.Op === InstOp.LUI || instDecoded.Op === InstOp.AUIPC ||
    instDecoded.Op === InstOp.ADD || instDecoded.Op === InstOp.ADDI ||
    instDecoded.Op === InstOp.SLTI || instDecoded.Op === InstOp.SLTIU ||
    instDecoded.Op === InstOp.XORI || instDecoded.Op === InstOp.ORI ||
    instDecoded.Op === InstOp.ANDI || instDecoded.Op === InstOp.SLLI ||
    instDecoded.Op === InstOp.SRLI || instDecoded.Op === InstOp.SRAI ||
    instDecoded.Op === InstOp.ADD || instDecoded.Op === InstOp.SUB ||
    instDecoded.Op === InstOp.SLL || instDecoded.Op === InstOp.SLT ||
    instDecoded.Op === InstOp.SLTU || instDecoded.Op === InstOp.XOR ||
    instDecoded.Op === InstOp.SRL || instDecoded.Op === InstOp.SRA ||
    instDecoded.Op === InstOp.OR || instDecoded.Op === InstOp.AND
  bruOp := instDecoded.Op === InstOp.JAL || instDecoded.Op === InstOp.JALR ||
    instDecoded.Op === InstOp.BEQ || instDecoded.Op === InstOp.BNE ||
    instDecoded.Op === InstOp.BLT || instDecoded.Op === InstOp.BGE ||
    instDecoded.Op === InstOp.BLTU || instDecoded.Op === InstOp.BGEU
  lsuOp := instDecoded.Op === InstOp.LB || instDecoded.Op === InstOp.LH ||
    instDecoded.Op === InstOp.LW || instDecoded.Op === InstOp.LBU ||
    instDecoded.Op === InstOp.LHU || instDecoded.Op === InstOp.SB ||
    instDecoded.Op === InstOp.SH || instDecoded.Op === InstOp.SW
  mpuOp := instDecoded.Op === InstOp.MUL || instDecoded.Op === InstOp.MULH ||
    instDecoded.Op === InstOp.MULHSU || instDecoded.Op === InstOp.MULHU
  dvuOp := instDecoded.Op === InstOp.DIV || instDecoded.Op === InstOp.DIVU ||
    instDecoded.Op === InstOp.REM || instDecoded.Op === InstOp.REMU

  //Simple hazard checking for now
  aluHazard := alu.busy &&
    ( ( U( instDecoded.Rs1 ) =/= 0 && U( instDecoded.Rs1 ) === alu.rs1) ||
      ( U( instDecoded.Rs2 ) =/= 0 && U( instDecoded.Rs2 ) === alu.rs2) ||
      ( U( instDecoded.Rd ) =/= 0 && U( instDecoded.Rd ) === alu.rd))
  bruHazard := bru.busy &&
    ( ( U( instDecoded.Rs1 ) =/= 0 && U( instDecoded.Rs1 ) === bru.rs1) ||
      ( U( instDecoded.Rs2 ) =/= 0 && U( instDecoded.Rs2 ) === bru.rs2) ||
      ( U( instDecoded.Rd ) =/= 0 && U( instDecoded.Rd ) === bru.rd))
  lsuHazard := lsu.busy &&
    ( ( U( instDecoded.Rs1 ) =/= 0 && U( instDecoded.Rs1 ) === lsu.rs1) ||
      ( U( instDecoded.Rs2 ) =/= 0 && U( instDecoded.Rs2 ) === lsu.rs2) ||
      ( U( instDecoded.Rd ) =/= 0 && U( instDecoded.Rd ) === lsu.rd))
  mpuHazard := mpu.busy &&
    ( ( U( instDecoded.Rs1 ) =/= 0 && U( instDecoded.Rs1 ) === mpu.rs1) ||
      ( U( instDecoded.Rs2 ) =/= 0 && U( instDecoded.Rs2 ) === mpu.rs2) ||
      ( U( instDecoded.Rd ) =/= 0 && U( instDecoded.Rd ) === mpu.rd))
  dvuHazard := dvu.busy &&
    ( ( U( instDecoded.Rs1 ) =/= 0 && U( instDecoded.Rs1 ) === dvu.rs1) ||
      ( U( instDecoded.Rs2 ) =/= 0 && U( instDecoded.Rs2 ) === dvu.rs2) ||
      ( U( instDecoded.Rd ) =/= 0 && U( instDecoded.Rd ) === dvu.rd))
  hazard := aluHazard || bruHazard || lsuHazard || mpuHazard || dvuHazard

  //detect any misfetches
  //TODO any reason why not just check bru?
  //TODO figure put how to mux UInt
  when( alu.done ) {
    misfetch := alu.misfetch
    misfetchAdr := alu.PCNext
  } elsewhen
    ( bru.done) {
      misfetch := bru.misfetch
      misfetchAdr := bru.PCNext
    } elsewhen
    ( lsu.done) {
      misfetch := lsu.misfetch
      misfetchAdr := lsu.PCNext
    } elsewhen
    ( mpu.done) {
      misfetch := mpu.misfetch
      misfetchAdr := mpu.PCNext
    } elsewhen
    ( dvu.done) {
      misfetch := dvu.misfetch
      misfetchAdr := dvu.PCNext
    } otherwise {
      misfetch := False
      misfetchAdr := 0
    }

  freeze := False
  when( instDecoded.Vld && ~misfetch ) {
    when( aluOp ) {
      when( ( alu.busy && ~alu.done) || ( hazard) ) {
        freeze := True
      } otherwise {
        alu.capture := True
      }
    }
    when( bruOp ) {
      when( ( bru.busy && ~bru.done) || ( hazard) ) {
        freeze := True
      } otherwise {
        bru.capture := True
      }
    }
    when( lsuOp ) {
      when( ( lsu.busy && ~lsu.done) || ( hazard) ) {
        freeze := True
      } otherwise {
        lsu.capture := True
      }
    }
    when( mpuOp ) {
      when( ( mpu.busy && ~mpu.done) || ( hazard) ) {
        freeze := True
      } otherwise {
        mpu.capture := True
      }
    }
    when( dvuOp ) {
      when( ( dvu.busy && ~dvu.done) || ( hazard) ) {
        freeze := True
      } otherwise {
        dvu.capture := True
      }
    }
    when( ~freeze ) {
      order := order + 1
    }
  }

  when( alu.done && alu.wr && ( alu.ndx =/= 0) ) {
    x( alu.ndx ) := alu.data
  }
  when( bru.done && bru.wr && ( bru.ndx =/= 0) ) {
    x( bru.ndx ) := bru.data
  }
  when( lsu.done && lsu.wr && ( lsu.ndx =/= 0) ) {
    x( lsu.ndx ) := lsu.data
  }
  when( mpu.done && mpu.wr && ( mpu.ndx =/= 0) ) {
    x( mpu.ndx ) := mpu.data
  }
  when( dvu.done && dvu.wr && ( dvu.ndx =/= 0) ) {
    x( dvu.ndx ) := dvu.data
  }

}

class multiplier extends BlackBox {
  val clock = in( Bool )
  val dataa = in( SInt( 32 bits ) )
  val datab = in( SInt( 32 bits ) )
  val result = out( SInt( 64 bits ) )
  mapCurrentClockDomain( clock = clock )
}

class multiplier_unsigned extends BlackBox {
  val clock = in( Bool )
  val dataa = in( UInt( 32 bits ) )
  val datab = in( UInt( 32 bits ) )
  val result = out( UInt( 64 bits ) )
  mapCurrentClockDomain( clock = clock )
}

class multiplier_signed_unsigned extends BlackBox {
  val clock = in( Bool )
  val dataa = in( SInt( 32 bits ) )
  val datab = in( UInt( 33 bits ) )
  val result = out( SInt( 65 bits ) )
  mapCurrentClockDomain( clock = clock )
}

class divider extends BlackBox {
  val clock = in( Bool )
  val denom = in( SInt( 32 bits ) )
  val numer = in( SInt( 32 bits ) )
  val quotient = out( SInt( 32 bits ) )
  val remain = out( SInt( 32 bits ) )
  mapCurrentClockDomain( clock = clock )
}

class divider_unsigned extends BlackBox {
  val clock = in( Bool )
  val denom = in( UInt( 32 bits ) )
  val numer = in( UInt( 32 bits ) )
  val quotient = out( UInt( 32 bits ) )
  val remain = out( UInt( 32 bits ) )
  mapCurrentClockDomain( clock = clock )
}
