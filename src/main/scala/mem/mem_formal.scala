package mem

import wishbone._

import spinal.core._
import spinal.lib._

class mem_formal extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

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

  val busInst = slave( WishBone( config.busWishBoneConfig ) )
  val busData = slave( WishBone( config.busWishBoneConfig ) )

  val mem = new mem_top()
  mem.busInst <> busInst
  mem.busData <> busData

  val assumesWBInstrSlave = new WishBoneSlaveAssumes( config.busWishBoneConfig );
  assumesWBInstrSlave.req := busInst.req
  assumesWBInstrSlave.stall := busInst.stall
  assumesWBInstrSlave.rsp := busInst.rsp

  val assumesWBDataSlave = new WishBoneSlaveAssumes( config.busWishBoneConfig );
  assumesWBDataSlave.req := busData.req
  assumesWBDataSlave.stall := busData.stall
  assumesWBDataSlave.rsp := busData.rsp

  GenerationFlags.formal {
    when( initstate() ) {
      assume( clockDomain.isResetActive )
    }
  }
}

class debug_formal extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

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

  val busInst = slave( WishBone( config.busWishBoneConfig ) )
  val busData = slave( WishBone( config.busWishBoneConfig ) )

  val debug = new debug_top()
  debug.busInst <> busInst
  debug.busData <> busData

  val assumesWBInstrSlave = new WishBoneSlaveAssumes( config.busWishBoneConfig );
  assumesWBInstrSlave.req := busInst.req
  assumesWBInstrSlave.stall := busInst.stall
  assumesWBInstrSlave.rsp := busInst.rsp

  val assumesWBDataSlave = new WishBoneSlaveAssumes( config.busWishBoneConfig );
  assumesWBDataSlave.req := busData.req
  assumesWBDataSlave.stall := busData.stall
  assumesWBDataSlave.rsp := busData.rsp

  GenerationFlags.formal {
    when( initstate() ) {
      assume( clockDomain.isResetActive )
    }
  }
}

