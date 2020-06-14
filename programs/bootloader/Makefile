include ../Makefile.include

OUTDIR   := $(OUTDIR)/bootloader

SRC          = $(call rwildcard, ., *$(C_SUFFIX))
OBJ          = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(OBJ_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
OUT          = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(OUT_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
ASSEMBLY     = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(ASSEMBLY_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
OUT_ASSEMBLY = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(OUT_ASSEMBLY_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
BIN          = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(BIN_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
VERILOG      = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(VERILOG_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
LIB          = $(OUTDIR)/lib$(LIB_SUFFIX)

.PHONY: all
all : | init  $(OBJ) $(ASSEMBLY) $(OUT) $(OUT_ASSEMBLY) $(BIN)

init:
	mkdir -p $(OUTDIR)

include ../Makefile.recipes