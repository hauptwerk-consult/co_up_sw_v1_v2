#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

TIME=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="${HOME}/.tmp/update.log"
print () {
	echo ${TIME} $1 ... | tee -a ${LOGFILE} 2>&1
}

print 'INFO: Initialize'
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PW=`cat /home/content/Downloads/.pw`

exec_command () {
	echo ${PW} | sudo -S $1 | tee -a ${LOGFILE} 2>&1
}

print 'INFO: Update Linux libraries'
exec_command 'pacman -Syu --noconfirm'

print 'INFO: Install konsole package'
exec_command 'pacman -S konsole --noconfirm'

print 'INFO: Settings for autologin'
exec_command "chown root:root ${SCRIPT_DIR}/sddm.conf"
exec_command "cp -rp ${SCRIPT_DIR}/sddm.conf /etc"

print 'INFO: Install webkit2gtk'
exec_command 'pacman -S webkit2gtk --noconfirm'

print 'INFO: Create content_sudo file'
exec_command "chown root:root ${SCRIPT_DIR}/user_content_sudo"
exec_command "cp -rp ${SCRIPT_DIR}/user_content_sudo /etc/sudoers.d"

print 'INFO: Move current Sweelinq v1 version'
exec_command "mv /opt/Sweelinq /opt/Sweelinq_v1_${TIME}"

print 'INFO: Download Sweelinq binaries'
exec_command 'wget https://cosweelinq.blob.core.windows.net/sweelinq/Sweelinq.tar'

print 'INFO: Install Sweelinq Version 2'
exec_command "tar -xf /home/content/Downloads/Sweelinq.tar -C /opt"

print 'INFO: Remove all files in Download folder'
exec_command 'rm -rf /home/content/Downloads/*'

print 'INFO: Restart Syetem'
exec_command 'sleep 3'
exec_command 'shutdown -r -t0 now'