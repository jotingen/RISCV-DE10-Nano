onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/clk
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/arst
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/rst
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/LED
add wave -noupdate -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i
add wave -noupdate -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o
add wave -noupdate -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i
add wave -noupdate -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o
add wave -noupdate -group DDR3 -radix hexadecimal -radixshowbase 1 /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i
add wave -noupdate -group DDR3 -radix hexadecimal -radixshowbase 1 /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_0
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_1
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_2
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_3
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_4
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_5
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_6
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_7
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_8
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_9
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_10
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_11
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_12
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_13
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_14
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_15
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_16
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_17
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_18
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_19
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_20
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_21
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_22
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_23
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_24
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_25
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_26
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_27
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_28
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_29
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_30
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_31
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/order
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/capture
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/order
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Adr
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_AdrNext
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_CSR
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Data
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Immed
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Pred
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Rs2
add wave -noupdate -expand -group RISCV -height 16 -expand -group CSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/csu/inst_Succ
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/capture
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/order
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Adr
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_AdrNext
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_CSR
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Data
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Immed
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Pred
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rs2
add wave -noupdate -expand -group RISCV -height 16 -expand -group ALU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Succ
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/capture
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/state_1__string
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_cyc
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_stb
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_we
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_adr
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_sel
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_data
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_tga
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_tgd
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_tgc
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_stall
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_ack
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_err
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_rty
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_data
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_tga
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_tgd
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_tgc
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/order
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Adr
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_AdrNext
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Data
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Rs2
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Immed
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_CSR
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Pred
add wave -noupdate -expand -group RISCV -height 16 -expand -group LSU -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Succ
add wave -noupdate -height 16 -expand -group RVFI -radix binary -childformat {{{/testrunner/__ts/soc_ut/rvfi_valid[5]} -radix binary} {{/testrunner/__ts/soc_ut/rvfi_valid[4]} -radix binary} {{/testrunner/__ts/soc_ut/rvfi_valid[3]} -radix binary} {{/testrunner/__ts/soc_ut/rvfi_valid[2]} -radix binary} {{/testrunner/__ts/soc_ut/rvfi_valid[1]} -radix binary} {{/testrunner/__ts/soc_ut/rvfi_valid[0]} -radix binary}} -expand -subitemconfig {{/testrunner/__ts/soc_ut/rvfi_valid[5]} {-height 15 -radix binary} {/testrunner/__ts/soc_ut/rvfi_valid[4]} {-height 15 -radix binary} {/testrunner/__ts/soc_ut/rvfi_valid[3]} {-height 15 -radix binary} {/testrunner/__ts/soc_ut/rvfi_valid[2]} {-height 15 -radix binary} {/testrunner/__ts/soc_ut/rvfi_valid[1]} {-height 15 -radix binary} {/testrunner/__ts/soc_ut/rvfi_valid[0]} {-height 15 -radix binary}} /testrunner/__ts/soc_ut/rvfi_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI5 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_5_csr_mcycle_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI4 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_4_csr_mcycle_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI3 /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_3_csr_mcycle_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI2 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_2_csr_mcycle_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -group RVFI1 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_1_csr_mcycle_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_valid
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_trap
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rs2_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rs2_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rs1_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rs1_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rd_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_rd_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_pc_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_pc_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_order
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mode
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mem_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mem_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mem_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mem_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_mem_addr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_intr
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_insn
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_halt
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_minstret_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_minstret_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_minstret_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_minstret_rdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_mcycle_wmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_mcycle_wdata
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_mcycle_rmask
add wave -noupdate -height 16 -expand -group RVFI -height 16 -expand -group RVFI0 -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/rvfi_0_csr_mcycle_rdata
add wave -noupdate -radix decimal -childformat {{{/testrunner/__ts/soc_ut/errcode[15]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[14]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[13]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[12]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[11]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[10]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[9]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[8]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[7]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[6]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[5]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[4]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[3]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[2]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[1]} -radix decimal} {{/testrunner/__ts/soc_ut/errcode[0]} -radix decimal}} -subitemconfig {{/testrunner/__ts/soc_ut/errcode[15]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[14]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[13]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[12]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[11]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[10]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[9]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[8]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[7]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[6]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[5]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[4]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[3]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[2]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[1]} {-height 15 -radix decimal} {/testrunner/__ts/soc_ut/errcode[0]} {-height 15 -radix decimal}} /testrunner/__ts/soc_ut/errcode
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/LED
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/bus_data_i
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/bus_data_o
add wave -noupdate -group DEBUG -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Cyc {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Stb {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.We {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Adr {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Sel {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i
add wave -noupdate -group DEBUG -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Stall {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Ack {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Err {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Rty {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_idle
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_cmd_sending
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_data_pending
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_data_recieved
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_data_recieving
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_rsp_pending
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_rsp_recieved
add wave -noupdate -expand -group SDCARD /testrunner/__ts/soc_ut/de10nano/shield/sdcard/state_spi_req
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1953680 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 253
configure wave -valuecolwidth 121
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4897872 ps}
