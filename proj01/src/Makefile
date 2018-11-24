# Find all source files, create a list of corresponding object files
SRCS := $(wildcard *.f90)
OBJS := $(patsubst %.f90,%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS     := $(wildcard *_Mod.f90)
MOD_OBJS := $(patsubst %.f90,%.o,$(MODS))

# Complier/Linker settings
PKGPATH := /work/00161/karl/stampede2/public
FC      := ifort
FLFLAGS := -g -L$(PKGPATH)/grvy-intel-0.34/lib
FCFLAGS := -g -O0 -check all -warn all -fpe0 -r8 -I$(PKGPATH)/grvy-intel-0.34/lib
LDLIBS  := -lgrvy -lgrvyf
PROGRAM := main
PRG_OBJ := $(PROGRAM).o

# Note for commenting out .SUFFIXES: no need for this old-fashioned rule (suffix rule)
## Clean the suffixes
#.SUFFIXES:
#
## Set the suffixes we are interested in
#.SUFFIXES: .f90 .o

# make without parameters will make first target found
all: $(PROGRAM)

# Compiler steps for all objects
$(OBJS): %.o: %.f90
	$(FC) -c $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM): $(OBJS)
	$(FC) $(FLFLAGS) $(LDLIBS) -o $@ $^ \
		-Wl,-rpath,$(PKGPATH)/grvy-intel-0.34/lib

debug:
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "MODS = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"
	@echo "PROGRAM = $(PROGRAM)"
	@echo "PRG_OBJ = $(PRG_OBJ)"

clean:
	rm -f $(OBJS) $(PROGRAM) *.mod 

# PHONY targets
.PHONY: all debug clean

# Dependencies
$(PRG_OBJ): $(MOD_OBJS)
Read_Input_Mod.o: Control_Parameters_Mod.o
Initialize_Mod.o: Control_Parameters_Mod.o Solve_Common_Mod.o Get_Matrix_Mod.o
Solve_Common_Mod.o: Sparse_Matrix_Mod.o
Get_Matrix_Mod.o: Sparse_Matrix_Mod.o
