transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/quartus/ram_1rw_8192x16 {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/quartus/ram_1rw_8192x16/ram_1rw_8192x16.v}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv/LC3_pkg.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/st7735r {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/st7735r/shield_display.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/shield {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/shield/shield_v1.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/RISCV.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/lc3_mem_base.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv/lc3_core.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/src/riscv/lc3_ifu.sv}

vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/verif {D:/Users/James/NextCloud/Quartus/RISCV-DE10-Nano/verif/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

#add wave *
#view structure
#view signals
#log * -r

vcd on
vcd file RISCV.vcd
show -all
vcd add -r *

run 10 ms

exit
