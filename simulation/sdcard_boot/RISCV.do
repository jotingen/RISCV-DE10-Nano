foreach arg [split $argv { } ] { if {[string first GOUT $arg] > 0} { set OUT [string replace $arg 0 5] } }

vsim -t 1ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L $OUT -L work -voptargs="+acc"  tb


set time 4

for {set i 0} {$i < $time} {incr i} {
    vcd on
    vcd files [format "$OUT/sim_%03d.vcd" $i]
}
for {set i 0} {$i < $time} {incr i} {
    puts "###$i###"
    vcd on
    vcd add -file [format "$OUT/sim_%03d.vcd" $i] -r *
    run 5 ms
    vcd off [format "$OUT/sim_%03d.vcd" $i]
}

exit
