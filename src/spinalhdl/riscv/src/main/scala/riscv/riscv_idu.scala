package riscv

import spinal.core._
import spinal.lib._


object InstOp extends SpinalEnum(defaultEncoding=binaryOneHot) {
    val LUI, AUIPC,
        JAL, JALR,
        BEQ, BNE, BLT, BGE, BLTU, BGEU,
        LB, LH, LW, LBU, LHU,
        SB, SH, SW,
        ADDI,
        SLTI, SLTIU,
        XORI, ORI,
        ANDI,
        SLLI, SRLI, SRAI,
        ADD, SUB,
        SLL, SLT, SLTU,
        XOR,
        SRL, SRA,
        OR, AND,
        FENCE, FENCEI,
        ECALL,
        CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI,
        EBREAK,
        MUL, MULH, MULHSU, MULHU,
        DIV, DIVU, REM, REMU,
        TRAP = newElement()
}

case class InstDecoded() extends Bundle {
  val Vld    = Bool
  val Adr    = UInt(32 bits)
  val AdrNext    = UInt(32 bits)
  val Data   = Bits(32 bits)
  val Op     = InstOp()
  val Rd     = Bits(5  bits)
  val Rs1    = Bits(5  bits)
  val Rs2    = Bits(5  bits)
  val Immed  = Bits(32 bits)
  val CSR    = Bits(12 bits)
  val Pred   = Bits(4  bits)
  val Succ   = Bits(4  bits)
}
//Hardware definition
class riscv_idu extends Component {
  val inst        = in(Inst())
  val misfetch    = in(Bool)
  val freeze      = in(Bool)
  val instDecoded = out(Reg(InstDecoded()))

  instDecoded.Vld init(False)

