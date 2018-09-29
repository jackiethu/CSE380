#!/bin/bash
# Generate triangle patterns

echo "Usage: ./tri.sh"

for i in {1..5}; do
    for j in $( seq 1 $((5-i)) ); do
        echo -n " "
    done
    printf "%b" "$i"
    for j in $( seq 1 $((i-1)) ); do
        echo -n " $i"
    done
    printf "\n"
done

for i in {1..5}; do
    for j in $( seq 1 $((5-i)) ); do
        echo -n " "
    done
    printf "%b" "."
    for j in $( seq 1 $((i-1)) ); do
        echo -n " ."
    done
    printf "\n"
done
