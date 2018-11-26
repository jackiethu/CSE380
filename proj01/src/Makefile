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
FCFLAGS := -g -O0 -check all -warn all -r8 -I$(GRVY_LIBS) -I$(MASA_LIBS) -module ../obj
LDLIBS  := -lgrvy -lgrvyf -lfmasa -lmasa
PROGRAM := main
PRG_OBJ := $(PROGRAM).o

# create ../obj/ directory
SH_RESULT := $(shell mkdir -p ../obj)


# make without parameters will make first target found
all: $(PROGRAM)

# Compiler steps for all objects
../obj/%.o: %.f90
	$(FC) -c $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM): $(addprefix ../obj/, $(OBJS))
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
	rm -f $(addprefix ../obj/, $(OBJS)) $(PROGRAM) ../obj/*.mod 

# PHONY targets
.PHONY: all debug clean

# Dependencies
../obj/$(PRG_OBJ): $(addprefix ../obj/, $(MOD_OBJS))
../obj/Read_Input_Mod.o: ../obj/Control_Parameters_Mod.o
../obj/Initialize_Mod.o: $(addprefix ../obj/, Control_Parameters_Mod.o \
   	Solve_Common_Mod.o Get_Matrix_Mod.o Get_Source_Mod.o Get_Mesh_Mod.o)
../obj/Solve_Common_Mod.o: ../obj/Sparse_Matrix_Mod.o
../obj/Get_Matrix_Mod.o: ../obj/Solve_Common_Mod.o
../obj/Get_Mesh_Mod.o: $(addprefix ../obj/, Solve_Common_Mod.o Control_Parameters_Mod.o)
../obj/Get_Source_Mod.o: $(addprefix ../obj/, Solve_Common_Mod.o Control_Parameters_Mod.o)
../obj/Solve_System_Mod.o: $(addprefix ../obj/, Solve_Common_Mod.o Jacobi_GS_Mod.o \
	Control_Parameters_Mod.o)
../obj/Postprocess_Mod.o: $(addprefix ../obj/, Solve_Common_Mod.o Control_Parameters_Mod.o)
