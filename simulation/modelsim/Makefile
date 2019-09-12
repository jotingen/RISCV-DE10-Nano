rwildcard=$(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))            
FILTER_OUT = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
FILTER_IN  = $(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))

V_FILES  := $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../src/ ../../verif/, *.v)))
SV_PKG   := $(call FILTER_IN,_pkg, $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../src/ ../../verif/, *.sv))))
SV_FILES := $(call FILTER_OUT,_pkg, $(call FILTER_OUT,_inst, $(call FILTER_OUT,_bb, $(call rwildcard, ../../src/ ../../verif/, *.sv))))
V_SUFFIX=.v
SV_SUFFIX=.sv

define newline

endef

.PHONY: all
all: clean build sim

.PHONY: build
build: 
	vlib.exe rtl_work
	vmap.exe work rtl_work
	$(MAKE) $(V_FILES) $(SV_PKG) $(SV_FILES)

%$(V_SUFFIX): FORCE
	@vlog.exe -vlog01compat -work work +incdir+$(dir $@) $@ 

%$(SV_SUFFIX): FORCE
	vlog.exe -sv -work work +incdir+$(dir $@) $@
	
.PHONY: sim
sim:
	vsim.exe -c -do RISCV.do

.PHONY: clean
clean:
	if [ -f rtl_work ]; then vdel.exe -lib rtl_work -all; fi

FORCE:
