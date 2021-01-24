onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /led_top/clk
add wave -noupdate -radix hexadecimal /led_top/reset
add wave -noupdate -radix hexadecimal /led_top/LED
add wave -noupdate -radix hexadecimal /led_top/bus_req_cyc
add wave -noupdate -radix hexadecimal /led_top/bus_req_stb
add wave -noupdate -radix hexadecimal /led_top/bus_req_we
add wave -noupdate -radix hexadecimal /led_top/bus_req_adr
add wave -noupdate -radix hexadecimal /led_top/bus_req_sel
add wave -noupdate -radix hexadecimal /led_top/bus_req_data
add wave -noupdate -radix hexadecimal /led_top/bus_req_tga
add wave -noupdate -radix hexadecimal /led_top/bus_req_tgc
add wave -noupdate -radix hexadecimal /led_top/bus_req_tgd
add wave -noupdate -radix hexadecimal /led_top/bus_stall
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_ack
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_err
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_rty
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_data
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_tga
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_tgc
add wave -noupdate -radix hexadecimal /led_top/bus_rsp_tgd
add wave -noupdate -divider {New Divider}
add wave -noupdate /led_top/wishBoneAsserts_1_/reset_seen
add wave -noupdate /led_top/wishBoneAsserts_1_/reset
add wave -noupdate /led_top/wishBoneSlaveAsserts_1_/reqInFlight
add wave -noupdate /led_top/wishBoneAsserts_1_/reqQueueWrNdx
add wave -noupdate /led_top/wishBoneAsserts_1_/reqQueueRdNdx
add wave -noupdate /led_top/wishBoneAsserts_1_/assert_tga
add wave -noupdate /led_top/wishBoneAsserts_1_/assert_tgc
add wave -noupdate /led_top/wishBoneAsserts_1_/assert_tgd
add wave -noupdate -divider {New Divider}
add wave -noupdate /led_top/wishBoneAsserts_1_/assert_tgc
add wave -noupdate /led_top/wishBoneAsserts_1_/reqOutgoing_tgc
add wave -noupdate /led_top/wishBoneAsserts_1_/rsp_tgc
add wave -noupdate /led_top/wishBoneAsserts_1_/reqQueueRdNdx
add wave -noupdate /led_top/wishBoneAsserts_1_/rsp_ack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {221 ns}
