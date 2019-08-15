SET PATH=%PATH%;"C:\intelFPGA_lite\18.1\quartus\bin64\"

quartus_map --read_settings_files=on --write_settings_files=off LC3 -c LC3 && ^
quartus_fit --read_settings_files=off --write_settings_files=off LC3 -c LC3 && ^
quartus_asm --read_settings_files=off --write_settings_files=off LC3 -c LC3 && ^
quartus_sta LC3 -c LC3 && ^
quartus_eda -t c:/intelfpga_lite/18.1/quartus/common/tcl/internal/nativelink/qnativesim.tcl LC3 LC3 --gen_script --called_from_qeda --qsf_sim_tool "ModelSim-Altera (SystemVerilog)" --rtl_sim --qsf_is_functional ON --qsf_netlist_output_directory simulation/modelsim --qsf_user_compiled_directory <None>

