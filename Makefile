
.PHONY: all
all: 
	cd tests && $(MAKE)
	cd simulation\modelsim && $(MAKE)

.PHONY: clean
clean: 
	cd tests && $(MAKE) clean
	cd simulation\modelsim && $(MAKE) clean
