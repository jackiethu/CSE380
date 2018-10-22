#!/bin/bash
# bash script to conduct convergence analysis on numerical integration

for N in 10 20 40 80 160 320; do
    ./integrate $N trapezoid
done > result_trapezoid.txt


for N in 10 20 40 80 160 320; do
    ./integrate $N Simpson
done > result_Simpson.txt

tar -cf result.tar result_*
