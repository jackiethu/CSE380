#!/bin/bash
# Calcultate the factorial of a supplied number

n=$1
fac=1

while [ $n -ge 2 ]; do
    fac=$( expr $fac \* $n )
    n=$( expr $n - 1 )
done

echo $fac
