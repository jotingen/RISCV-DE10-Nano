onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/clk
add wave -noupdate -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/ddr3_clk
add wave -noupdate -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/rst
add wave -noupdate -radix hexadecimal -childformat {{/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Cyc -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Stb -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.We -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Adr -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Sel -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Data -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tga -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tgd -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Cyc {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Stb {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.We {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Adr {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Sel {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Data {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tga {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tgd {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i.Tgc {-radix hexadecimal}} /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_i
add wave -noupdate -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/bus_inst_o
add wave -noupdate -radix hexadecimal -childformat {{/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Cyc -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Stb -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.We -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Adr -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Sel -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Data -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tga -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tgd -radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tgc -radix hexadecimal}} -expand -subitemconfig {/testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Cyc {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Stb {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.We {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Adr {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Sel {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Data {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tga {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tgd {-radix hexadecimal} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i.Tgc {-radix hexadecimal}} /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_i
add wave -noupdate -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/bus_data_o
add wave -noupdate -expand -group {INST CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/set_target
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal -childformat {{{/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[3]} -radix hexadecimal} {{/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[2]} -radix hexadecimal} {{/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[1]} -radix hexadecimal} {{/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0]} -radix hexadecimal -childformat {{Vld -radix hexadecimal} {Addr -radix hexadecimal} {Dirty -radix hexadecimal} {Data -radix hexadecimal}}}} -subitemconfig {{/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[3]} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[2]} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[1]} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0]} {-radix hexadecimal -childformat {{Vld -radix hexadecimal} {Addr -radix hexadecimal} {Dirty -radix hexadecimal} {Data -radix hexadecimal}}} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0].Vld} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0].Addr} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0].Dirty} {-radix hexadecimal} {/testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer[0].Data} {-radix hexadecimal}} /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/bus_req_stgd
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/bus_rd_ack
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/mem_buffer_in_lru
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/state_idle
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/state_flush
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/state_load
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/state_load_pending
add wave -noupdate -expand -group {INST CACHE} -radix hexadecimal /testrunner/__ts/ddr3_ut/my_ddr3/inst_cache/state_update
add wave -noupdate -expand -group {MEM CACHE} -expand /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/set_target
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_idle
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_flush
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_flushall
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_load
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_load_pending
add wave -noupdate -expand -group {MEM CACHE} /testrunner/__ts/ddr3_ut/my_ddr3/mem_cache/state_update
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2268360 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 301
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {2218871 ps} {2317849 ps}
