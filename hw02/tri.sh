#!/bin/bash
# Generate triangle patterns

echo "Usage: ./tri.sh"

for i in {1..5}; do
    j=$(( 5 - i ))
    while [ $j -ge 1 ]; do
        echo -n " "
        j=$(( j - 1 ))
    done
    printf "%b" "$i"
    j=$(( i - 1 ))
    while [ $j -ge 1 ]; do
        echo -n " $i"
        j=$(( j - 1 ))
    done
    printf "\n"
done

for i in {1..5}; do
    j=$(( 5 - i ))
    while [ $j -ge 1 ]; do
        echo -n " "
        j=$(( j - 1 ))
    done
    printf "%b" "."
    j=$(( i - 1 ))
    while [ $j -ge 1 ]; do
        echo -n " ."
        j=$(( j - 1 ))
    done
    printf "\n"
done
