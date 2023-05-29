#!/bin/bash
input_dir="clips-sorted"
outdir_dir="json"
chunk_size=25
model="large"
device="cuda"
source="test"

mkdir -p "$outdir_dir"
mkdir -p "whisper-tmp"
file_counter=0
for folder in $(find "$input_dir" -maxdepth 1 -type d); do
  if [[ "$folder" != "$input_dir" ]]; then
    sprache=$(basename "$folder")


    while [[ $(find "$folder" -maxdepth 1 -type f | wc -l) -gt 0 ]]; do
        files=$(find "$folder" -maxdepth 1 -type f -name "*.m4a" -printf "../%h/%f\n" | head -n "$chunk_size")
        pushd "whisper-tmp"
        echo "Start transcribing."
        echo "$files" | xargs whisper --model "$model" --device "$device" --language "$sprache" > /dev/null
        mkdir -p "../$folder/finished/"
        echo "$files" | xargs -I{} mv {} "../$folder/finished"
        popd

        file_counter=$((file_counter + $chunk_size))
        echo "Transcribed $chunk_size audios. Total $file_counter files processed."
        
        pushd "whisper-tmp"
        for file in $(find -maxdepth 1 -type f -name "*.txt"); do
            # Erzeuge json
            output_file="../$outdir_dir/$(echo "$file" | sed 's/txt/json/')"
            jq -n --arg model "$model" --arg text "$(cat $file)" --arg source "$source" '{ model: $model, text: $text, source: $source }' > "$output_file"
            sed -i 's/\\r//g' "$output_file"
        done
        echo "Generated json files"
        # Lösche nicht benötigte whisper output Dateien
        rm *.srt
        rm *.txt
        rm *.vtt
        rm *.json
        rm *.tsv
        popd
        zip -FS -r drive/MyDrive/json.zip json/
    done


  fi
done