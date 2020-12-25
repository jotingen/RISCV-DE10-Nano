SVUNIT_INSTALL := ../svunit
MODELSIM_INSTALL := ${HOME}/intelFPGA/19.1/modelsim_ase
PATH := ${SVUNIT_INSTALL}/bin:${MODELSIM_INSTALL}/bin:${PATH}

unit_tests := $(sort $(wildcard soc_*_unit_test.sv)) 

all: $(unit_tests)

.PHONY: $(unit_tests)
$(unit_tests): 
	SVUNIT_INSTALL=${SVUNIT_INSTALL} \
	PATH="${PATH}"                   \
	runSVUnit -s modelsim -d SIM -d RISCV_FORMAL -r "-L altera_mf_ver -L 220model_ver" -r "-wlf $(patsubst %.sv,%.wlf,$@)" -t $@; \
	if grep 'testrunner.*FAILED' run.log; then exit 1; fi
