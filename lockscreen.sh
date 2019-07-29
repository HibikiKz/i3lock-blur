#!/bin/sh

ScreenPath=/tmp/screen.png
Res=$(xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')
ResH=$(echo $Res| sed 's/[^x]*[x]//')

ffmpeg -f x11grab \
			 -video_size $Res -y \
			 -probesize 100M \
			 -i $DISPLAY \
			 -i $(dirname $(readlink -f $0))/padlock.png \
			 -filter_complex \
			 	"[0:v]boxblur=10[ibg]; \
				 [1:0]scale=$ResH/5:$ResH/5[ilock]; \
				 [ibg][ilock]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" \
			 -vframes 1 $ScreenPath

i3lock -i $ScreenPath
