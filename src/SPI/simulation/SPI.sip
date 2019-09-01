set_global_assignment -entity "SPI" -library "lib_SPI" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "SPI" -library "lib_SPI" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "SPI" -library "lib_SPI" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_SPI" -name SPD_FILE [file join $::quartus(sip_path) "../SPI.spd"]
set_global_assignment -library "lib_SPI" -name MISC_FILE [file join $::quartus(sip_path) "../../SPI.qsys"]

set_global_assignment -library "lib_SPI" -name MISC_FILE [file join $::quartus(sip_path) "SPI.v"]
set_global_assignment -library "lib_SPI" -name MISC_FILE [file join $::quartus(sip_path) "submodules/spiphyslave.v"]
