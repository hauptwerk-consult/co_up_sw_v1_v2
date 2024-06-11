#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

echo "Initialize ..."
rm -rf tmp
mkdir tmp
date=$(date +"%Y-%m-%d-%M")
LOGFILE="/home/content/Downloads/init_${date}.log"
PW=`cat /home/content/Downloads/.pw`

exec_command () {
	echo ${PW} | sudo -S $1 >${LOGFILE} 2>&1
}

exec_command 'pacman -S konsole"