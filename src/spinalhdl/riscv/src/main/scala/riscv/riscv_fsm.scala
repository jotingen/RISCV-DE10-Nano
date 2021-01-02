package riscv

import spinal.core._
import spinal.lib._

object RiscvState extends SpinalEnum {
  val sReset, sNormal, sMisfetch = newElement()
}

class riscv_fsm( config: riscv_config ) extends Component {
  val misfetch = in( Bool )
  val misfetchAdr = in( UInt( 32 bits ) )
  val flush = out( Bool )
  val flushAdr = out( Reg( UInt( 32 bits ) ) )

  import RiscvState._

  val state = Reg( RiscvState() )

  state init ( sReset)
  flushAdr init ( 0)

  state := state
  flush := False
  flushAdr := flushAdr
  when( misfetch ) {
    state := sMisfetch
    flushAdr := misfetchAdr
  } otherwise {
    switch( state ) {
      is( sReset ) {
        state := sNormal
      }
      is( sNormal ) {
        state := sNormal
      }
      is( sMisfetch ) {
        state := sNormal
        flush := True
      }
    }
  }

}
