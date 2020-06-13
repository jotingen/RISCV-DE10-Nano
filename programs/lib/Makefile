include ../Makefile.include

OUTDIR   := $(OUTDIR)/lib

SRC      = $(call rwildcard, ., *$(C_SUFFIX))
OBJ      = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(OBJ_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
ASSEMBLY = $(patsubst ./%,$(OUTDIR)/%,$(patsubst %$(C_SUFFIX),%$(ASSEMBLY_SUFFIX),$(call rwildcard, ., *$(C_SUFFIX))))
LIB      = $(OUTDIR)/lib$(LIB_SUFFIX)

.PHONY: all
all: | init $(OBJ) $(ASSEMBLY) $(LIB)

%$(LIB_SUFFIX) : $(SRC)
	$(AR) -cvq $(LIB) $(OBJ)

init:
	mkdir -p $(OUTDIR)

include ../Makefile.recipes