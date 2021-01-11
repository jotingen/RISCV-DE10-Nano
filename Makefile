
.PHONY: all
all:    build
	make -C programs
	make -C regressions

.PHONY: clean
clean: 
	make -C programs clean
	make -C regressions clean

.PHONY: build
build: rvfimon riscv

.PHONY: riscv
riscv:
	scalafmt -c src/spinalhdl/riscv/scalafmt.conf src/spinalhdl/riscv/src/main/scala/wishbone
	scalafmt -c src/spinalhdl/riscv/scalafmt.conf src/spinalhdl/riscv/src/main/scala/riscv
	scalafmt -c src/spinalhdl/riscv/scalafmt.conf src/spinalhdl/riscv/src/main/scala/led
	scalafmt -c src/spinalhdl/riscv/scalafmt.conf src/spinalhdl/riscv/src/main/scala/keys
	scalafmt -c src/spinalhdl/riscv/scalafmt.conf src/spinalhdl/riscv/src/main/scala/uart
	cd src/spinalhdl/riscv; \
	sbt "; set mainClass in (Compile, run) := Some(\"riscv.riscv_top\"); run\
             ; set mainClass in (Compile, run) := Some(\"led.led_top\"); run\
             ; set mainClass in (Compile, run) := Some(\"keys.keys_top\"); run\
             ; set mainClass in (Compile, run) := Some(\"uart.uart_top\"); run"

.PHONY: rvfimon
rvfimon: 
	mkdir -p output/rvfi; \
	cd submodules/riscv-formal/monitor; \
	./generate.py -irv32imc -c 6 -a -p riscv_rvfimon  > ../../../output/rvfi/riscv_rvfimon.v

#.PHONY: all
#all: 
#	powershell "echo $$null >> programs\Makefile"
#	powershell "cd programs\; make"
#	powershell "echo $$null >> simulation\modelsim\Makefile"
#	powershell "cd simulation\modelsim\; make"
#
#.PHONY: clean
#clean: 
#	powershell "echo $$null >> programs\Makefile"
#	powershell "cd programs\; make clean"
#	powershell "echo $$null >> simulation\modelsim\Makefile"
#	powershell "cd simulation\modelsim\; make clean"
