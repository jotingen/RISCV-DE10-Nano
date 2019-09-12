
.PHONY: all
all: 
	cd tests; make
	cd simulation/modelsim; make

.PHONY: clean
clean: 
	cd tests; make clean
	cd simulation/modelsim; make clean

#.PHONY: all
#all: 
#	powershell "echo $$null >> tests\Makefile"
#	powershell "cd tests\; make"
#	powershell "echo $$null >> simulation\modelsim\Makefile"
#	powershell "cd simulation\modelsim\; make"
#
#.PHONY: clean
#clean: 
#	powershell "echo $$null >> tests\Makefile"
#	powershell "cd tests\; make clean"
#	powershell "echo $$null >> simulation\modelsim\Makefile"
#	powershell "cd simulation\modelsim\; make clean"
