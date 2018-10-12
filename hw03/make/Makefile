# Files
EXEC := tardis
SRC  := $(wildcard *.c)
OBJ  := $(patsubst %.c,%.o,$(SRC))

# Options
CC      := icc
LDPATH  := $$TACC_GSL_DIR
CFLAGS  := -I$(LDPATH)/include
LDFLAGS := -L$(LDPATH)/lib
LDLIBS  := -lgsl -lgslcblas

# Rules
$(EXEC): $(OBJ)
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $^
%.o: %.c
	$(CC) $(CFLAGS) -c $<
main.o mytools.o: mytools.h

# Phony targets
.PHONY: clean
clean:
	rm -f $(EXEC) $(OBJ)
