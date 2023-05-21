# ketoHEVC - A Batch Video Transcoder for Linux

ketoHEVC is a collection of bash scripts that can be used to transcode video files to the High Efficiency Video Coding (HEVC) format. The scripts traverse through directories containing video files and performs a number of operations:

The scripts traverse through directories containing video files and performs a number of operations:

1. Removes all subtitles from a video file, unless there is one subtitle and it is English, in which case it does not remove it.
2. Removes all but one audio track from a video file, keeping only the English one if available.
3. If the audio track is not in the AAC format or if there are more than two channels, it converts it to a 2 channel AAC audio track with a bitrate of 160.
4. If a video file already meets all these criteria, it is skipped.
5. All processed video files are converted to the MKV format if they are not already and are renamed to include '_hevc' in the filename.

The project includes three versions of the script that use different hardware acceleration technologies:

1. **ketoHEVC_VAAPI.sh**: ketoHEVC_VAAPI.sh: This version uses Intel's Video Acceleration API (VAAPI) for hardware encoding.
2. **ketoHEVC_NVENC.sh**: ketoHEVC_NVENC.sh: This version uses NVIDIA's Video Codec SDK (NVENC) for hardware encoding.
3. **ketoHEVC_AMF.sh**: ketoHEVC_AMF.sh: This version uses AMD's Advanced Media Framework (AMF) for hardware encoding.


## Usage

1. Clone this repository or download the script you want to use.
2. Open the script in a text editor.
3. Change the input_dir variable at the top of the script to the path of your root movie directory.
4. Save and close the script.
5. Open a terminal and navigate to the directory containing the script.
6. Run the script using the command bash scriptname.sh (replace scriptname.sh with the name of the script you are using).

## License

This project is licensed under the MIT License. 
