
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
	cd src/spinalhdl/riscv; \
	sbt run

.PHONY: rvfimon
rvfimon: 
	mkdir -p output/rvfi; \
	cd submodules/riscv-formal/monitor; \
	./generate.py -irv32im -c 6 -a -p riscv_rvfimon -r0 > ../../../output/rvfi/riscv_rvfimon.v

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
