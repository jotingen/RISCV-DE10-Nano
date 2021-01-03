package riscv

import wishbone._

import spinal.core._
import spinal.lib._

class mor1kx_cache_lru_accessfix( NUMWAYS: Int ) extends BlackBox {
  val generic =
    new Generic {
      val NUMWAYS = mor1kx_cache_lru_accessfix.this.NUMWAYS
    }

  val WIDTH =
    mor1kx_cache_lru_accessfix.this.NUMWAYS * ( mor1kx_cache_lru_accessfix.this.NUMWAYS - 1) >> 1

  val current = in( Bits( WIDTH bits ) )
  val update = out( Bits( WIDTH bits ) )
  val accessing = in( Bits( NUMWAYS bits ) )
  val lru_pre = out( Bits( NUMWAYS bits ) )
  val lru_post = out( Bits( NUMWAYS bits ) )
}

case class BrBuffEntry() extends Bundle {
  val Adr = UInt( 32 bits )
  val AdrNext = UInt( 32 bits )
  val Prediction = Bits( 4 bits )
}

//Hardware definition
class riscv_ibp( config: riscv_config ) extends Component {
  val misfetch = in( Bool )
  val misfetchPC = in( UInt( 32 bits ) )
  val misfetchAdr = in( UInt( 32 bits ) )
  val brTaken = in( Bool )
  val brNotTaken = in( Bool )
  val brPC = in( UInt( 32 bits ) )
  val adr = in( UInt( 32 bits ) )
  val adrNext = out( UInt( 32 bits ) )

  val lru = new mor1kx_cache_lru_accessfix( config.branchPredSize )
  val lruCurrent = Reg( Bits )
  val lruAccess = Bits( config.branchPredSize bits )
  lruCurrent init ( 0)

  val buffer = Vec( Reg( BrBuffEntry() ), config.branchPredSize )
  for (ndx <- buffer.indices) {
    buffer( ndx ).Adr init ( ndx * 4)
    buffer( ndx ).AdrNext init ( ndx * 4 + 4)
    buffer( ndx ).Prediction init ( B"4'b0010")
  }

  when( misfetch ) {

    //Default to lru value
    lruAccess := lru.lru_pre

    //Override if we have an address match
    for (ndx <- buffer.indices) {
      when( buffer( ndx ).Adr === misfetchPC ) {
        lruAccess := 0
        lruAccess( ndx ) := True
      }
    }

    //Update entry with new values
    for (ndx <- buffer.indices) {
      when( lruAccess( ndx ) ) {
        buffer( ndx ).Adr := misfetchPC
        buffer( ndx ).AdrNext := misfetchAdr
        buffer( ndx ).Prediction := B"4'b0100"
      }
    }

    adrNext := misfetchAdr

  } otherwise {

    when( adr( 1 ) ) {
      adrNext := adr + 2
    } otherwise {
      adrNext := adr + 4
    }

    //TODO val addressMatched = Bool
    //TODO addressMatched := False

    //Mark entry accessed if address matched
    //Use stored address if so
    for (ndx <- buffer.indices) {
      when( buffer( ndx ).Adr === adr ) {
        lruAccess( ndx ) := True
        adrNext := buffer( ndx ).AdrNext
        //TODO addressMatched := True
      } otherwise {
        lruAccess( ndx ) := False
      }
    }

    //TODO when(~addressMatched && ~adr(1)) {
    //TODO   for (ndx <- buffer.indices) {
    //TODO     when(buffer(ndx).Adr === (adr+2)) {
    //TODO       lruAccess(ndx) := True
    //TODO       adrNext := buffer(ndx).AdrNext
    //TODO     } otherwise {
    //TODO       lruAccess(ndx) := False
    //TODO     }
    //TODO   }
    //TODO }

    //Update prediction
    for (ndx <- buffer.indices) {
      when( buffer( ndx ).Adr === brPC ) {
        when( brTaken ) {
          switch( buffer( ndx ).Prediction ) {
            is( B"4'b0001" ) {
              buffer( ndx ).Prediction := B"4'b0010"
            }
            is( B"4'b0010" ) {
              buffer( ndx ).Prediction := B"4'b0100"
            }
            is( B"4'b0100" ) {
              buffer( ndx ).Prediction := B"4'b1000"
            }
            is( B"4'b1000" ) {
              buffer( ndx ).Prediction := B"4'b1000"
            }
          }
        }
        when( brNotTaken ) {
          switch( buffer( ndx ).Prediction ) {
            is( B"4'b0001" ) {
              buffer( ndx ).Prediction := B"4'b0001"
            }
            is( B"4'b0010" ) {
              buffer( ndx ).Prediction := B"4'b0001"
            }
            is( B"4'b0100" ) {
              buffer( ndx ).Prediction := B"4'b0010"
            }
            is( B"4'b1000" ) {
              buffer( ndx ).Prediction := B"4'b0100"
            }
          }
        }
      }
    }

  }

  lru.accessing <> lruAccess
  lruCurrent := lru.update
  lru.current <> lruCurrent

}
