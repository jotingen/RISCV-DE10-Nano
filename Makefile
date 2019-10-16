
.PHONY: all
all: 
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
