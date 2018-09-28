#!/bin/bash
# Estimate the value of pi using Monte Carlo method

# Function to generate random numbers in [0, 1]
RandomDraw() {
    echo "scale=15; $RANDOM/32767" | bc -l
}
