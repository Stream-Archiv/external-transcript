#!/bin/bash
input_file="data.csv"
output_file="urls.txt"
audio_dir="clips"

# Exportiere alle Url aus der input_file
awk -F',' '{print $2}' "$input_file" > "$output_file"

# Downloade alle Audio Dateien
"C:\Users\sebls\Downloads\yt-dlp.exe" --ignore-errors -P "temp:tmp" --download-archive downloaded.bin -a "$output_file" -x -o "$audio_dir/%(original_url)s.%(ext)s"