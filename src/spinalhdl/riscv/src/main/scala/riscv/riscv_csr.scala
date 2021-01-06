package riscv

import wishbone._

import spinal.core._
import spinal.lib._

class riscv_csr( config: riscv_config ) extends Component {

  val csrData = slave( WishBone( config.csrWishBoneConfig ) )

  val retired = in( Bool )
  val brTaken = in( Bool )
  val brNotTaken = in( Bool )
  val misfetch = in( Bool )

  csrData.stall := False

  val csrDataRsp = Reg( WishBoneRsp( config.csrWishBoneConfig ) )
  csrData.rsp <> csrDataRsp

  csrDataRsp.ack := csrData.req.cyc
  csrDataRsp.err := False
  csrDataRsp.rty := False
  csrDataRsp.data := 0
  csrDataRsp.tga := 0
  csrDataRsp.tgd := 0
  csrDataRsp.tgc := 0

  //Counter
  val counter = Reg( UInt( 64 bits ) )
  counter init ( 0)
  counter := counter + 1

  //Timer
  // In ns, at 50MHz is 20 ticks per cycle
  val timer = Reg( UInt( 64 bits ) )
  timer init ( 0)
  timer := timer + 20

  //Retired Counter
  val retired_counter = Reg( UInt( 64 bits ) )
  retired_counter init ( 0)
  when( retired ) {
    retired_counter := retired_counter + 1
  } otherwise {
    retired_counter := retired_counter
  }

  //Branch Counter
  val branch_counter = Reg( UInt( 64 bits ) )
  branch_counter init ( 0)
  when( brTaken || brNotTaken ) {
    branch_counter := branch_counter + 1
  } otherwise {
    branch_counter := branch_counter
  }

  //Branch Miss Counter
  val brmiss_counter = Reg( UInt( 64 bits ) )
  brmiss_counter init ( 0)
  when( misfetch ) {
    brmiss_counter := brmiss_counter + 1
  } otherwise {
    brmiss_counter := brmiss_counter
  }

  when( csrData.req.cyc ) {
    switch( csrData.req.adr ) {
      //Counter Lo
      is( U"hC00" ) {
        csrDataRsp.data := B( counter( 31 downto 0 ) )
        counter( 31 downto 0 ) := U(
          ( B( counter( 31 downto 0 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }
      //Counter Hi
      is( U"hC80" ) {
        csrDataRsp.data := B( counter( 63 downto 32 ) )
        counter( 63 downto 32 ) := U(
          ( B( counter( 63 downto 32 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }

      //Timer Lo
      is( U"hC01" ) {
        csrDataRsp.data := B( timer( 31 downto 0 ) )
        timer( 31 downto 0 ) := U(
          ( B( timer( 31 downto 0 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }
      //Timer Hi
      is( U"hC81" ) {
        csrDataRsp.data := B( timer( 63 downto 32 ) )
        timer( 63 downto 32 ) := U(
          ( B( timer( 63 downto 32 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }

      //Retired Counter Lo
      is( U"hC02" ) {
        csrDataRsp.data := B( retired_counter( 31 downto 0 ) )
        retired_counter( 31 downto 0 ) := U(
          ( B( retired_counter( 31 downto 0 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }
      //Retired Counter Hi
      is( U"hC82" ) {
        csrDataRsp.data := B( retired_counter( 63 downto 32 ) )
        retired_counter( 63 downto 32 ) := U(
          ( B( retired_counter( 63 downto 32 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }

      //Branch Counter Lo
      is( U"hC03" ) {
        csrDataRsp.data := B( branch_counter( 31 downto 0 ) )
        branch_counter( 31 downto 0 ) := U(
          ( B( branch_counter( 31 downto 0 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }
      //Branch Counter Hi
      is( U"hC83" ) {
        csrDataRsp.data := B( branch_counter( 63 downto 32 ) )
        branch_counter( 63 downto 32 ) := U(
          ( B( branch_counter( 63 downto 32 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }

      //BrMiss Counter Lo
      is( U"hC04" ) {
        csrDataRsp.data := B( brmiss_counter( 31 downto 0 ) )
        brmiss_counter( 31 downto 0 ) := U(
          ( B( brmiss_counter( 31 downto 0 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }
      //BrMiss Counter Hi
      is( U"hC84" ) {
        csrDataRsp.data := B( brmiss_counter( 63 downto 32 ) )
        brmiss_counter( 63 downto 32 ) := U(
          ( B( brmiss_counter( 63 downto 32 ) ) & ~csrData.req.sel) |
            ( csrData.req.data & csrData.req.sel)
        )
      }

      default {}
    }
  }
}
