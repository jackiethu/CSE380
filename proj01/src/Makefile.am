# Set up library path
PKGPATH = /work/00161/karl/stampede2/public
MASA_LIBS = $(PKGPATH)/masa-gnu7-0.50/lib
GRVY_LIBS = $(PKGPATH)/grvy-gnu7-0.34/lib

# Compiler and linker flags
AM_FCFLAGS = -fdefault-real-8 -I$(MASA_LIBS) -I$(GRVY_LIBS) $(HDF5_CFLAGS)
AM_LDFLAGS = -L$(MASA_LIBS) -L$(GRVY_LIBS) -lgrvy -lgrvyf -lfmasa -lmasa \
		-Wl,-rpath,$(GRVY_LIBS),-rpath,$(MASA_LIBS) \
		$(HDF5_FLIBS)

# PETSc flags
if PETSC_ENABLED
  include $(PETSC_DIR)/lib/petsc/conf/variables
  AM_FCFLAGS += -DINCLUDE_PETSC $(PETSC_FCPPFLAGS)
  AM_LDFLAGS += -L$(PETSC_LIB_DIR) $(PETSC_LIB_BASIC)
endif

# Name for binary and source files
bin_PROGRAMS = heateq
heateq_SOURCES = Control_Parameters_Mod.F90 Get_Source_Mod.F90 main.F90 Solve_Common_Mod.F90 \
	Get_Matrix_Mod.F90 Initialize_Mod.F90 Postprocess_Mod.F90 Solve_System_Mod.F90 \
	Get_Mesh_Mod.F90 Jacobi_GS_Mod.F90 Read_Input_Mod.F90 Sparse_Matrix_Mod.F90

# We need to write clean ourselves because the default one doesn't rm *.mod
clean:
	rm -f heateq *.o *.mod *.gcno *.gcda

# Fortran module dependencies
main.o: Read_Input_Mod.o Initialize_Mod.o Solve_System_Mod.o Postprocess_Mod.o
Read_Input_Mod.o: Control_Parameters_Mod.o
Initialize_Mod.o: Control_Parameters_Mod.o Solve_Common_Mod.o Get_Matrix_Mod.o \
			Get_Source_Mod.o Get_Mesh_Mod.o
Solve_Common_Mod.o: Sparse_Matrix_Mod.o
Get_Matrix_Mod.o: Solve_Common_Mod.o
Get_Mesh_Mod.o: Solve_Common_Mod.o Control_Parameters_Mod.o
Get_Source_Mod.o: Solve_Common_Mod.o Control_Parameters_Mod.o
Solve_System_Mod.o: Solve_Common_Mod.o Jacobi_GS_Mod.o Control_Parameters_Mod.o
Postprocess_Mod.o: Solve_Common_Mod.o Control_Parameters_Mod.o
