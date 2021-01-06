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
  val Compressed = Bool()
}

//Hardware definition
class riscv_ibp( config: riscv_config ) extends Component {
  val misfetch = in( Bool )
  val misfetchPC = in( UInt( 32 bits ) )
  val misfetchAdr = in( UInt( 32 bits ) )
  val brTaken = in( Bool )
  val brNotTaken = in( Bool )
  val brCompressed = in( Bool )
  val brPC = in( UInt( 32 bits ) )
  val adr = in( UInt( 32 bits ) )
  val sel = out( Bits( 4 bits ) )
  val adrNext = out( UInt( 32 bits ) )
  val selNext = out( Bits( 4 bits ) )

  val lru = new mor1kx_cache_lru_accessfix( config.branchPredSize )
  val lruCurrent = Reg( Bits )
  val lruAccess = Bits( config.branchPredSize bits )
  lruCurrent init ( 0)

  val buffer = Vec( Reg( BrBuffEntry() ), config.branchPredSize )
  for (ndx <- buffer.indices) {
    buffer( ndx ).Adr init ( ndx * 4)
    buffer( ndx ).AdrNext init ( ndx * 4 + 4)
    buffer( ndx ).Prediction init ( B"4'b0010")
    buffer( ndx ).Compressed init ( False)
  }

  sel := B"4'b1111"

  when( misfetch && ( brTaken || brNotTaken) ) {

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
        buffer( ndx ).Compressed := brCompressed
      }
    }

    adrNext := misfetchAdr
    //when( misfetchAdr( 1 ) ) {
    //  selNext := B"4'b0011"
    //} otherwise {
    //  selNext := B"4'b1111"
    //  //If the misfetch address is in the buffer
    //  //check if it is compressed
    //  for (ndx <- buffer.indices) {
    //    when( buffer( ndx ).Adr === misfetchAdr ) {
    //      when( buffer( ndx ).Compressed ) {
    //        when( misfetchAdr( 1 ) ) {
    //          selNext := B"4'b0011"
    //        } otherwise {
    //          selNext := B"4'b1100"
    //        }
    //      }
    //    }
    //  }
    //}

  } otherwise {

    when( adr( 1 ) ) {
      adrNext := adr + 2
      sel := B"4'b0011"
    } otherwise {
      adrNext := adr + 4
      sel := B"4'b1111"
    }

    //Mark entry accessed if address matched
    //Use stored address if so
    for (ndx <- buffer.indices) {
      when( buffer( ndx ).Adr === adr ) {
        lruAccess( ndx ) := True
        adrNext := buffer( ndx ).AdrNext
        when( buffer( ndx ).Compressed ) {
          when( adr( 1 ) ) {
            sel := B"4'b0011"
          } otherwise {
            sel := B"4'b1100"
          }
        }
      } otherwise {
        lruAccess( ndx ) := False
      }
    }

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
