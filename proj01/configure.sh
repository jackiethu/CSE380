#!/bin/sh
module load gnu7 boost
export PKGPATH=/work/00161/karl/stampede2/public/
./configure FC=gfortran FCFLAGS='-g -O0' --with-masa=$PKGPATH/masa-gnu7-0.50 \
    --with-grvy=$PKGPATH/grvy-gnu7-0.34 --enable-coverage
