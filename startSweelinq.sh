#!/bin/bash

amidi -p hw:0,0,0 -S F0 7D 1B 53 01 F7

# Only start Sweelinq when delay script returned success (0)
python /home/content/.script/sweelinq_delay.py
if [ $? -eq 0 ]; then
	/opt/Sweelinq/Sweelinq
fi
