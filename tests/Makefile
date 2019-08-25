SRCS := $(wildcard *.c)
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
all : $(ASSEMBLY) $(OUT)  $(VERILOG0) $(VERILOG1) $(VERILOG2) $(VERILOG3) sim

%$(ASSEMBLY_SUFFIX) : $(SRCS)
	riscv64-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i -S -o $@ $<

%$(OUT_SUFFIX) : $(SRCS)
	riscv64-unknown-elf-gcc -ffreestanding -O0 '-Wl,--gc-sections' -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,riscv32.ld -mabi=ilp32 -march=rv32i -o $@ riscv.s $< 

%$(VERILOG0_SUFFIX) : %$(OUT_SUFFIX)
	riscv64-unknown-elf-objcopy -O verilog --interleave=4 -b 0 $< $@

%$(VERILOG1_SUFFIX) : %$(OUT_SUFFIX)
	riscv64-unknown-elf-objcopy -O verilog --interleave=4 -b 1 $< $@

%$(VERILOG2_SUFFIX) : %$(OUT_SUFFIX)
	riscv64-unknown-elf-objcopy -O verilog --interleave=4 -b 2 $< $@

%$(VERILOG3_SUFFIX) : %$(OUT_SUFFIX)
	riscv64-unknown-elf-objcopy -O verilog --interleave=4 -b 3 $< $@

.PHONY: sim
	$(MAKE) -f simulation/modelsim

.PHONY: clean
clean: 
	$(foreach var, $(ASSEMBLY) $(OUT) $(VERILOG0) $(VERILOG1) $(VERILOG2) $(VERILOG3), del /f /q $(var);)
	$(MAKE) -f simulation/modelsim clean
