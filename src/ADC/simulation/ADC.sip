set_global_assignment -entity "ADC" -library "lib_ADC" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ADC" -library "lib_ADC" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "ADC" -library "lib_ADC" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ADC" -name SPD_FILE [file join $::quartus(sip_path) "../ADC.spd"]
set_global_assignment -library "lib_ADC" -name MISC_FILE [file join $::quartus(sip_path) "../../ADC.qsys"]

set_global_assignment -library "lib_ADC" -name MISC_FILE [file join $::quartus(sip_path) "ADC.v"]
set_global_assignment -library "lib_ADC" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_avalon_adv_adc.v"]
set_global_assignment -library "lib_ADC" -name MISC_FILE [file join $::quartus(sip_path) "submodules/ADC_adc_mega_0.v"]
