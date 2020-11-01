package riscv

import rvfimon._
import wishbone._

import spinal.core._
import spinal.lib._

class riscv_alu extends Component {
  val capture = in( Bool )
  val instDecoded = in( InstDecoded() )
  val x = in( Vec( Bits( 32 bits ), 32 ) )
  val busy = out( Bool )
  val rs1 = out( UInt( 5 bits ) )
  val rs2 = out( UInt( 5 bits ) )
  val rd = out( UInt( 5 bits ) )
  val done = out( Bool )
  val wr = out( Bool )
  val ndx = out( UInt( 5 bits ) )
  val data = out( Bits( 32 bits ) )
  val misfetch = out( Bool )
  val PCNext = out( UInt( 32 bits ) )

  val order = in( UInt( 64 bits ) )
  val rvfi = out( RvfiMon() )

  val inst = Reg( InstDecoded() )
  inst.Vld init ( False)

  val rvfi_order = Reg( UInt( 64 bits ) )
  rvfi_order init ( 0)

  busy <> inst.Vld
  rs1 <> U( inst.Rs1 )
  rs2 <> U( inst.Rs2 )
  rd <> U( inst.Rd )

  //Calculate new data
  val rs1Data = B( x( U( inst.Rs1 ) ) )
  val rs2Data = B( x( U( inst.Rs2 ) ) )
  switch( inst.Op ) {
    is( InstOp.LUI ) {
      data := inst.Immed
    }
    is( InstOp.AUIPC ) {
      data := B( U( inst.Immed ) + inst.Adr )
    }
    is( InstOp.ADDI ) {
      data := B( U( rs1Data ) + U( inst.Immed ) )
    }
    is( InstOp.SLTI ) {
      data := B(
        ( S( rs1Data ) < S( inst.Immed )) ? B( "32'd1" ) | B( "32'd0" )
      )
    }
    is( InstOp.SLTIU ) {
      data := B(
        ( U( rs1Data ) < U( inst.Immed )) ? B( "32'd1" ) | B( "32'd0" )
      )
    }
    is( InstOp.XORI ) {
      data := B( rs1Data ^ inst.Immed )
    }
    is( InstOp.ORI ) {
      data := B( rs1Data | inst.Immed )
    }
    is( InstOp.ANDI ) {
      data := B( rs1Data & inst.Immed )
    }
    is( InstOp.SLLI ) {
      data := B( rs1Data |<< U( inst.Rs2 ) )
    }
    is( InstOp.SRLI ) {
      data := B( rs1Data |>> U( inst.Rs2 ) )
    }
    is( InstOp.SRAI ) {
      data := B( S( rs1Data ) |>> U( inst.Rs2 ) )
    }
    is( InstOp.ADD ) {
      data := B( U( rs1Data ) + U( rs2Data ) )
    }
    is( InstOp.SUB ) {
      data := B( U( rs1Data ) - U( rs2Data ) )
    }
    is( InstOp.SLL ) {
      data := B( rs1Data |<< U( rs2Data ) )
    }
    is( InstOp.SLT ) {
      data := B( ( S( rs1Data ) < S( rs2Data )) ? B( "32'd1" ) | B( "32'd0" ) )
    }
    is( InstOp.SLTU ) {
      data := B( ( U( rs1Data ) < U( rs2Data )) ? B( "32'd1" ) | B( "32'd0" ) )
    }
    is( InstOp.XOR ) {
      data := B( rs1Data ^ rs2Data )
    }
    is( InstOp.SRL ) {
      data := B( rs1Data |>> U( rs2Data ) )
    }
    is( InstOp.SRA ) {
      data := B( S( rs1Data ) |>> U( rs2Data ) )
    }
    is( InstOp.OR ) {
      data := B( rs1Data | rs2Data )
    }
    is( InstOp.AND ) {
      data := B( rs1Data & rs2Data )
    }
    default {
      data := B( "32'd0" )
    }
  }
  when( inst.Rd === 0 ) {
    data := 0
  }

  done := False
  wr := False
  ndx := U( inst.Rd )
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when( inst.Vld ) {
    done := True
    wr := True
    inst.Vld := False
  }
  when( capture ) {
    inst := instDecoded
    rvfi_order := order
  }

  rvfi.valid := inst.Vld && done
  rvfi.order := B( rvfi_order )
  rvfi.insn := inst.Data
  rvfi.trap := False
  rvfi.halt := False
  rvfi.intr := False
  rvfi.mode := 0
  rvfi.rs1_addr := inst.Rs1
  rvfi.rs2_addr := inst.Rs2
  rvfi.rs1_rdata := rs1Data
  rvfi.rs2_rdata := rs2Data
  when( wr ) {
    rvfi.rd_addr := inst.Rd
    rvfi.rd_wdata := data
  } otherwise {
    rvfi.rd_addr := 0
    rvfi.rd_wdata := 0
  }
  rvfi.pc_rdata := B( inst.Adr )
  rvfi.pc_wdata := B( PCNext )
  rvfi.mem_addr := 0
  rvfi.mem_rmask := 0
  rvfi.mem_wmask := 0
  rvfi.mem_rdata := 0
  rvfi.mem_wdata := 0
  rvfi.csr_mcycle_rmask := 0
  rvfi.csr_mcycle_wmask := 0
  rvfi.csr_mcycle_rdata := 0
  rvfi.csr_mcycle_wdata := 0
  rvfi.csr_minstret_rmask := 0
  rvfi.csr_minstret_wmask := 0
  rvfi.csr_minstret_rdata := 0
  rvfi.csr_minstret_wdata := 0
}
