vsim -t 1ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L ../../output/modelsim -L work -voptargs="+acc"  tb

vcd on
vcd file ../../output/modelsim/sim.vcd
vcd add -r *

#run 30 ms
#run 20 ms
#run 10 ms
#run 4 ms
run 1 ms
#run 5 us
#run 1 us

exit
