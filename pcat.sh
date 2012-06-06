#!/bin/bash
if [ ! -x $(which pygmentize) ]; then
    echo package \'pygmentize\' is not installed!
    exit -1
fi
 
if [ $# -eq 0 ]; then
    echo usage: `basename $0` "file [file ...]"
    exit -2
fi
 
for FNAME in $@
do
    filename=$(basename "$FNAME")
    extension=${filename##*.}
    pygmentize -l $extension $FNAME
done
