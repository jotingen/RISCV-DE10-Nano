package riscv

import rvfimon._
import wishbone._

import spinal.core._
import spinal.lib._

class riscv_lsu extends Component {
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
  val busData = master( WishBone() )

  val order = in( UInt( 64 bits ) )
  val rvfi = out( RvfiMon() )

  val inst = Reg( InstDecoded() )
  inst.Vld init ( False)

  val rvfi_order = Reg( UInt( 64 bits ) )
  rvfi_order init ( 0)

  val busDataReq = Reg( WishBoneReq() )
  busData.req <> busDataReq

  busDataReq.cyc init ( False)
  busDataReq.stb init ( False)
  busDataReq.we init ( False)
  busDataReq.adr init ( 0)
  busDataReq.sel init ( 0)
  busDataReq.data init ( 0)
  busDataReq.tga init ( 0)
  busDataReq.tgd init ( 0)
  busDataReq.tgc init ( 0)

  val pendingRsp = Reg( Bool )
  pendingRsp init ( False)

  busy <> inst.Vld
  rs1 <> U( inst.Rs1 )
  rs2 <> U( inst.Rs2 )
  rd <> U( inst.Rd )

  //Calculate new data
  val rs1Data = B( x( U( inst.Rs1 ) ) )
  val rs2Data = B( x( U( inst.Rs2 ) ) )

  busDataReq.cyc := False
  busDataReq.stb := False
  busDataReq.we := busDataReq.we
  busDataReq.adr := busDataReq.adr
  busDataReq.sel := busDataReq.sel
  busDataReq.data := busDataReq.data
  busDataReq.tga := busDataReq.tga
  busDataReq.tgd := busDataReq.tgd
  busDataReq.tgc := busDataReq.tgc

