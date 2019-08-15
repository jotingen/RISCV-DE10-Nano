transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src/ram_1rw_8192x16 {D:/Users/James/NextCloud/Quartus/LC3/src/ram_1rw_8192x16/ram_1rw_8192x16.v}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/LC3_pkg.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/sccb.v}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/shield_display.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/shield_v1.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/lc3.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/lc3_mem_base.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/lc3_core.sv}
vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/src {D:/Users/James/NextCloud/Quartus/LC3/src/lc3_ifu.sv}

vlog -sv -work work +incdir+D:/Users/James/NextCloud/Quartus/LC3/verif {D:/Users/James/NextCloud/Quartus/LC3/verif/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

#add wave *
#view structure
#view signals
#log * -r

vcd on
vcd file LC3.vcd
show -all
vcd add -r *

run 1000 ms

exit
