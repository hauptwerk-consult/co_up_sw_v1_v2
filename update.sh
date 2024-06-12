#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

TIME=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="${HOME}/.tmp/update.log"
print () {
	echo ${TIME} $1 | tee -a ${LOGFILE} 2>&1
}

print 'INFO: Initialize ...'
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PW=`cat /home/content/Downloads/.pw`

exec_command () {
	echo ${PW} | sudo -S $1 | tee -a ${LOGFILE} 2>&1
}

exec_command 'pacman -S konsole'
exec_command 'pacman -S wget'