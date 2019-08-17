transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../src/quartus/PLL             {../../src/quartus/PLL/PLL.v}
vlog -vlog01compat -work work +incdir+../../src/quartus/ram_1rw_8192x16 {../../src/quartus/ram_1rw_8192x16/ram_1rw_8192x16.v}

vlog -sv -work work +incdir+../../src {../../src/de10nano.sv}

vlog -sv -work work +incdir+../../src/riscv   {../../src/riscv/riscv_pkg.sv}
vlog -sv -work work +incdir+../../src/riscv   {../../src/riscv/riscv.sv}
vlog -sv -work work +incdir+../../src/riscv   {../../src/riscv/riscv_ifu.sv}

vlog -sv -work work +incdir+../../src/mem {../../src/mem/mem.sv}

vlog -sv -work work +incdir+../../src/shield  {../../src/shield/shield_v1.sv}

vlog -sv -work work +incdir+../../src/st7735r {../../src/st7735r/st7735r.sv}

vlog -sv -work work +incdir+../../verif {../../verif/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

vcd on
vcd file sim.vcd
show -all
vcd add -r *

run 10 ms

exit
