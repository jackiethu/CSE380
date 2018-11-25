# Find all source files, create a list of corresponding object files
SRCS := $(wildcard *.f90)
OBJS := $(patsubst %.f90,%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS     := $(wildcard *_Mod.f90)
MOD_OBJS := $(patsubst %.f90,%.o,$(MODS))

# MASA and GRVY lib info
PKGPATH := /work/00161/karl/stampede2/public
GRVY_LIBS := $(PKGPATH)/grvy-intel-0.34/lib
MASA_LIBS := $(PKGPATH)/masa-intel-0.50/lib

# Complier/Linker settings
FC      := ifort
FLFLAGS := -g -L$(GRVY_LIBS) -L$(MASA_LIBS)
FCFLAGS := -g -O0 -check all -warn all -r8 -I$(GRVY_LIBS) -I$(MASA_LIBS)
LDLIBS  := -lgrvy -lgrvyf -lfmasa -lmasa
PROGRAM := main
PRG_OBJ := $(PROGRAM).o


# make without parameters will make first target found
all: $(PROGRAM)

# Compiler steps for all objects
$(OBJS): %.o: %.f90
	$(FC) -c $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM): $(OBJS)
	$(FC) $(FLFLAGS) $(LDLIBS) -o $@ $^ \
		-Wl,-rpath,$(GRVY_LIBS),-rpath,$(MASA_LIBS)

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
Initialize_Mod.o: Control_Parameters_Mod.o Solve_Common_Mod.o Get_Matrix_Mod.o \
	Get_Source_Mod.o Get_Mesh_Mod.o
Solve_Common_Mod.o: Sparse_Matrix_Mod.o
Get_Matrix_Mod.o: Solve_Common_Mod.o
Get_Mesh_Mod.o: Solve_Common_Mod.o Control_Parameters_Mod.o
Get_Source_Mod.o: Solve_Common_Mod.o Control_Parameters_Mod.o
