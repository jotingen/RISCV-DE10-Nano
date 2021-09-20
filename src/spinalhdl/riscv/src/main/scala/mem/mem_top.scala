package mem

import wishbone._

import spinal.core._
import spinal.lib._

case class riscv_config(
    busWishBoneConfig: WishBoneConfig
)

class mem_top extends Component {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val ram = new ram_mem()

  val busInst = slave( WishBone( config.busWishBoneConfig ) )

  val busInstReq = WishBoneReq( config.busWishBoneConfig )
  busInstReq := busInst.req.ReverseEndian() //Little to Big Endian

  val busInstRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  busInst.rsp.ack := busInstRsp.ReverseEndian().ack //Big to Little Endian
  busInst.rsp.err := busInstRsp.ReverseEndian().err //Big to Little Endian
  busInst.rsp.rty := busInstRsp.ReverseEndian().rty //Big to Little Endian
  busInst.rsp.tga := busInstRsp.ReverseEndian().tga //Big to Little Endian
  busInst.rsp.tgd := busInstRsp.ReverseEndian().tgd //Big to Little Endian
  busInst.rsp.tgc := busInstRsp.ReverseEndian().tgc //Big to Little Endian
  busInstRsp.ack init ( False)

  val busInstStall = Reg( Bool )
  busInst.stall := busInstStall
  busInstStall init ( False)

  busInstStall := False

  busInstRsp.ack := False
  busInstRsp.err := False
  busInstRsp.rty := False
  busInstRsp.tga := busInstRsp.tga
  busInstRsp.tgd := busInstRsp.tgd
  busInstRsp.tgc := busInstRsp.tgc
  ram.wren_a := False
  ram.address_a := busInstReq.adr(14 downto 2)
  ram.byteena_a := busInstReq.sel
  ram.data_a := busInstReq.data

  when( busInstReq.cyc && busInstReq.stb ) {
    busInstRsp.ack := True
    busInstRsp.err := False
    busInstRsp.rty := False
    busInstRsp.tga := busInstReq.tga
    busInstRsp.tgd := busInstReq.tgd
    busInstRsp.tgc := busInstReq.tgc

    when( busInstReq.we ) {
      ram.wren_a := True
    }
  }
  busInst.rsp.data := ram.q_a


  val busData = slave( WishBone( config.busWishBoneConfig ) )

  val busDataReq = WishBoneReq( config.busWishBoneConfig )
  busDataReq := busData.req.ReverseEndian() //Little to Big Endian

  val busDataRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  busData.rsp.ack := busDataRsp.ReverseEndian().ack //Big to Little Endian
  busData.rsp.err := busDataRsp.ReverseEndian().err //Big to Little Endian
  busData.rsp.rty := busDataRsp.ReverseEndian().rty //Big to Little Endian
  busData.rsp.tga := busDataRsp.ReverseEndian().tga //Big to Little Endian
  busData.rsp.tgd := busDataRsp.ReverseEndian().tgd //Big to Little Endian
  busData.rsp.tgc := busDataRsp.ReverseEndian().tgc //Big to Little Endian
  busDataRsp.ack init ( False)

  val busDataStall = Reg( Bool )
  busData.stall := busDataStall
  busDataStall init ( False)

  busDataStall := False

  busDataRsp.ack := False
  busDataRsp.err := False
  busDataRsp.rty := False
  busDataRsp.tga := busDataRsp.tga
  busDataRsp.tgd := busDataRsp.tgd
  busDataRsp.tgc := busDataRsp.tgc
  ram.wren_b := False
  ram.address_b := busDataReq.adr(14 downto 2)
  ram.byteena_b := busDataReq.sel
  ram.data_b := busDataReq.data

  when( busDataReq.cyc && busDataReq.stb ) {
    busDataRsp.ack := True
    busDataRsp.err := False
    busDataRsp.rty := False
    busDataRsp.tga := busDataReq.tga
    busDataRsp.tgd := busDataReq.tgd
    busDataRsp.tgc := busDataReq.tgc

    when( busDataReq.we ) {
      ram.wren_b := True
    }
  }
  busData.rsp.data := ram.q_b

  val asserts = new memAsserts();
}

class debug_top extends Component {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val ram = new ram_debug()

  val busInst = slave( WishBone( config.busWishBoneConfig ) )

  val busInstReq = WishBoneReq( config.busWishBoneConfig )
  busInstReq := busInst.req.ReverseEndian() //Little to Big Endian

  val busInstRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  busInst.rsp.ack := busInstRsp.ReverseEndian().ack //Big to Little Endian
  busInst.rsp.err := busInstRsp.ReverseEndian().err //Big to Little Endian
  busInst.rsp.rty := busInstRsp.ReverseEndian().rty //Big to Little Endian
  busInst.rsp.tga := busInstRsp.ReverseEndian().tga //Big to Little Endian
  busInst.rsp.tgd := busInstRsp.ReverseEndian().tgd //Big to Little Endian
  busInst.rsp.tgc := busInstRsp.ReverseEndian().tgc //Big to Little Endian
  busInstRsp.ack init ( False)

