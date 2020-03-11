rwildcard=$(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))            
FILTER_OUT = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
FILTER_IN  = $(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))

OUT := ../../output/modelsim

V_FILES  := $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../monitor/ ../../src/ ../../verif/, *.v)))
SV_PKG   := $(call FILTER_IN,_pkg, $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../monitor/ ../../src/ ../../verif/, *.sv))))
SV_FILES := $(call FILTER_OUT,_pkg, $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../monitor/ ../../src/ ../../verif/, *.sv))))
V_SUFFIX=.v
SV_SUFFIX=.sv

define newline

endef

.PHONY: all
all: clean build sim

.PHONY: build
build: 
	mkdir -p $(OUT)
	vlib.exe $(OUT)
	vmap.exe work $(OUT)
	$(MAKE) $(V_FILES) $(SV_PKG) $(SV_FILES)

%$(V_SUFFIX): FORCE
	@vlog.exe -vlog01compat -work work +define+DEBUG +define+SIM +incdir+$(dir $@) $@ 

	#@vlog.exe -vlog01compat -work work +define+RISCV_FORMAL +define+DEBUG +define+SIM +incdir+$(dir $@) $@ 

%$(SV_SUFFIX): FORCE
	vlog.exe -sv -work work +define+DEBUG +define+SIM +incdir+$(dir $@) $@

	#vlog.exe -sv -work work +define+RISCV_FORMAL +define+DEBUG +define+SIM +incdir+$(dir $@) $@
	
.PHONY: sim
sim:
	vsim.exe -c -do RISCV.do

.PHONY: clean
clean:
	if [ -f $(OUT) ]; then vdel.exe -lib $(OUT) -all; fi

FORCE:
