package riscv

import spinal.core._
import spinal.lib._

//Hardware definition
class riscv_exu extends Component {
  val instDecoded = in(InstDecoded())
  val freeze      = out(Bool)

  when(instDecoded.Vld) {
    freeze := True
  } otherwise {
    freeze := False
  }
}
