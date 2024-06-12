#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

TIME=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="${HOME}/.tmp/update.log"
print () {
	echo ${TIME} $1 ... | tee -a ${LOGFILE} 2>&1
}

print 'INFO: Initialize'
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PW=`cat ${HOME}/.pw`

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

print 'INFO: Install tk'
exec_command 'pacman -S tk --noconfirm'

print 'INFO: Create content_sudo file'
exec_command "chown root:root ${SCRIPT_DIR}/user_content_sudo"
exec_command "cp -rp ${SCRIPT_DIR}/user_content_sudo /etc/sudoers.d"

print 'INFO: Check Suite Version'
exec_command "SUITE=`ls -al /home/content/Sweelinq/UserData | grep Suite_ | awk '{print $11}' | awk 'BEGIN { FS = "/" } ; { print $5 };'`"

print 'INFO: Move startSweelinq.sh file'
exec_command "mv ${SCRIPT_DIR}/startSweelinq.sh ${HOME}/.script"
exec_command "chmod +x ${HOME}/.script/startSweelinq.sh"

print 'INFO: Move sweelinq_delay.py file'
exec_command "mv ${SCRIPT_DIR}/sweelinq_delay.py ${HOME}/.script"

print 'INFO: Move current Sweelinq v1 version'
exec_command "mv /opt/Sweelinq /opt/Sweelinq_v1_${TIME}"

print 'INFO: Download Sweelinq binaries'
exec_command 'wget https://cosweelinq.blob.core.windows.net/sweelinq/Sweelinq.tar'

print 'INFO: Install Sweelinq Version 2'
exec_command "tar -xf /home/content/Downloads/Sweelinq.tar -C /opt"

print 'INFO: Copy Sweelinq Configuration Files'
exec_command "cp -rp ${SCRIPT_DIR}/GeneralSettings* ${HOME}/.swlnqcfg"

if [ "$SUITE" == "Suite_II" ]; then
	print 'INFO: Make symoblic link for Suite_II'
	exec_command "ln -sf ${HOME}/.swlnqcfg/GeneralSettings-Suite_II.swgs ${HOME}/Sweelinq/UserData/GeneralSettings.swgs"
fi

if [ "$SUITE" == "Suite_III" ]; then
	print 'INFO: Make symoblic link for Suite_III'
	exec_command "ln -sf ${HOME}/.swlnqcfg/GeneralSettings-Suite_III.swgs ${HOME}/Sweelinq/UserData/GeneralSettings.swgs"
fi

print 'INFO: Install extra Packages'
exec_command 'pacman -S acpid --noconfirm'
exec_command 'systemctl start acpid'
exec_command 'systemctl enable acpid'

print 'INFO: Create power file'
exec_command "sudo mkdir -p /etc/acpi/events"
exec_command "chown root:root ${SCRIPT_DIR}/power"
exec_command "cp -rp ${SCRIPT_DIR}/power /etc/acpi/events"
exec_command "cp -rp ${SCRIPT_DIR}/poweroff.sh ${HOME}/.script"
exec_command "chown root:root snd-virmidi.conf"
exec_command "cp -rp ${SCRIPT_DIR}/snd-virmidi.conf /etc/modules-load.d"

print 'INFO: Remove all files in Downloads folder'
exec_command 'rm -rf /home/content/Downloads/*'

print 'INFO: Remove old Organ files'
exec_command "rm -rf ${HOME}/Sweelinq/Organs/*.swop"
exec_command "rm -rf ${HOME}/Sweelinq/Organs/*.bin"

print 'INFO: Restart System'
exec_command 'sleep 3'
exec_command 'shutdown -r -t0 now'