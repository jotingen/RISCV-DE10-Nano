SET PATH=%PATH%;"C:\intelFPGA_lite\18.1\quartus\bin64\"

quartus_map --read_settings_files=on --write_settings_files=off DE10Nano -c DE10Nano && ^
quartus_fit --read_settings_files=off --write_settings_files=off DE10Nano -c DE10Nano  && ^
quartus_asm --read_settings_files=off --write_settings_files=off DE10Nano -c DE10Nano  && ^
quartus_sta DE10Nano -c DE10Nano

