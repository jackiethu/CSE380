#!/bin/bash
# Estimate the value of pi using Monte Carlo method

# Function to generate random numbers in [0, 1]
RandomDraw() {
    echo "scale=15; $RANDOM/32767" | bc -l
}

echo "Usage: ./pi.sh N_samples"
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
pi_estimate=$( echo "4 * $N_i / $N" | bc -l )
pi=$( echo "4*a(1)" | bc -l )
if [ $( echo "($pi_estimate - $pi) >= 0" | bc -l ) = 1 ]; then
    e_rel=$( echo "($pi_estimate - $pi)/$pi" | bc -l )
else
    e_rel=$( echo "($pi - $pi_estimate)/$pi" | bc -l )
fi
echo $N $N_i $((N - N_i)) $pi_estimate $e_rel
