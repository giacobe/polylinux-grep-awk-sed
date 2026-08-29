#!/bin/sh
PS1='\W$ '
cd "$HOME" || exit 1
clear
echo "************************************************************************"
echo "* PolyLinux Text Processing: grep, awk, and sed                        *"
echo "* Read README.txt to begin. Your evidence is available through data/.  *"
echo "* Submit one answer per level. Move with nextlevel and prevlevel.      *"
echo "************************************************************************"
echo "* Level: $USER"
cat README.txt
