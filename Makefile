
.PHONY: all
all: 
	cd verif\tests && $(MAKE)
	cd simulation\modelsim && $(MAKE)

.PHONY: clean
clean: 
	cd verif\tests && $(MAKE) clean
	cd simulation\modelsim && $(MAKE) clean
