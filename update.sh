#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

echo "Initialize ..."
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
DATE=$(date +"%Y-%m-%d-%M")
LOGFILE="/${SCRIPT_DIR}/${DATE}.log"
PW=`cat /home/content/Downloads/.pw`

exec_command () {
	echo ${PW} | sudo -S $1 | tee -a ${LOGFILE} 2>&1
}

exec_command 'pacman -S konsole'
exec_command 'pacman -S wget'