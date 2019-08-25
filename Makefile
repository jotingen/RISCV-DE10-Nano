
.PHONY: all
all: 
	cd tests && type nul >> $(MAKE) && $(MAKE)
	cd simulation\modelsim && type nul >> $(MAKE) && $(MAKE)

.PHONY: clean
clean: 
	cd tests && type nul >> $(MAKE) && $(MAKE) clean
	cd simulation\modelsim && type nul >> $(MAKE) && $(MAKE) clean
