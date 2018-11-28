#!/bin/sh
module load intel boost
export PKGPATH=/work/00161/karl/stampede2/public/
./configure FC=ifort --with-masa=$PKGPATH/masa-intel-0.50 \
    --with-grvy=$PKGPATH/grvy-intel-0.34
