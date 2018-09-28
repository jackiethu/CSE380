#!/bin/bash
# Calcultate the factorial of a supplied number

echo "Usage: factorial.sh NUM"
if [ -z "$1" ]; then
    echo "No argument supplied" 1>&2
    exit 1
else
    n=$1
    fac=1
    
    while [ $n -ge 2 ]; do
        fac=$( expr $fac \* $n )
        n=$( expr $n - 1 )
    done
    
    echo "$1! = $fac"
fi
