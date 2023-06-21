#!/bin/bash

# arguments are:
# 1	- working directory
# 2	- a file including the accession numbers of the samples

function USAGE() {
    echo "USAGE: ./run.sh <work_path> <file_path:accession number included>"
    exit 1
}

# Check the parameters
if [[ "$#" -ne 2 ]]; then
    echo "Wrong parameters specified. Expected working directory and the file path"
    USAGE
fi
if ! [[ -d "$1" ]]; then
    echo "Path not existed"
    USAGE
fi
if ! [[ -f "$1/$2" ]]; then
    echo "File not existed"
    USAGE
fi
wkd="$1"
file="$2"

# Chip_seq analysis
./workflow.sh "$wkd" "$file"
