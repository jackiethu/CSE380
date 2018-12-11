#!/bin/sh
module load boost hdf5
module load gnu7
export PKGPATH=/work/00161/karl/stampede2/public/
./configure FC=gfortran FCFLAGS='-g -O0' --with-masa=$PKGPATH/masa-gnu7-0.50 \
    --with-grvy=$PKGPATH/grvy-gnu7-0.34 --enable-coverage \
    --with-hdf5=$TACC_HDF5_DIR
