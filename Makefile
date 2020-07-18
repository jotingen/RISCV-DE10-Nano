
.PHONY: all
all: 
	mkdir -p output/rvfi; \
	cd submodules/riscv-formal/monitor; \
	./generate.py -irv32im -c 6 -a -p riscv_rvfimon -r0 > ../../../output/rvfi/riscv_rvfimon.v; \
        sed -i 's/  wire misa_ok = 1;/  wire ialign16 = 1;\n  wire misa_ok = 1;/' ../../../output/rvfi/riscv_rvfimon.v
	cd programs; make
	cd simulation/modelsim; make

.PHONY: clean
clean: 
	cd programs; make clean
	cd simulation/modelsim; make clean

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
