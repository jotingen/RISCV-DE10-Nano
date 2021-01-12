SVUNIT_INSTALL := ../../svunit
MODELSIM_INSTALL := ${HOME}/intelFPGA/19.1/modelsim_ase
PATH := ${SVUNIT_INSTALL}/bin:${MODELSIM_INSTALL}/bin:${PATH}


all:
	SVUNIT_INSTALL=${SVUNIT_INSTALL} \
	PATH="${PATH}"                   \
	runSVUnit -s modelsim -d SIM -d RISCV_FORMAL -r "-wlf sim.wlf"
