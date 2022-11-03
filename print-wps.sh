#!/bin/bash
# Prints WPS from MetaSeq training runs

set -o pipefail
set -o errexit
set -o nounset

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path-to-training.log>"
    exit 1
fi

# filter wps and print
wps=$(grep train_inner < $1 | grep INFO | grep epoch | cut -d '|' -f 4 | jq -r '.wps')
echo "Trained words per second from ${1}"
echo $wps

# print training time
training_time_text=$(tail $1 | grep "done training" | cut -d '|' -f 4)
echo $training_time_text
