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

  //User Counter/Timers

  //0xC00/0xC80 Counter
  val counter = Reg( UInt( 64 bits ) )
  counter init ( 0)
  counter := counter + 1

  //0xC01/0xC81 Timer
  // In ns, at 50MHz is 20 ticks per cycle
  val timer = Reg( UInt( 64 bits ) )
  timer init ( 0)
  timer := timer + 20

  //0xC02/0xC82 Retired Counter
  val retired_counter = Reg( UInt( 64 bits ) )
  retired_counter init ( 0)
  when( retired ) {
    retired_counter := retired_counter + 1
  } otherwise {
    retired_counter := retired_counter
  }

  //0xC03/0xC83 Branch Counter
  val branch_counter = Reg( UInt( 64 bits ) )
  branch_counter init ( 0)
  when( brTaken || brNotTaken ) {
    branch_counter := branch_counter + 1
  } otherwise {
    branch_counter := branch_counter
  }

  //0xC04/0xC84 Branch Miss Counter
  val brmiss_counter = Reg( UInt( 64 bits ) )
  brmiss_counter init ( 0)
  when( misfetch ) {
    brmiss_counter := brmiss_counter + 1
  } otherwise {
    brmiss_counter := brmiss_counter
  }

  //Machine Information Registers

  //0xF11 MRO mvendorid Vendor ID.
  val mvendorid = Reg( Bits( 32 bits ) )
  mvendorid init ( 0)

  //0xF12 MRO marchid Architecture ID.
  val marchid = Reg( Bits( 32 bits ) )
  marchid init ( 0)

  //0xF13 MRO mimpid Implementation ID.
  val mimpid = Reg( Bits( 32 bits ) )
  mimpid init ( 0)

  //0xF14 MRO mhartid Hardware thread ID.
  val mhartid = Reg( Bits( 32 bits ) )
  mhartid init ( 0)

  //Machine Trap Setup

  //0x300 MRW mstatus Machine status register.
  case class MStatus() extends Bundle {
    val SD = Bool
    val WRPI3 = Bits( 8 bits )
    val TSR = Bool
    val TW = Bool
    val TVM = Bool
    val MXR = Bool
    val SUM = Bool
    val MPRV = Bool
    val XS = Bits( 2 bits )
    val FS = Bits( 2 bits )
    val MPP = Bits( 2 bits )
    val WPRI2 = Bits( 2 bits )
    val SPP = Bool
    val MPIE = Bool
    val WPRI1 = Bool
    val SPIE = Bool
    val UPIE = Bool
    val MIE = Bool
    val WPRI0 = Bool
    val SIE = Bool
    val UIE = Bool
  }
  val mstatus = Reg( MStatus() )
  mstatus.SD init ( False)
  mstatus.WRPI3 init ( 0)
  mstatus.TSR init ( False)
  mstatus.TW init ( False)
  mstatus.TVM init ( False)
  mstatus.MXR init ( False)
  mstatus.SUM init ( False)
  mstatus.MPRV init ( False)
  mstatus.XS init ( 0)
  mstatus.FS init ( 0)
  mstatus.MPP init ( 0)
  mstatus.WPRI2 init ( 0)
  mstatus.SPP init ( False)
  mstatus.MPIE init ( False)
  mstatus.WPRI1 init ( False)
  mstatus.SPIE init ( False)
  mstatus.UPIE init ( False)
  mstatus.MIE init ( False)
  mstatus.WPRI0 init ( False)
  mstatus.SIE init ( False)
  mstatus.UIE init ( False)

  //0x301 MRW misa ISA and extensions
  case class MISA() extends Bundle {
    case class MISAExtensions() extends Bundle {
      val Z = Bool //Reserved
      val Y = Bool //Reserved
      val X = Bool //Non-standard extensions present
      val W = Bool //Reserved
      val V = Bool //Tentatively reserved for Vector extension
      val U = Bool //User mode implemented
      val T = Bool //Tentatively reserved for Transactional Memory extension
      val S = Bool //Supervisor mode implemented
      val R = Bool //Reserved
      val Q = Bool //Quad-precision floating-point extension
      val P = Bool //Tentatively reserved for Packed-SIMD extension
      val O = Bool //Reserved
      val N = Bool //User-level interrupts supported
      val M = Bool //Integer Multiply/Divide extension
      val L = Bool //Tentatively reserved for Decimal Floating-Point extension
      val K = Bool //Reserved
      val J =
        Bool       //Tentatively reserved for Dynamically Translated Languages extension
      val I = Bool //RV32I/64I/128I base ISA
      val H = Bool //Hypervisor extension
      val G = Bool //Additional standard extensions present
      val F = Bool //Single-precision floating-point extension
      val E = Bool //RV32E base ISA
      val D = Bool //Double-precision floating-point extension
      val C = Bool //Compressed extension
      val B = Bool //Tentatively reserved for Bit-Manipulation extension
      val A = Bool //Atomic extension
    }
    val MXL = Bits( 2 bits )
    val WLRL = Bits( 4 bits )
    val Ext = MISAExtensions()
  }
  val misa = Reg( MISA() )
  misa.MXL init ( B"2'h1")
  misa.WLRL init ( 0)
  misa.Ext.Z init ( False) //Reserved
  misa.Ext.Y init ( False) //Reserved
  misa.Ext.X init ( False) //Non-standard extensions present
  misa.Ext.W init ( False) //Reserved
  misa.Ext.V init ( False) //Tentatively reserved for Vector extension
  misa.Ext.U init ( False) //User mode implemented
  misa.Ext.T init ( False) //Tentatively reserved for Transactional Memory extension
  misa.Ext.S init ( False) //Supervisor mode implemented
  misa.Ext.R init ( False) //Reserved
  misa.Ext.Q init ( False) //Quad-precision floating-point extension
  misa.Ext.P init ( False) //Tentatively reserved for Packed-SIMD extension
  misa.Ext.O init ( False) //Reserved
  misa.Ext.N init ( False) //User-level interrupts supported
  misa.Ext.M init ( True)  //Integer Multiply/Divide extension
  misa.Ext.L init ( False) //Tentatively reserved for Decimal Floating-Point extension
  misa.Ext.K init ( False) //Reserved
  misa.Ext.J init ( False) //Tentatively reserved for Dynamically Translated Languages extension
  misa.Ext.I init ( True)  //RV32I/64I/128I base ISA
  misa.Ext.H init ( False) //Hypervisor extension
  misa.Ext.G init ( False) //Additional standard extensions present
  misa.Ext.F init ( False) //Single-precision floating-point extension
  misa.Ext.E init ( False) //RV32E base ISA
  misa.Ext.D init ( False) //Double-precision floating-point extension
  misa.Ext.C init ( True)  //Compressed extension
  misa.Ext.B init ( False) //Tentatively reserved for Bit-Manipulation extension
  misa.Ext.A init ( False) //Atomic extension

  //0x302 MRW medeleg Machine exception delegation register.
  val medeleg = Reg( Bits( 32 bits ) )
  medeleg init ( 0)

  //0x303 MRW mideleg Machine interrupt delegation register.
  val mideleg = Reg( Bits( 32 bits ) )
  mideleg init ( 0)

  //0x304 MRW mie Machine interrupt-enable register.
  case class MIE() extends Bundle {
    val WPRI3 = Bits( 20 bits )
    val MEIE = Bool
    val WPRI2 = Bool
    val SEIE = Bool
    val UEIE = Bool
    val MTIE = Bool
    val WPRI1 = Bool
    val STIE = Bool
    val UTIE = Bool
    val MSIE = Bool
    val WPRI0 = Bool
    val SSIE = Bool
    val USIE = Bool
  }
  val mie = Reg( MIE() )
  mie.WPRI3 init ( 0)
  mie.MEIE init ( False)
  mie.WPRI2 init ( False)
  mie.SEIE init ( False)
  mie.UEIE init ( False)
  mie.MTIE init ( False)
  mie.WPRI1 init ( False)
  mie.STIE init ( False)
  mie.UTIE init ( False)
  mie.MSIE init ( False)
  mie.WPRI0 init ( False)
  mie.SSIE init ( False)
  mie.USIE init ( False)

  //0x305 MRW mtvec Machine trap-handler base address.
  case class MTVec() extends Bundle {
    val Base = Bits( 30 bits )
    val Mode = Bits( 2 bits )
  }
  val mtvec = Reg( MTVec() )
  mtvec.Base init ( 0)
  mtvec.Mode init ( 0)

  //0x306 MRW mcounteren Machine counter enable.
  case class MCounterEn() extends Bundle {
    val HPM31 = Bool
    val HPM30 = Bool
    val HPM29 = Bool
    val HPM28 = Bool
    val HPM27 = Bool
    val HPM26 = Bool
    val HPM25 = Bool
    val HPM24 = Bool
    val HPM23 = Bool
    val HPM22 = Bool
    val HPM21 = Bool
    val HPM20 = Bool
    val HPM19 = Bool
    val HPM18 = Bool
    val HPM17 = Bool
    val HPM16 = Bool
    val HPM15 = Bool
    val HPM14 = Bool
    val HPM13 = Bool
    val HPM12 = Bool
    val HPM11 = Bool
    val HPM10 = Bool
    val HPM9 = Bool
    val HPM8 = Bool
    val HPM7 = Bool
    val HPM6 = Bool
    val HPM5 = Bool
    val HPM4 = Bool
    val HPM3 = Bool
    val IR = Bool
    val TM = Bool
    val CY = Bool
  }
  val mcounteren = Reg( MCounterEn() )
  mcounteren.HPM31 init ( False)
  mcounteren.HPM30 init ( False)
  mcounteren.HPM29 init ( False)
  mcounteren.HPM28 init ( False)
  mcounteren.HPM27 init ( False)
  mcounteren.HPM26 init ( False)
  mcounteren.HPM25 init ( False)
  mcounteren.HPM24 init ( False)
  mcounteren.HPM23 init ( False)
  mcounteren.HPM22 init ( False)
  mcounteren.HPM21 init ( False)
  mcounteren.HPM20 init ( False)
  mcounteren.HPM19 init ( False)
  mcounteren.HPM18 init ( False)
  mcounteren.HPM17 init ( False)
  mcounteren.HPM16 init ( False)
  mcounteren.HPM15 init ( False)
  mcounteren.HPM14 init ( False)
  mcounteren.HPM13 init ( False)
  mcounteren.HPM12 init ( False)
  mcounteren.HPM11 init ( False)
  mcounteren.HPM10 init ( False)
  mcounteren.HPM9 init ( False)
  mcounteren.HPM8 init ( False)
  mcounteren.HPM7 init ( False)
  mcounteren.HPM6 init ( False)
  mcounteren.HPM5 init ( False)
  mcounteren.HPM4 init ( False)
  mcounteren.HPM3 init ( False)
  mcounteren.IR init ( False)
  mcounteren.TM init ( False)
  mcounteren.CY init ( False)

  //Machine Trap Handling

  //0x340 MRW mscratch Scratch register for machine trap handlers.
  val mscratch = Reg( Bits( 32 bits ) )
  mscratch init ( 0)

  //0x341 MRW mepc Machine exception program counter.
  val mepc = Reg( Bits( 32 bits ) )
  mepc init ( 0)

  //0x342 MRW mcause Machine trap cause.
  case class MCause() extends Bundle {
    val Interrupt = Bool
    val ExceptionCode = Bits( 31 bits )
  }
  val mcause = Reg( MCause() )
  mcause.Interrupt init ( False)
  mcause.ExceptionCode init ( 0)

  //0x343 MRW mtval Machine bad address or instruction.
  val mtval = Reg( Bits( 32 bits ) )
  mtval init ( 0)

  //0x344 MRW mip Machine interrupt pending.
  case class MIP() extends Bundle {
    val WPRI3 = Bits( 20 bits )
    val MEIP = Bool
    val WPRI2 = Bool
    val SEIP = Bool
    val UEIP = Bool
    val MTIP = Bool
    val WPRI1 = Bool
    val STIP = Bool
    val UTIP = Bool
    val MSIP = Bool
    val WPRI0 = Bool
    val SSIP = Bool
    val USIP = Bool
  }
  val mip = Reg( MIP() )
  mip.WPRI3 init ( 0)
  mip.MEIP init ( False)
  mip.WPRI2 init ( False)
  mip.SEIP init ( False)
  mip.UEIP init ( False)
  mip.MTIP init ( False)
  mip.WPRI1 init ( False)
  mip.STIP init ( False)
  mip.UTIP init ( False)
  mip.MSIP init ( False)
  mip.WPRI0 init ( False)
  mip.SSIP init ( False)
  mip.USIP init ( False)

  //Bus
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

      //0xF11 MRO mvendorid Vendor ID.
      is( U"hF11" ) {
        csrDataRsp.data := B( mvendorid )
      }

      //0xF12 MRO marchid Architecture ID.
      is( U"hF12" ) {
        csrDataRsp.data := B( marchid )
      }

      //0xF13 MRO mimpid Implementation ID.
      is( U"hF13" ) {
        csrDataRsp.data := B( mimpid )
      }

      //0xF14 MRO mhartid Hardware thread ID.
      is( U"hF14" ) {
        csrDataRsp.data := B( mhartid )
      }

      //0x300 MRW mstatus Machine status register.
      is( U"h300" ) {
        csrDataRsp.data := B( mstatus )
      }

      //0x301 MRW misa ISA and extensions
      is( U"h301" ) {
        csrDataRsp.data := B( misa )
      }

      //0x302 MRW medeleg Machine exception delegation register.
      is( U"h302" ) {
        csrDataRsp.data := B( medeleg )
      }

      //0x303 MRW mideleg Machine interrupt delegation register.
      is( U"h303" ) {
        csrDataRsp.data := B( mideleg )
      }

      //0x304 MRW mie Machine interrupt-enable register.
      is( U"h304" ) {
        csrDataRsp.data := B( mie )
      }

      //0x305 MRW mtvec Machine trap-handler base address.
      is( U"h305" ) {
        csrDataRsp.data := B( mtvec )
      }

      //0x306 MRW mcounteren Machine counter enable.
      is( U"h306" ) {
        csrDataRsp.data := B( mcounteren )
      }

      //Machine Trap Handling

      //0x340 MRW mscratch Scratch register for machine trap handlers.
      is( U"h340" ) {
        csrDataRsp.data := B( mscratch )
      }

      //0x341 MRW mepc Machine exception program counter.
      is( U"h341" ) {
        csrDataRsp.data := B( mepc )
      }

      //0x342 MRW mcause Machine trap cause.
      is( U"h342" ) {
        csrDataRsp.data := B( mcause )
      }

      //0x343 MRW mtval Machine bad address or instruction.
      is( U"h343" ) {
        csrDataRsp.data := B( mtval )
      }

      //0x344 MRW mip Machine interrupt pending.
      is( U"h344" ) {
        csrDataRsp.data := B( mip )
      }

      default {}
    }
  }
}
