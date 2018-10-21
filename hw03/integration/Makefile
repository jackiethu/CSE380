# Files
EXEC     := integrate
SRC_MOD  := $(wildcard *_Mod.f90)
OBJ_MOD  := $(patsubst %.f90, %.o, $(SRC_MOD))
SRC      := $(wildcard *.f90)
OBJ      := $(patsubst %.f90, %.o, $(SRC))

# Options
FC      := ifort
FCFLAGS := -g -check bounds

# Rules
$(EXEC): $(OBJ)
	$(FC) $(FCFLAGS) -o $@ $^
main.o: $(OBJ_MOD)
%.o: %.f90
	$(FC) $(FCFLAGS) -c $<

# Phony targets
.PHONY: clean
clean:
	rm -f $(EXEC) $(OBJ) *.mod
