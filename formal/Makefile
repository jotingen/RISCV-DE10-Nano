
.PHONY: all
all: | complete checks

.PHONY: complete
complete:
	sby -f complete.sby

.PHONY: checks
checks:
	python3 genchecks.py 
	make -C checks -j$(nproc)
	make -C checks -j$(nproc)
	find . -name '*.vcd'