  val busInstStall = Reg( Bool )
  busInst.stall := busInstStall
  busInstStall init ( False)

  busInstStall := False

  busInstRsp.ack := False
  busInstRsp.err := False
  busInstRsp.rty := False
  busInstRsp.tga := busInstRsp.tga
  busInstRsp.tgd := busInstRsp.tgd
  busInstRsp.tgc := busInstRsp.tgc
  ram.wren_a := False
  ram.address_a := busInstReq.adr(9 downto 2)
  ram.byteena_a := busInstReq.sel
  ram.data_a := busInstReq.data

  when( busInstReq.cyc && busInstReq.stb ) {
    busInstRsp.ack := True
    busInstRsp.err := False
    busInstRsp.rty := False
    busInstRsp.tga := busInstReq.tga
    busInstRsp.tgd := busInstReq.tgd
    busInstRsp.tgc := busInstReq.tgc

    when( busInstReq.we ) {
      ram.wren_a := True
    }
  }
  busInst.rsp.data := ram.q_a


  val busData = slave( WishBone( config.busWishBoneConfig ) )

  val busDataReq = WishBoneReq( config.busWishBoneConfig )
  busDataReq := busData.req.ReverseEndian() //Little to Big Endian

  val busDataRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  busData.rsp.ack := busDataRsp.ReverseEndian().ack //Big to Little Endian
  busData.rsp.err := busDataRsp.ReverseEndian().err //Big to Little Endian
  busData.rsp.rty := busDataRsp.ReverseEndian().rty //Big to Little Endian
  busData.rsp.tga := busDataRsp.ReverseEndian().tga //Big to Little Endian
  busData.rsp.tgd := busDataRsp.ReverseEndian().tgd //Big to Little Endian
  busData.rsp.tgc := busDataRsp.ReverseEndian().tgc //Big to Little Endian
  busDataRsp.ack init ( False)

  val busDataStall = Reg( Bool )
  busData.stall := busDataStall
  busDataStall init ( False)

  busDataStall := False

  busDataRsp.ack := False
  busDataRsp.err := False
  busDataRsp.rty := False
  busDataRsp.tga := busDataRsp.tga
  busDataRsp.tgd := busDataRsp.tgd
  busDataRsp.tgc := busDataRsp.tgc
  ram.wren_b := False
  ram.address_b := busDataReq.adr(9 downto 2)
  ram.byteena_b := busDataReq.sel
  ram.data_b := busDataReq.data

  when( busDataReq.cyc && busDataReq.stb ) {
    busDataRsp.ack := True
    busDataRsp.err := False
    busDataRsp.rty := False
    busDataRsp.tga := busDataReq.tga
    busDataRsp.tgd := busDataReq.tgd
    busDataRsp.tgc := busDataReq.tgc

    when( busDataReq.we ) {
      ram.wren_b := True
    }
  }
  busData.rsp.data := ram.q_b

  val asserts = new memAsserts();
}

class memAsserts() extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

  //Signal toggles after initial reset, nothing matters before the first reset
  var reset_seen = Reg( Bool )
  reset_seen := reset_seen
  when( clockDomain.isResetActive ) {
    reset_seen := True
  }

  GenerationFlags.formal {
    when( reset_seen ) {}
  }

}

class ram_mem extends BlackBox {

  val clock     = in( Bool )

  val address_a = in( UInt( 13 bits ) )
  val wren_a    = in( Bool )
  val byteena_a = in( Bits( 4 bits ) )
  val data_a    = in( Bits( 32 bits ) )
  val q_a       = out( Bits( 32 bits ) )

  val address_b = in( UInt( 13 bits ) )
  val wren_b    = in( Bool )
  val byteena_b = in( Bits( 4 bits ) )
  val data_b    = in( Bits( 32 bits ) )
  val q_b       = out( Bits( 32 bits ) )

  mapCurrentClockDomain( clock = clock )
}

class ram_debug extends BlackBox {

  val clock     = in( Bool )

  val address_a = in( UInt( 8 bits ) )
  val wren_a    = in( Bool )
  val byteena_a = in( Bits( 4 bits ) )
  val data_a    = in( Bits( 32 bits ) )
  val q_a       = out( Bits( 32 bits ) )

  val address_b = in( UInt( 8 bits ) )
  val wren_b    = in( Bool )
  val byteena_b = in( Bits( 4 bits ) )
  val data_b    = in( Bits( 32 bits ) )
  val q_b       = out( Bits( 32 bits ) )

  mapCurrentClockDomain( clock = clock )
}


//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object mem_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig(
        resetKind        = SYNC,
        resetActiveLevel = HIGH
      ),
      targetDirectory              = "../../../output"
    )

//Generate the riscv's Verilog using the above custom configuration.
object mem_top {
  def main( args: Array[String] ) {
    mem_config.includeFormal.generateVerilog( new mem_top )
    mem_config.includeFormal.generateVerilog( new debug_top )
    mem_config.includeFormal.generateSystemVerilog( new mem_formal )
    mem_config.includeFormal.generateSystemVerilog( new debug_formal )
  }
}
