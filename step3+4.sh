#!/bin/bash
input_file="data.csv"
input_dir="clips"
output_dir="clips-sorted"

mkdir -p "$output_dir"
while IFS=',' read -r id url sprache; do
    files=$(find "$input_dir" -type f -name "*${id}.m4a" | head -n 1)

    if [ -n "$files" ]; then
        audio_file=$(basename "$files")
        echo "Audiodatei für $id gefunden: $audio_file"

        # Erstelle Sprachen ordner
        mkdir -p "$output_dir/$sprache"
        # Nenne Datei um 
        mv "$input_dir/$audio_file" "$output_dir/$sprache/$id.m4a"
    fi
done <"$input_file"
