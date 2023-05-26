#!/bin/bash
input_dir="json"
outdir_dir="clips-sorted"

for json in $(find "$input_dir" -maxdepth 1 -type f -name "*.json"); do
    videoname=$(basename $json | sed 's/json/m4a/')
    echo "$videoname"
    for file in $(find -type f -name "$videoname"); do
        rm $file
    done
done