#! /bin/bash
popuplib=/usr/bin/popup

[ -f $popuplib ] && . $popuplib || exec printf "File not found: %s\n" $popuplib

ping $(entry "ping me")
