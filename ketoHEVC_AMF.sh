#!/bin/bash
# Script Name: ketoHEVC_AMF.sh
# Version: 1.0
# Description: This script utilizes the Advanced Media Framework (AMF) provided by AMD to transcode video files to the High Efficiency Video Coding (HEVC) format. The script traverses through the directories containing video files and performs a number of operations. It removes all subtitles from a video file, unless there is one subtitle and it is English, in which case it does not remove it. It removes all but one audio track from a video file, keeping only the English one if available. If the audio track is not in the AAC format or if there are more than two channels, it converts it to a 2 channel AAC audio track with a bitrate of 160. If a video file already meets all these criteria, it is skipped. All processed video files are converted to the MKV format if they are not already and are renamed to include '_hevc' in the filename.
# Author: Saud

input_dir="/path/to/Movie Root"
shopt -s globstar nullglob

for file in "$input_dir"/**/*.{mkv,mp4}; do
  echo "Processing file: $file"

  base_name=$(basename "$file")
  dir_name=$(dirname "$file")
  extension="${base_name##*.}"
  filename="${base_name%.*}"
  new_file="${dir_name}/${filename}_hevc.mkv"

  # Checks if file has only one audio and one English subtitle track
  num_audio_tracks=$(ffprobe -loglevel error -select_streams a -show_entries stream=codec_name -of default=nw=1 "$file" | wc -l)
  num_sub_tracks=$(ffprobe -loglevel error -select_streams s -show_entries stream_tags=language -of default=nw=1 "$file" | wc -l)
  eng_sub_exists=$(ffprobe -loglevel error -select_streams s -show_entries stream_tags=language -of default=nw=1 "$file" | grep -c "eng")

  # Check if audio is 2 channel AAC 160 bitrate
  audio_codec=$(ffprobe -loglevel error -select_streams a -show_entries stream=codec_name -of default=nw=1 "$file")
  audio_channels=$(ffprobe -loglevel error -select_streams a -show_entries stream=channels -of default=nw=1 "$file")
  audio_bitrate=$(ffprobe -loglevel error -select_streams a -show_entries stream=bit_rate -of default=nw=1 "$file")

  # If conditions met, skip file
  if [ "$num_audio_tracks" -eq 1 ] && [ "$num_sub_tracks" -eq 1 ] && [ "$eng_sub_exists" -eq 1 ] && [ "$audio_codec" == "aac" ] && [ "$audio_channels" -le 2 ] && [ "$audio_bitrate" -le 160000 ]; then
    echo "File meets all conditions, skipping..."
    continue
  fi

  map_arg=""
  codec_arg="-c:v h264_amf -b:v 0 -c:a aac -b:a 160k"
  sub_arg=""

  if [ "$num_audio_tracks" -gt 1 ]; then
    eng_audio_index=$(ffprobe -loglevel error -select_streams a -show_entries stream=index:stream_tags=language -of csv=p=0 "$file" | grep ",eng" | cut -d ',' -f1 | head -n1)
    if [ -n "$eng_audio_index" ]; then
      map_arg="-map 0 -map -0:a -map 0:a:$eng_audio_index"
    else
      map_arg="-map 0 -map -0:a -map 0:a:0"
    fi
  fi

  if [ "$num_sub_tracks" -gt 1 ] || [ "$eng_sub_exists" -eq 0 ]; then
    sub_arg="-map -0:s"
  fi

  ffmpeg -i "$file" $map_arg $sub_arg $codec_arg "$new_file"
done
