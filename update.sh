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

print 'INFO: Update Linux libraries'
exec_command 'pacman -Syu'

print 'INFO: Install konsole package'
exec_command 'pacman -S konsole'

print 'INFO: Settings for autologin'
exec_command "chown root:root ${SCRIPT_DIR}/sddm.conf"
exec_command "cp -rp ${SCRIPT_DIR}/sddm.conf /etc"

print 'INFO: Sleep for 20 seconds ...'
exec_command 'sleep 20'