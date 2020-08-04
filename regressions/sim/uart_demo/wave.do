onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/clk
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/arst
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/rst
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/LED
add wave -noupdate -expand -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_i
add wave -noupdate -expand -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_inst_o
add wave -noupdate -expand -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgc -radix hexadecimal}} -radixshowbase 1 -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_i
add wave -noupdate -expand -group FLASH -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgc -radix hexadecimal}} -radixshowbase 1 -subitemconfig {/testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/mem/bus_data_o
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgc -radix hexadecimal}} -radixshowbase 1 -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Cyc {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Stb {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.We {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Adr {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Sel {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_i
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgc -radix hexadecimal}} -radixshowbase 1 -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Stall {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Ack {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Err {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Rty {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Data {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tga {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgd {-height 16 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o.Tgc {-height 16 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_inst_o
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Cyc {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Stb {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.We {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Adr {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Sel {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Data {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tga {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tgd {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i.Tgc {-height 15 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_i
add wave -noupdate -group DDR3 -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tgc -radix hexadecimal}} -radixshowbase 1 -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Stall {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Ack {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Err {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Rty {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Data {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tga {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tgd {-height 15 -radix hexadecimal -radixshowbase 1} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o.Tgc {-height 15 -radix hexadecimal -radixshowbase 1}} /testrunner/__ts/soc_ut/de10nano/ddr3/bus_data_o
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_addr
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_rd
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_rdata
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_rdata_valid
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_read_req
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_ready
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_size
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_wait
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_wdata
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_wr
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/ddr3_avl_write_req
add wave -noupdate -group DDR3 /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/mem_buffer_in_lru
add wave -noupdate -group DDR3 -radix unsigned /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/mem_buffer_lru_entry
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_flush
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_flushall
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_idle
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_load
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_load_pending
add wave -noupdate /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/state_update
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/flush_setndx
add wave -noupdate -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/flush_wayndx
add wave -noupdate -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Cyc {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Stb {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.We {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Adr {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Sel {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/ddr3/mem_cache/dst_i
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_tgc
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_tgd
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_tga
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_sel
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_we
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_stb
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_req_cyc
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_ack
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_err
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_rty
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_tga
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_tgd
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/busInst_rsp_tgc
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_wrNdx
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_wrDataNdx
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_rdNdx
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_0_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_0_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_0_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_1_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_1_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_1_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_2_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_2_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_2_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_3_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_3_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_3_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_4_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_4_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_4_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_5_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_5_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_5_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_6_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_6_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_6_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_7_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_7_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_7_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_8_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_8_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_8_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_9_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_9_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_9_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_10_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_10_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_10_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_11_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_11_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_11_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_12_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_12_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_12_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_13_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_13_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_13_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_14_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_14_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_14_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_15_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_15_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_15_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_16_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_16_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_16_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_17_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_17_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_17_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_18_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_18_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_18_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_19_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_19_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_19_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_20_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_20_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_20_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_21_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_21_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_21_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_22_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_22_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_22_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_23_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_23_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_23_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_24_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_24_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_24_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_25_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_25_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_25_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_26_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_26_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_26_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_27_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_27_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_27_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_28_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_28_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_28_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_29_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_29_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_29_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_30_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_30_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_30_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_31_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_31_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/buf_buffer_31_Data
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/ifu/token
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/inst_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/inst_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/inst_AdrNext
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/ifu/inst_Data
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Vld
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Adr
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Data
add wave -noupdate -expand -group RISCV -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Op_string
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Rd
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Rs1
add wave -noupdate -expand -group RISCV -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Rs2
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Immed
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_CSR
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Pred
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/idu/instDecoded_Succ
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/aluOp
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/aluHazard
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/bruOp
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/bruHazard
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/freeze
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/misfetch
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/misfetchAdr
add wave -noupdate -expand -group RISCV -height 16 -group alu /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/busy
add wave -noupdate -expand -group RISCV -height 16 -group alu /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/done
add wave -noupdate -expand -group RISCV -height 16 -group alu /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/rs1Data
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rs2
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/rs2Data
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Immed
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -group alu /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/wr
add wave -noupdate -expand -group RISCV -height 16 -group alu -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/ndx
add wave -noupdate -expand -group RISCV -height 16 -group alu /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu/data
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/busy
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/done
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/rs1Data
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Rs2
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/rs2Data
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Immed
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix unsigned /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -group bru /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/misfetch
add wave -noupdate -expand -group RISCV -height 16 -group bru -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru/PCNext
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/capture
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busy
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/done
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/pendingRsp
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Vld
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix ascii /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Op_string
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix decimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Rs1
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix decimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/inst_Rd
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_cyc
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_stb
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_adr
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_sel
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_req_data
add wave -noupdate -expand -group RISCV -height 16 -expand -group lsu -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/lsu/busData_rsp_ack
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_31
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_30
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_29
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_28
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_27
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_26
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_25
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_24
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_23
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_22
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_21
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_20
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_19
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_18
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_17
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_16
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_15
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_14
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_13
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_12
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_11
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_10
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_9
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_8
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_7
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_6
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_5
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_4
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_3
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_2
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_1
add wave -noupdate -expand -group RISCV -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/riscv/exu/x_0
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/clk
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru_done
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/bru_wr
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu_done
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu_wr
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/_zz_1_
add wave -noupdate -expand -group RISCV /testrunner/__ts/soc_ut/de10nano/riscv/exu/alu_data
add wave -noupdate -expand -group RISCV -expand -group EXU -height 16 -expand -group DPU -divider -height 15 <NULL>
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/LED
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/bus_data_i
add wave -noupdate -group LED /testrunner/__ts/soc_ut/de10nano/led/bus_data_o
add wave -noupdate -group DEBUG -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Cyc {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Stb {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.We {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Adr {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Sel {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_i
add wave -noupdate -group DEBUG -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Stall {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Ack {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Err {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Rty {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/debug/bus_data_o
add wave -noupdate -expand -group SDCARD -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Cyc {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Stb {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.We {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Adr {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Sel {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_i
add wave -noupdate -expand -group SDCARD -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Stall {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Ack {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Err {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Rty {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/bus_data_o
add wave -noupdate -expand -group SDCARD -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_rdack
add wave -noupdate -expand -group SDCARD -radix hexadecimal -childformat {{{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[12]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[11]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[10]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[9]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[8]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[7]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[6]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[5]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[4]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[3]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[2]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[1]} -radix hexadecimal} {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[0]} -radix hexadecimal}} -subitemconfig {{/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[12]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[11]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[10]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[9]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[8]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[7]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[6]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[5]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[4]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[3]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[2]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[1]} {-height 15 -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx[0]} {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrndx
add wave -noupdate -expand -group SDCARD -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/shield/sdcard/data_in_fifo_wrreq
add wave -noupdate -expand -group SDCARD -radix hexadecimal /testrunner/__ts/soc_ut/de10nano/shield/sdcard/data
add wave -noupdate -expand -group UART -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Cyc {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Stb {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.We {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Adr {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Sel {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_i
add wave -noupdate -expand -group UART -radix hexadecimal -childformat {{/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Stall -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Ack -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Err -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Rty -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Data -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tga -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tgd -radix hexadecimal} {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Stall {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Ack {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Err {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Rty {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Data {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tga {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tgd {-height 15 -radix hexadecimal} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o.Tgc {-height 15 -radix hexadecimal}} /testrunner/__ts/soc_ut/de10nano/uart/bus_data_o
add wave -noupdate -expand -group UART /testrunner/__ts/soc_ut/de10nano/uart/RTS
add wave -noupdate -expand -group UART /testrunner/__ts/soc_ut/de10nano/uart/TXD
add wave -noupdate -expand -group UART /testrunner/__ts/soc_ut/de10nano/uart/RTS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2160 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 136
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
WaveRestoreZoom {1277 ps} {2625 ps}
