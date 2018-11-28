#PKGPATH = /work/00161/karl/stampede2/public
MASA_LIBS = ${PKGPATH}/masa-intel-0.50/lib
GRVY_LIBS = ${PKGPATH}/grvy-intel-0.34/lib

# Compiler and linker flags
AM_FCFLAGS = -r8 -I$(MASA_LIBS) -I$(GRVY_LIBS)
AM_LDFLAGS = -L$(MASA_LIBS) -L$(GRVY_LIBS) -lgrvy -lgrvyf -lfmasa -lmasa \
		-Wl,-rpath,$(GRVY_LIBS),-rpath,$(MASA_LIBS)

# Name for binary and source files
bin_PROGRAMS = heateq
heateq_SOURCES = Control_Parameters_Mod.f90 Get_Source_Mod.f90 main.f90 Solve_Common_Mod.f90 \
	Get_Matrix_Mod.f90 Initialize_Mod.f90 Postprocess_Mod.f90 Solve_System_Mod.f90 \
	Get_Mesh_Mod.f90 Jacobi_GS_Mod.f90 Read_Input_Mod.f90 Sparse_Matrix_Mod.f90

# We need to write clean ourselves because the default one doesn't rm *.mod
clean:
	rm -f heateq *.o *.mod

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
