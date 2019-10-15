set_global_assignment -entity "terasic_hps_ddr3" -library "lib_terasic_hps_ddr3" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "terasic_hps_ddr3" -library "lib_terasic_hps_ddr3" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "terasic_hps_ddr3" -library "lib_terasic_hps_ddr3" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_terasic_hps_ddr3" -name SPD_FILE [file join $::quartus(sip_path) "../terasic_hps_ddr3.spd"]
set_global_assignment -library "lib_terasic_hps_ddr3" -name MISC_FILE [file join $::quartus(sip_path) "../terasic_hps_ddr3.qsys"]

set_global_assignment -library "lib_terasic_hps_ddr3" -name MISC_FILE [file join $::quartus(sip_path) "terasic_hps_ddr3.v"]
set_global_assignment -library "lib_terasic_hps_ddr3" -name MISC_FILE [file join $::quartus(sip_path) "submodules/terasic_hps_ddr3_hps.v"]
set_global_assignment -library "lib_terasic_hps_ddr3" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_address_span_extender.sv"]
