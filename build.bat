SET PATH=%PATH%;"C:\intelFPGA_lite\18.1\quartus\bin64\"

quartus_map --read_settings_files=on --write_settings_files=off RISCV -c RISCV && ^
quartus_fit --read_settings_files=off --write_settings_files=off RISCV -c RISCV  && ^
quartus_asm --read_settings_files=off --write_settings_files=off RISCV -c RISCV  && ^
quartus_sta RISCV -c RISCV