  when(misfetch) {
    //instDecoded := instDecoded
    instDecoded.Vld := False
  } elsewhen(freeze) {
    instDecoded := instDecoded
  } elsewhen(inst.Vld) {
    val opcode = Bits(7  bits)
    val funct3 = Bits(3  bits)
    val funct7 = Bits(7  bits)
    val immedI = Bits(32 bits)
    val immedS = Bits(32 bits)
    val immedB = Bits(32 bits)
    val immedU = Bits(32 bits)
    val immedJ = Bits(32 bits)
    val instData31Repeat = Vec(Bool,32) //Create a vector for bit31, not sure how to do repititions in spinal yet 
    opcode := inst.Data(6 downto 0)
    funct3 := inst.Data(14 downto 12)
    funct7 := inst.Data(31 downto 25)
    for(bit <- instData31Repeat) {
      bit := inst.Data(31)
    }
    immedI := Cat(instData31Repeat.asBits(31 downto 11), inst.Data(30 downto 25), inst.Data(24 downto 21), inst.Data(20) )
    immedS := Cat(instData31Repeat.asBits(31 downto 11), inst.Data(30 downto 25), inst.Data(11 downto 8) , inst.Data(7) )
    immedB := Cat(instData31Repeat.asBits(31 downto 12), inst.Data(7)           , inst.Data(30 downto 25), inst.Data(11 downto 8) , B"1'h0" )
    immedU := Cat(instData31Repeat.asBits(31)          , inst.Data(30 downto 20), inst.Data(19 downto 12), B"12'h000" )
    immedJ := Cat(instData31Repeat.asBits(31 downto 20), inst.Data(19 downto 12), inst.Data(20)          , inst.Data(30 downto 25), inst.Data(24 downto 21), B"1'h0" )

    instDecoded.Vld  := inst.Vld 
    instDecoded.Adr  := inst.Adr 
    instDecoded.AdrNext  := inst.AdrNext 
    instDecoded.Data := inst.Data
    instDecoded.Rd     := inst.Data(11 downto 7)
    instDecoded.Rs1    := inst.Data(19 downto 15)
    instDecoded.Rs2    := inst.Data(24 downto 20)
    instDecoded.CSR  := inst.Data(31 downto 20)
    instDecoded.Pred := inst.Data(27 downto 24)
    instDecoded.Succ := inst.Data(23 downto 20)
    switch(opcode) {
      is(B"7'b0110111") {
        instDecoded.Op     := InstOp.LUI
        instDecoded.Immed  := immedU
      }
      is(B"7'b0010111") {
        instDecoded.Op     := InstOp.AUIPC
        instDecoded.Immed  := immedU
      }
      is(B"7'b1101111") {
        instDecoded.Op     := InstOp.JAL
        instDecoded.Immed  := immedJ
      }
      is(B"7'b1100111") {
        switch(funct3) {
          is(B"3'b000") {
            instDecoded.Op     := InstOp.JALR
            instDecoded.Immed  := immedI
          }
          default { 
            instDecoded.Op     := InstOp.TRAP
          }
        }
      }
      is(B"7'b1100011") {
        switch(funct3) {
          is(B"3'b000") {
            instDecoded.Op     := InstOp.BEQ
            instDecoded.Immed  := immedB
          }
          is(B"3'b001") {
            instDecoded.Op     := InstOp.BNE
            instDecoded.Immed  := immedB
          }
          is(B"3'b100") {
            instDecoded.Op     := InstOp.BLT
            instDecoded.Immed  := immedB
          }
          is(B"3'b101") {
            instDecoded.Op     := InstOp.BGE
            instDecoded.Immed  := immedB
          }
          is(B"3'b110") {
            instDecoded.Op     := InstOp.BLTU
            instDecoded.Immed  := immedB
          }
          is(B"3'b111") {
            instDecoded.Op     := InstOp.BGEU
            instDecoded.Immed  := immedB
          }
          default { 
            instDecoded.Op     := InstOp.TRAP
          }
        }
      }
      is(B"7'b0000011") {
        switch(funct3) {
          is(B"3'b000") {
            instDecoded.Op     := InstOp.LB
            instDecoded.Immed  := immedI
          }
          is(B"3'b001") {
            instDecoded.Op     := InstOp.LH
            instDecoded.Immed  := immedI
          }
          is(B"3'b010") {
            instDecoded.Op     := InstOp.LW
            instDecoded.Immed  := immedI
          }
          is(B"3'b100") {
            instDecoded.Op     := InstOp.LBU
            instDecoded.Immed  := immedI
          }
          is(B"3'b101") {
            instDecoded.Op     := InstOp.LHU
            instDecoded.Immed  := immedI
          }
          default { 
            instDecoded.Op     := InstOp.TRAP
          }
        }
      }
      is(B"7'b0100011") {
        switch(funct3) {
          is(B"3'b000") {
            instDecoded.Op     := InstOp.SB
            instDecoded.Immed  := immedS
          }
          is(B"3'b001") {
            instDecoded.Op     := InstOp.SH
            instDecoded.Immed  := immedS
          }
          is(B"3'b010") {
            instDecoded.Op     := InstOp.SW
            instDecoded.Immed  := immedS
          }
          default { 
            instDecoded.Op     := InstOp.TRAP
          }
        }
      }
      is(B"7'b0010011") {
        switch(funct3) {
          is(B"3'b000") {
            instDecoded.Op     := InstOp.ADDI
            instDecoded.Immed  := immedI
          }
          is(B"3'b010") {
            instDecoded.Op     := InstOp.SLTI
            instDecoded.Immed  := immedI
          }
          is(B"3'b011") {
            instDecoded.Op     := InstOp.SLTIU
            instDecoded.Immed  := immedI
          }
          is(B"3'b100") {
            instDecoded.Op     := InstOp.XORI
            instDecoded.Immed  := immedI
          }
          is(B"3'b110") {
            instDecoded.Op     := InstOp.ORI
            instDecoded.Immed  := immedI
          }
          is(B"3'b111") {
            instDecoded.Op     := InstOp.ANDI
            instDecoded.Immed  := immedI
          }
          is(B"3'b001") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SLLI
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b101") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SRLI
              }
              is(B"7'b0100000") {
                instDecoded.Op     := InstOp.SRAI
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          //default { 
          //  instDecoded.Op     := InstOp.TRAP
          //}
        }
      }
      is(B"7'b0110011") {
        switch(funct3) {
          is(B"3'b000") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.ADD
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.MUL
              }
              is(B"7'b0100000") {
                instDecoded.Op     := InstOp.SUB
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b001") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SLL
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.MULH
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b010") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SLT
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.MULHSU
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b011") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SLTU
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.MULHU
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b100") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.XOR
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.DIV
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b101") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.SRL
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.DIVU
              }
              is(B"7'b0100000") {
                instDecoded.Op     := InstOp.SRA
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b110") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.OR
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.REM
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b111") {
            switch(funct7) {
              is(B"7'b0000000") {
                instDecoded.Op     := InstOp.AND
              }
              is(B"7'b0000001") {
                instDecoded.Op     := InstOp.REMU
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          //default { 
          //  instDecoded.Op     := InstOp.TRAP
          //}
        }
      }
      is(B"7'b0001111") {
        instDecoded.Op     := InstOp.FENCE
      }
      is(B"7'b1110011") {
        switch(funct3) {
          is(B"3'b000") {
            switch(inst.Data(31 downto 20)) {
              is(B"12'b000000000000") {
                instDecoded.Op     := InstOp.ECALL
              }
              is(B"12'b000000000001") {
                instDecoded.Op     := InstOp.EBREAK
              }
              default { 
                instDecoded.Op     := InstOp.TRAP
              }
            }
          }
          is(B"3'b001") {
            instDecoded.Op     := InstOp.CSRRW
          }
          is(B"3'b010") {
            instDecoded.Op     := InstOp.CSRRS
          }
          is(B"3'b011") {
            instDecoded.Op     := InstOp.CSRRC
          }
          is(B"3'b101") {
            instDecoded.Op     := InstOp.CSRRWI
          }
          is(B"3'b110") {
            instDecoded.Op     := InstOp.CSRRSI
          }
          is(B"3'b111") {
            instDecoded.Op     := InstOp.CSRRCI
          }
          default { 
            instDecoded.Op     := InstOp.TRAP
          }
        }
      }
      default {
        instDecoded.Op     := InstOp.TRAP
      }
    }

  } otherwise {
    instDecoded.Vld := False
  }
  instDecoded.Vld init(False)
}
