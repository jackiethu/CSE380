#!/bin/bash
# Add two integers supplied as command line arguments

echo 'Usage: add.sh NUM1 NUM2'
if [ $# -lt 2 ]; then
    echo "The number of arguments is insufficient" 1>&2
    exit 1
else
    echo "$1 + $2 = $(($1 + $2))"
fi
