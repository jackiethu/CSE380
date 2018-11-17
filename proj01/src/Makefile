# Files
EXEC     := test
PROGRAM  := test_iteration.o # name for main program (.o file)
SRC_MOD  := $(wildcard *_Mod.f90)
OBJ_MOD  := $(addprefix ../obj/, $(patsubst %.f90, %.o, $(SRC_MOD)))
# $(info OBJ_MOD = $(OBJ_MOD))
SRC      := $(wildcard *.f90)
OBJ      := $(patsubst %.f90, %.o, $(SRC))
OBJECTS  := $(addprefix ../obj/, $(OBJ))
# $(info OBJECTS = $(OBJECTS))

# Options
FC      := ifort
FCFLAGS := -module ../obj -r8 -g -check all -warn all -fpe0
# Rules
$(EXEC): $(OBJECTS) 
	$(FC) $(FCFLAGS) -o $@ $^
../obj/$(PROGRAM): $(OBJ_MOD)
../obj/%.o: %.f90
	$(FC) $(FCFLAGS) -c $< -o $@

# Phony targets
.PHONY: clean
clean:
	rm -f $(EXEC) ../obj/*.mod $(OBJECTS)
