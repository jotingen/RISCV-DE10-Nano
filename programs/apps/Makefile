RV_PREFIX = riscv32-unknown-elf-#Prefix for our RISC-V tools (e.g. gcc and objdump)
CC = $(RV_PREFIX)gcc #Our compiler
CCFLAGS =  -ffreestanding  -nostartfiles -nostdlib -Triscv32.ld  -mcmodel=medany -mabi=ilp32 -march=rv32im #Flags telling GCC to compile without libraries (e.g. baremetal), to use a differen memory model so that we can put our code at 0x80000000 and to use the specified linker script.
#CCFLAGS =  -ffreestanding -O1 -nostartfiles -nostdlib -Triscv32.ld  -mcmodel=medany -mabi=ilp32 -march=rv32im #Flags telling GCC to compile without libraries (e.g. baremetal), to use a differen memory model so that we can put our code at 0x80000000 and to use the specified linker script.
#CCFLAGS =  -ffreestanding -O3 -nostartfiles -nostdlib -nodefaultlibs -Triscv32.ld -mcmodel=medany -mabi=ilp32 -march=rv32i #Flags telling GCC to compile without libraries (e.g. baremetal), to use a differen memory model so that we can put our code at 0x80000000 and to use the specified linker script.

rwildcard=$(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))            
FILTER_OUT = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
FILTER_IN  = $(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))

C_SUFFIX=.c
ASSEMBLY_SUFFIX=.s
OBJ_SUFFIX=.o
OUT_SUFFIX=.out
VERILOG0_SUFFIX=_0.v
VERILOG1_SUFFIX=_1.v
VERILOG2_SUFFIX=_2.v
VERILOG3_SUFFIX=_3.v

LIBS     := $(call rwildcard, ../lib, *$(C_SUFFIX))
LIB_OBJ  := $(patsubst %$(C_SUFFIX),%$(OBJ_SUFFIX),$(LIBS))

SRCS     := $(filter-out $(LIBS), $(call rwildcard, ., *$(C_SUFFIX)))
ASSEMBLY := $(patsubst %$(C_SUFFIX),%$(ASSEMBLY_SUFFIX),$(SRCS))
OUT      := $(patsubst %$(C_SUFFIX),%$(OUT_SUFFIX),$(SRCS))
VERILOG0 := $(patsubst %$(C_SUFFIX),%$(VERILOG0_SUFFIX),$(SRCS))
VERILOG1 := $(patsubst %$(C_SUFFIX),%$(VERILOG1_SUFFIX),$(SRCS))
VERILOG2 := $(patsubst %$(C_SUFFIX),%$(VERILOG2_SUFFIX),$(SRCS))
VERILOG3 := $(patsubst %$(C_SUFFIX),%$(VERILOG3_SUFFIX),$(SRCS))

.PHONY: all
all : | clean init $(LIBS) $(ASSEMBLY) 

init:
	echo $(SRCS)
	mkdir -p ../../output/programs/apps
	riscv32-unknown-elf-gcc -c riscv.s -o ../../output/programs/apps/riscv.o
	mkdir -p ../../output/programs/lib
	$(foreach lib,$(LIBS), $(CC) $(CCFLAGS) -S -o ../../output/programs/lib/$(patsubst %.c,%.s,$(lib)) -c $(lib);)
	$(foreach lib,$(LIBS), $(CC) $(CCFLAGS)    -o ../../output/programs/lib/$(patsubst %.c,%.o,$(lib)) -c $(lib);)

%$(ASSEMBLY_SUFFIX) :
	mkdir -p ../../output/programs/apps/$(dir $@)
	$(CC) $(CCFLAGS) -S -o ../../output/programs/apps/$(patsubst %.s,%.s,$@)    $(patsubst %.s,%.c,$@) 
	$(CC) $(CCFLAGS)    -o ../../output/programs/apps/$(patsubst %.s,%.out,$@)  $(patsubst %.s,%.c,$@) $(addprefix ../../output/programs/lib/,$(LIB_OBJ)) ../../output/programs/apps/riscv.o
	$(RV_PREFIX)objcopy -O verilog --interleave=4 -b 0 ../../output/programs/apps/$(patsubst %.s,%.out,$@) ../../output/programs/apps/$(patsubst %.s,%_0.v,$@)
	$(RV_PREFIX)objcopy -O binary                      ../../output/programs/apps/$(patsubst %.s,%.out,$@) ../../output/programs/apps/$(patsubst %.s,%.bin,$@)

.PHONY: clean
clean: 
	find ../../output/programs/apps \( -name '*$(ASSEMBLY_SUFFIX)' -or -name '*$(OBJ_SUFFIX)' -or -name '*$(OUT_SUFFIX)' -or -name '*$(VERILOG0_SUFFIX)' -or -name '*$(VERILOG1_SUFFIX)' -or -name '*$(VERILOG2_SUFFIX)' -or -name '*$(VERILOG3_SUFFIX)' \) -not -name 'riscv.s' | xargs -r -n 1 rm
