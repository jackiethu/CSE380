#!/bin/bash
# Estimate the value of pi using Monte Carlo method

# Function to generate random numbers in [0, 1]
RandomDraw() {
    echo "scale=15; $RANDOM/32767" | bc -l
}

# Monte Carlo sampling
if [ -z "$1" ]; then
    echo "No arguments supplied" 1>&2
    exit 1
fi
N=$1
N_i=0
for i in $(seq $N); do
    x=$(RandomDraw)
    y=$(RandomDraw)
    r=$( echo "$x*$x + $y*$y <= 1" | bc -l )
    if [ $r -eq 1 ]; then 
        N_i=$(( N_i + 1 ))
    fi
done
echo $N $N_i $(echo "$N_i / $N" | bc -l)
