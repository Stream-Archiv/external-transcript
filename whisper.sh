#!/bin/bash

input_file="data.csv"
output_folder="."

cd clips/

while IFS=',' read -r id url sprache; do
    file_name="${id}.m4a.txt"
    if [ ! -f "$output_folder/$file_name" ]; then
        # Prüfen ob eine Audio Datei vorhanden ist
        files=$(find "$output_folder" -type f -name "*${id}*.m4a" | head -n 1)
        if [ -n "$files" ]; then
            audio_file=$(basename "$files")
            echo "Audiodatei für $id gefunden: $audio_file"
            # Nenne Datei um 
            mv "$audio_file" "$id.m4a"
            audio_file="$id.m4a"
            # Starte whisper
            whisper --model "large" --device "cuda" --language "$sprache" "$audio_file" > /dev/null
        fi
    fi
done <"$input_file"
