#!/bin/bash
input_dir="clips-sorted"
outdir_dir="json"
chunk_size=2
model="tiny"
device="cpu"
source="test"

mkdir -p "$outdir_dir"
mkdir -p "whisper-tmp"

for folder in $(find "$input_dir" -maxdepth 1 -type d); do
  if [[ "$folder" != "$input_dir" ]]; then
    sprache=$(basename "$folder")


    while [[ $(find "$folder" -maxdepth 1 -type f | wc -l) -gt 0 ]]; do
    # Verschieben der Dateien in den Zielordner
        files=$(find "$folder" -maxdepth 1 -type f -name "*.m4a" -printf "../%h/%f\n" | head -n "$chunk_size")
        #find "$source_folder" -maxdepth 1 -type f | head -n "$chunk_size" | xargs -I{} mv {} "$destination_folder"
        pushd "whisper-tmp"
        echo "$files" | xargs whisper --model "$model" --device "$device" --language "$sprache"
        mkdir -p "../$folder/finished/"
        echo "$files" | xargs -I{} mv {} "../$folder/finished"
        popd
        
        pushd "whisper-tmp"
        for file in $(find -maxdepth 1 -type f -name "*.txt"); do
        echo "$file"
            # Erzeuge json
            output_file="../$outdir_dir/$(echo "$file" | sed 's/m4a\.txt/json/')"
            "C:\Users\sebls\Downloads\jq.exe" -n --arg model "$model" --arg text "$(cat $file)" --arg source "$source" '{ model: $model, text: $text, source: $source }' > "$output_file"
            sed -i 's/\\r//g' "$output_file"
        done
        # Lösche nicht benötigte whisper output Dateien
        rm *.srt
        rm *.txt
        rm *.vtt
        rm *.json
        popd
    done


  fi
done