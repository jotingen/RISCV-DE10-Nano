rwildcard=$(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))            

SRCS := $(call rwildcard, ., *.c)
SRCS_SUFFIX=.c

TESTS := $(patsubst %.c,%,$(SRCS))
ASSEMBLY_SUFFIX=.s
ASSEMBLY := $(patsubst %,%$(ASSEMBLY_SUFFIX),$(TESTS))
OUT_SUFFIX=.out
OUT := $(patsubst %,%$(OUT_SUFFIX),$(TESTS))
VERILOG0_SUFFIX=_0.v
VERILOG0 := $(patsubst %,%$(VERILOG0_SUFFIX),$(TESTS))
VERILOG1_SUFFIX=_1.v
VERILOG1 := $(patsubst %,%$(VERILOG1_SUFFIX),$(TESTS))
VERILOG2_SUFFIX=_2.v
VERILOG2 := $(patsubst %,%$(VERILOG2_SUFFIX),$(TESTS))
VERILOG3_SUFFIX=_3.v
VERILOG3 := $(patsubst %,%$(VERILOG3_SUFFIX),$(TESTS))

.PHONY: all
all : 
	$(MAKE) $(ASSEMBLY)

%$(ASSEMBLY_SUFFIX) : $(SRCS)
	riscv64-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i -S -o $(patsubst %.s,%.s,$@)           $(patsubst %.s,%.c,$@)
	riscv64-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i    -o $(patsubst %.s,%.out,$@) riscv.s $(patsubst %.s,%.c,$@) 
	riscv64-unknown-elf-objcopy -O verilog --gap-fill 0 --pad-to 65535 --interleave=4 -b 0 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_0.v,$@)
	riscv64-unknown-elf-objcopy -O verilog --gap-fill 0 --pad-to 65535 --interleave=4 -b 1 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_1.v,$@)
	riscv64-unknown-elf-objcopy -O verilog --gap-fill 0 --pad-to 65535 --interleave=4 -b 2 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_2.v,$@)
	riscv64-unknown-elf-objcopy -O verilog --gap-fill 0 --pad-to 65535 --interleave=4 -b 3 $(patsubst %.s,%.out,$@) $(patsubst %.s,%_3.v,$@)

.PHONY: clean
clean: 
	$(foreach var, $(ASSEMBLY) $(OUT) $(VERILOG0) $(VERILOG1) $(VERILOG2) $(VERILOG3), powershell " Remove-Item -ErrorAction Ignore $(var)";)