  val adr = U( S( rs1Data ) + S( inst.Immed ) )
  done := False
  wr := False
  ndx := U( inst.Rd )
  data := 0
  PCNext := inst.Adr + 4
  misfetch := inst.AdrNext =/= PCNext
  when( inst.Vld ) {
    switch( inst.Op ) {
      is( InstOp.LB ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := False
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          switch( B( adr( 1 downto 0 ) ) ) {
            is( B"2'd0" ) {
              busDataReq.sel := B"4'b0001"
            }
            is( B"2'd1" ) {
              busDataReq.sel := B"4'b0010"
            }
            is( B"2'd2" ) {
              busDataReq.sel := B"4'b0100"
            }
            is( B"2'd3" ) {
              busDataReq.sel := B"4'b1000"
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := True
            switch( B( adr( 1 downto 0 ) ) ) {
              is( B"2'd0" ) {
                data := B(
                  S( busData.rsp.data( 7 downto 0 ).resized ),
                  32 bits
                )
              }
              is( B"2'd1" ) {
                data := B(
                  S( busData.rsp.data( 15 downto 8 ).resized ),
                  32 bits
                )
              }
              is( B"2'd2" ) {
                data := B(
                  S( busData.rsp.data( 23 downto 16 ).resized ),
                  32 bits
                )
              }
              is( B"2'd3" ) {
                data := B(
                  S( busData.rsp.data( 31 downto 24 ).resized ),
                  32 bits
                )
              }
            }
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.LH ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := False
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          switch( B( adr( 1 ) ) ) {
            is( B"1'd0" ) {
              busDataReq.sel := B"4'b0011"
            }
            is( B"1'd1" ) {
              busDataReq.sel := B"4'b1100"
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := True
            switch( B( adr( 1 ) ) ) {
              is( B"1'd0" ) {
                data := B(
                  S( busData.rsp.data( 15 downto 0 ).resized ),
                  32 bits
                )
              }
              is( B"1'd1" ) {
                data := B(
                  S( busData.rsp.data( 31 downto 16 ).resized ),
                  32 bits
                )
              }
            }
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.LW ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := False
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          busDataReq.sel := B"4'b1111"
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := True
            data := busData.rsp.data
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.LBU ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := False
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          switch( B( adr( 1 downto 0 ) ) ) {
            is( B"2'd0" ) {
              busDataReq.sel := B"4'b0001"
            }
            is( B"2'd1" ) {
              busDataReq.sel := B"4'b0010"
            }
            is( B"2'd2" ) {
              busDataReq.sel := B"4'b0100"
            }
            is( B"2'd3" ) {
              busDataReq.sel := B"4'b1000"
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := True
            switch( B( adr( 1 downto 0 ) ) ) {
              is( B"2'd0" ) {
                data := B(
                  U( busData.rsp.data( 7 downto 0 ).resized ),
                  32 bits
                )
              }
              is( B"2'd1" ) {
                data := B(
                  U( busData.rsp.data( 15 downto 8 ).resized ),
                  32 bits
                )
              }
              is( B"2'd2" ) {
                data := B(
                  U( busData.rsp.data( 23 downto 16 ).resized ),
                  32 bits
                )
              }
              is( B"2'd3" ) {
                data := B(
                  U( busData.rsp.data( 31 downto 24 ).resized ),
                  32 bits
                )
              }
            }
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.LHU ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := False
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          switch( B( adr( 1 ) ) ) {
            is( B"1'd0" ) {
              busDataReq.sel := B"4'b0011"
            }
            is( B"1'd1" ) {
              busDataReq.sel := B"4'b1100"
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := True
            switch( B( adr( 1 ) ) ) {
              is( B"1'd0" ) {
                data := B(
                  U( busData.rsp.data( 15 downto 0 ).resized ),
                  32 bits
                )
              }
              is( B"1'd1" ) {
                data := B(
                  U( busData.rsp.data( 31 downto 16 ).resized ),
                  32 bits
                )
              }
            }
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.SB ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := True
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          busDataReq.data := 0
          switch( B( adr( 1 downto 0 ) ) ) {
            is( B"2'd0" ) {
              busDataReq.sel := B"4'b0001"
              busDataReq.data( 7 downto 0 ) := rs2Data( 7 downto 0 )
            }
            is( B"2'd1" ) {
              busDataReq.sel := B"4'b0010"
              busDataReq.data( 15 downto 8 ) := rs2Data( 7 downto 0 )
            }
            is( B"2'd2" ) {
              busDataReq.sel := B"4'b0100"
              busDataReq.data( 23 downto 16 ) := rs2Data( 7 downto 0 )
            }
            is( B"2'd3" ) {
              busDataReq.sel := B"4'b1000"
              busDataReq.data( 31 downto 24 ) := rs2Data( 7 downto 0 )
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := False
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.SH ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := True
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          busDataReq.data := 0
          switch( B( adr( 1 ) ) ) {
            is( B"1'd0" ) {
              busDataReq.sel := B"4'b0011"
              busDataReq.data( 15 downto 0 ) := rs2Data( 15 downto 0 )
            }
            is( B"1'd1" ) {
              busDataReq.sel := B"4'b1100"
              busDataReq.data( 31 downto 16 ) := rs2Data( 15 downto 0 )
            }
          }
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := False
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      is( InstOp.SW ) {
        when( ~pendingRsp ) {
          busDataReq.cyc := True
          busDataReq.stb := True
          busDataReq.we := True
          busDataReq.adr := adr
          busDataReq.adr( 1 downto 0 ) := 0
          busDataReq.sel := B"4'b1111"
          busDataReq.data := rs2Data
          pendingRsp := True
        } elsewhen
          ( busData.rsp.ack) {
            done := True
            wr := False
            inst.Vld := False
            pendingRsp := False
          } otherwise {}
      }
      default {}
    }
  }
  when( inst.Rd === 0 ) {
    data := 0
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
  when(
    inst.Op === InstOp.SW || inst.Op === InstOp.SH || inst.Op === InstOp.SB
  ) {
    rvfi.rs2_addr := inst.Rs2
    rvfi.rs2_rdata := rs2Data
  } otherwise {
    rvfi.rs2_addr := 0
    rvfi.rs2_rdata := 0
  }
  rvfi.rs1_rdata := rs1Data
  rvfi.rd_addr := inst.Rd
  when( wr ) {
    rvfi.rd_addr := inst.Rd
    rvfi.rd_wdata := 0
    when( busDataReq.sel( 3 ) ) {
      rvfi.rd_wdata( 31 downto 24 ) := data( 31 downto 24 )
    }
    when( busDataReq.sel( 2 ) ) {
      rvfi.rd_wdata( 23 downto 16 ) := data( 23 downto 16 )
    }
    when( busDataReq.sel( 1 ) ) {
      rvfi.rd_wdata( 15 downto 8 ) := data( 15 downto 8 )
    }
    when( busDataReq.sel( 0 ) ) {
      rvfi.rd_wdata( 7 downto 0 ) := data( 7 downto 0 )
    }
  } otherwise {
    rvfi.rd_addr := 0
    rvfi.rd_wdata := 0
  }
  rvfi.pc_rdata := B( inst.Adr )
  rvfi.pc_wdata := B( PCNext )
  rvfi.mem_addr := B( busDataReq.adr )
  when( busDataReq.we ) {
    rvfi.mem_rmask := 0
    rvfi.mem_wmask := busDataReq.sel
    rvfi.mem_wdata := busDataReq.data
  } otherwise {
    rvfi.mem_rmask := busDataReq.sel
    rvfi.mem_wmask := 0
    rvfi.mem_wdata := 0
  }
  rvfi.mem_rdata := data
  rvfi.csr_mcycle_rmask := 0
  rvfi.csr_mcycle_wmask := 0
  rvfi.csr_mcycle_rdata := 0
  rvfi.csr_mcycle_wdata := 0
  rvfi.csr_minstret_rmask := 0
  rvfi.csr_minstret_wmask := 0
  rvfi.csr_minstret_rdata := 0
  rvfi.csr_minstret_wdata := 0

}
