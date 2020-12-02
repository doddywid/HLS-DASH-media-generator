# HLS DASH Media and Server
This repo contain two things related to HLS and DASH server
1. Shell script to generate HLS and DASH media and metadata (M3U8,MPD)
   --> Credit for original source https://blog.zazu.berlin/internet-programmierung/mpeg-dash-and-hls-adaptive-bitrate-streaming-with-ffmpeg.html
2. Sample 
   --> Credit for original source https://github.com/sahilkashyap64/hls

Notes for #1
- You need to install ffmpeg version n4.x
- Installation using standard APT on Ubuntu/Debian will give you version 3.x (at the moment of this writing)
- Install using Snap instead for Ubuntu. Credit for https://linuxize.com/post/how-to-install-ffmpeg-on-ubuntu-18-04/

Notes for #2
- Need to put index.html, js folder, and main m3u8 file on the same directory pointed by web server
- Any webserver will do, but NGINX is easiest :)
- Edit index.html for respective main m3u8 file name

Repo file structure
- hls_dash.sh --> script file as described on #1
- js folder --> js files required for #2
- index.html --> index.html files for #2
- video1.m3u8 --> sample main m3u8 file for #2 (generated by alternative method below)
- 720_out.m3u8 --> sample sub m3u8 file for #2 (generated by alternative method below)

## Alternative method for #1
Instead of generating media and metadata files using script, below are samples of manual command using ffmpeg
##### # sudo ffmpeg -i ~/Kedungsono_v2.mp4 -c:a aac -strict experimental -c:v libx264 -s 426x240 -aspect 16:9 -f hls -hls_list_size 1000000 -hls_time 5 240_out.m3u8
##### # sudo ffmpeg -i ~/Kedungsono_v2.mp4 -c:a aac -strict experimental -c:v libx264 -s 640x360 -aspect 16:9 -f hls -hls_list_size 1000000 -hls_time 5 360_out.m3u8
##### # sudo ffmpeg -i ~/Kedungsono_v2.mp4 -c:a aac -strict experimental -c:v libx264 -s 854x480 -aspect 16:9 -f hls -hls_list_size 1000000 -hls_time 5 480_out.m3u8
##### # sudo ffmpeg -i ~/Kedungsono_v2.mp4 -c:a aac -strict experimental -c:v libx264 -s 1280x720 -aspect 16:9 -f hls -hls_list_size 1000000 -hls_time 5 720_out.m3u8
##### # sudo ffmpeg -i ~/Kedungsono_v2.mp4 -c:a aac -strict experimental -c:v libx264 -s 1920x1080 -aspect 16:9 -f hls -hls_list_size 1000000 -hls_time 5 1080_out.m3u8
Credit for this goes to https://medium.com/@mayur_solanki/how-to-create-mpd-or-m3u8-video-file-from-server-using-ffmpeg-97e9e1fbf6a3
