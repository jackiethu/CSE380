#!/bin/sh
module load boost hdf5
module load gcc
module load petsc/3.9-uni
#module load gnu7
export PKGPATH=/work/00161/karl/stampede2/public/
./configure FC=mpif90 FCFLAGS='-g -O0 -Wall' --with-masa=$PKGPATH/masa-gnu7-0.50 \
    --with-grvy=$PKGPATH/grvy-gnu7-0.34 --with-hdf5=$TACC_HDF5_DIR \
    --with-petsc=$PETSC_DIR
    #--enable-coverage
