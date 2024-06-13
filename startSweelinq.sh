#!/bin/bash

amidi -p hw:0,0,0 -S F0 7D 1B 53 01 F7

# Start Sweelinq after the Internet connection is set up
python /home/content/.script/sweelinq_delay.py
/opt/Sweelinq/Sweelinq
