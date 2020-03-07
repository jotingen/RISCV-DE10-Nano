vsim -t 1ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L ../../output/modelsim -L work -voptargs="+acc"  tb


#  #run 32 ms
#  
#  #run 20 ms
#  #run 16 ms
#  #run 4 ms
#  #run 1 ms
#  #run 5 us
#  #run 1 us
#  
#  vcd on
#  vcd file ../../output/modelsim/sim.vcd
#  vcd add -r *
#  
#  #run 1 us
#  #run 25 ms
#  
#  #run 5 ms
#  
#  run 34 ms

set time 35

for {set i 0} {$i < $time} {incr i} {
    vcd on
    vcd files [format "../../output/modelsim/sim_%03d.vcd" $i]
}
for {set i 0} {$i < $time} {incr i} {
    vcd on
    vcd add -file [format "../../output/modelsim/sim_%03d.vcd" $i] -r *
    run 1 ms
    vcd off [format "../../output/modelsim/sim_%03d.vcd" $i]
}

exit
