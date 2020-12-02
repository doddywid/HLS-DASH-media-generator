#!/bin/bash
#HLS, Dash and fallback code from zazu.berlin 2020. Fixed by Doddy 12022020, Use ffmpeg version n4.3.1 installed from Snap Ubuntu 18.04

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <input_video_path> <output_video_path> <MODE: HLS|DASH>" >&2
  exit 1
fi

VIDEO_IN=$1
VIDEO_OUT=$2
HLS_TIME=3
FPS=25
PRESET_P=medium
V_SIZE_1=1920x1080
V_SIZE_2=1280x720
V_SIZE_3=854x480
V_SIZE_4=640x360
V_SIZE_5=426x240
#V_SIZE_6=2560x1440
#V_SIZE_7=3840x2160

# HLS
if [[ $3 == "HLS" ]]; then
   echo "$3 selected"
   mkdir HLS
   ffmpeg -i $VIDEO_IN \
    -preset $PRESET_P -r $FPS -c:v libx264 -pix_fmt yuv420p \
    -map v:0 -s:0 $V_SIZE_1 -b:v:0 5M -maxrate:0 6M -bufsize:0 10M \
    -map v:0 -s:1 $V_SIZE_2 -b:v:1 3M -maxrate:1 4M -bufsize:1 6M \
    -map v:0 -s:2 $V_SIZE_3 -b:v:2 1.5M -maxrate:2 2M -bufsize:2 3M \
    -map v:0 -s:3 $V_SIZE_4 -b:v:3 800k -maxrate:3 1M -bufsize:3 1.6M \
    -map v:0 -s:4 $V_SIZE_5 -b:v:4 500k -maxrate:4 700k -bufsize:4 1M \
    -map a:0 -map a:0 -map a:0 -map a:0 -map a:0 -c:a aac -b:a 128k -ac 1 -ar 44100 \
    -f hls -hls_time $HLS_TIME -hls_playlist_type vod -hls_flags independent_segments \
    -master_pl_name $VIDEO_OUT.m3u8 \
    -hls_segment_filename HLS/stream_%v/s%06d.ts \
    -strftime_mkdir 1 \
    -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2 v:3,a:3 v:4,a:4" HLS/stream_%v.m3u8
fi

# DASH
if [[ $3 == "DASH" ]]; then
   echo "DASH selected"
   mkdir DASH
   ffmpeg -i $VIDEO_IN \
    -preset $PRESET_P -r $FPS -c:v libx264 -pix_fmt yuv420p -c:a aac -b:a 128k -ac 1 -ar 44100 \
    -map v:0 -s:0 $V_SIZE_1 -b:v:0 5M -maxrate:0 6M -bufsize:0 10M \
    -map v:0 -s:1 $V_SIZE_2 -b:v:1 3M -maxrate:1 4M -bufsize:1 6M \
    -map v:0 -s:2 $V_SIZE_3 -b:v:2 1.5M -maxrate:2 2M -bufsize:2 3M \
    -map v:0 -s:3 $V_SIZE_4 -b:v:3 800k -maxrate:3 1M -bufsize:3 1.6M \
    -map v:0 -s:4 $V_SIZE_5 -b:v:4 500k -maxrate:4 700k -bufsize:4 1M \
    -map a:0 \
    -init_seg_name init\$RepresentationID\$.\$ext\$ -media_seg_name chunk\$RepresentationID\$-\$Number%05d\$.\$ext\$ \
    -use_template 1 -use_timeline 1  \
    -seg_duration 4 -adaptation_sets "id=0,streams=v id=1,streams=a" \
    -f dash DASH/dash.mpd
fi
