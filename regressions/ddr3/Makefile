ROOT_DIR         := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SVUNIT_INSTALL   := ${ROOT_DIR}/../svunit
MODELSIM_INSTALL := ${HOME}/intelFPGA/20.1/modelsim_ase
PATH             := ${SVUNIT_INSTALL}/bin:${MODELSIM_INSTALL}/bin:${PATH}

unit_tests := $(sort $(wildcard *_unit_test.sv)) 

all:
	@($(foreach unit_test,$(unit_tests),echo make --no-print-directory $(unit_test);)) | parallel --progress --will-cite

#Use chronic to hide output unless we have a fail
.PHONY: $(unit_tests)
$(unit_tests): 
	mkdir -p ../../output/regressions/ddr3/$(patsubst %.sv,%,$@) && \
	SVUNIT_INSTALL=${SVUNIT_INSTALL} \
	PATH="${PATH}"                   \
	runSVUnit -s modelsim \
	          -d SIM \
						-d RISCV_FORMAL \
						-c "-L altera_mf_ver -L 220model_ver" \
						-r "-L altera_mf_ver -L 220model_ver" \
						-r "-wlf $(patsubst %.sv,%.wlf,$@)" \
						-o ../../output/regressions/ddr3/$(patsubst %.sv,%,$@) \
						-t $@; \
	if grep -e 'testrunner.*FAILED' -e 'Error loading design' ../../output/regressions/ddr3/$(patsubst %.sv,%,$@)/run.log; then exit 1; fi
