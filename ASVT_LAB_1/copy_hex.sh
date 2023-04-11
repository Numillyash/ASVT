#!/bin/sh

sudo cp $1 /
base_name=$(basename $1 .hex) 
echo Base name is $base_name
python decompile.py $base_name