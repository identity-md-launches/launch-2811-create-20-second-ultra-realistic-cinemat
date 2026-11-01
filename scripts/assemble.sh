#!/usr/bin/env bash
# Assemble five 5 s generated clips into a 20.0 s 1920x1080 H.264/AAC music-video cut.
# Each clip is trimmed to 4.4 s and joined with 0.5 s cross-dissolves:
# 5 * 4.4 - 4 * 0.5 = 20.0 s. Audio is a silent AAC stereo track (the Suno song is added later).
# Usage (from repo root): scripts/assemble.sh s1.mp4 s2.mp4 s3.mp4 s4.mp4 s5.mp4 artifacts/video.mp4
# Prefix ffmpeg with imd-media where that wrapper is required (FFMPEG env var).
set -euo pipefail
FFMPEG=${FFMPEG:-ffmpeg}
[ $# -eq 6 ] || { echo "usage: $0 c1 c2 c3 c4 c5 out.mp4" >&2; exit 1; }
# Per-clip start offsets (s): scene 5 starts later so the closing pull-back is kept.
S=(0 0.3 0.3 0.6 0.6)
V="crop=1920:1080,setsar=1,fps=24,format=yuv420p,eq=saturation=1.05:contrast=1.03"
F=""
for i in 0 1 2 3 4; do
  F+="[$i:v]trim=start=${S[$i]}:duration=4.4,setpts=PTS-STARTPTS,$V[v$i];"
done
F+="[v0][v1]xfade=transition=fade:duration=0.5:offset=3.9[x1];"
F+="[x1][v2]xfade=transition=fade:duration=0.5:offset=7.8[x2];"
F+="[x2][v3]xfade=transition=fade:duration=0.5:offset=11.7[x3];"
F+="[x3][v4]xfade=transition=fade:duration=0.5:offset=15.6,fade=t=in:st=0:d=0.4,fade=t=out:st=19.4:d=0.6[v]"
$FFMPEG -v error -y -i "$1" -i "$2" -i "$3" -i "$4" -i "$5" \
  -f lavfi -t 20 -i anullsrc=channel_layout=stereo:sample_rate=48000 \
  -filter_complex "$F" -map "[v]" -map 5:a \
  -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -profile:v high -r 24 \
  -c:a aac -b:a 128k -t 20 -movflags +faststart "$6"
