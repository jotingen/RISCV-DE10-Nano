rwildcard=$(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))            
FILTER_OUT = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
FILTER_IN  = $(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))

SRCS_SUFFIX=.c
SRCS := $(call rwildcard, ., *.c)
ASSEMBLY_SUFFIX=.s
ASSEMBLY := $(patsubst %$(SRCS_SUFFIX),%$(ASSEMBLY_SUFFIX),$(SRCS))
OUT_SUFFIX=.out
OUT := $(patsubst %$(SRCS_SUFFIX),%$(OUT_SUFFIX),$(SRCS))
VERILOG0_SUFFIX=_0.v
VERILOG0 := $(patsubst %$(SRCS_SUFFIX),%$(VERILOG0_SUFFIX),$(SRCS))
VERILOG1_SUFFIX=_1.v
VERILOG1 := $(patsubst %$(SRCS_SUFFIX),%$(VERILOG1_SUFFIX),$(SRCS))
VERILOG2_SUFFIX=_2.v
VERILOG2 := $(patsubst %$(SRCS_SUFFIX),%$(VERILOG2_SUFFIX),$(SRCS))
VERILOG3_SUFFIX=_3.v
VERILOG3 := $(patsubst %$(SRCS_SUFFIX),%$(VERILOG3_SUFFIX),$(SRCS))

.PHONY: all
all : | clean $(ASSEMBLY)

%$(ASSEMBLY_SUFFIX) :
	riscv32-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i -S -o $(patsubst %.s,%.s,$@)           $(patsubst %.s,%.c,$@)
	riscv32-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i    -o $(patsubst %.s,%.out,$@) riscv.s $(patsubst %.s,%.c,$@)
	riscv32-unknown-elf-objcopy -O verilog --interleave=4 -b 0 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_0.v,$@)
	riscv32-unknown-elf-objcopy -O verilog --interleave=4 -b 1 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_1.v,$@)
	riscv32-unknown-elf-objcopy -O verilog --interleave=4 -b 2 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_2.v,$@)
	riscv32-unknown-elf-objcopy -O verilog --interleave=4 -b 3 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_3.v,$@)

.PHONY: clean
clean: 
	find . \( -name '*$(ASSEMBLY_SUFFIX)' -or -name '*$(OUT_SUFFIX)' -or -name '*$(VERILOG0_SUFFIX)' -or -name '*$(VERILOG1_SUFFIX)' -or -name '*$(VERILOG2_SUFFIX)' -or -name '*$(VERILOG3_SUFFIX)' \) -not -name 'riscv.s' | xargs -r -n 1 rm
