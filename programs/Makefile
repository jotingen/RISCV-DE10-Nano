include Makefile.include

all: | clean $(OUTDIR)/riscv.o
	$(MAKE) -C lib
	$(MAKE) -C apps
	$(MAKE) -C benchmarks
	$(MAKE) -C bootloader
	$(MAKE) -C os
	$(MAKE) -C regressions

$(OUTDIR)/riscv.o : riscv.s
	mkdir -p $(OUTDIR)
	$(GCC) -c riscv.s -o $(OUTDIR)/riscv.o
	
clean:
	rm -rf $(OUTDIR)