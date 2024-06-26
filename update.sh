#!/bin/bash
#https://github.com/hauptwerk-consult/co_up_sw_v1_v2.git

TIME1=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="${HOME}/.tmp/update.log"
SUITE=`ls -al /home/content/Sweelinq/UserData | grep /Suite_ | awk '{print $11}' | awk 'BEGIN { FS = "/" } ; { print $5 };'`
SWV2=NOTEXISTS
if [ -d /opt/Sweelinq_v1* ]
then 
	SWV2=EXISTS
fi

print () {
	TIME2=$(date +"%Y-%m-%d-%H-%M-%S")
	echo ${TIME2} $1 ... | tee -a ${LOGFILE} 2>&1
	sleep 3
}

print "INFO: Initialize for Content ${SUITE}"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PW=`cat ${HOME}/.pw`

exec_command () {
	script -ac "echo ${PW} | sudo -S $1" -q ${LOGFILE}
}

print 'INFO: Update Linux libraries'
exec_command "pacman -Syu --noconfirm"

print 'INFO: Install konsole package'
exec_command "pacman -S konsole --noconfirm"

print 'INFO: Settings for autologin'
exec_command "chown root:root ${SCRIPT_DIR}/sddm.conf"
exec_command "cp -rp ${SCRIPT_DIR}/sddm.conf /etc"

print 'INFO: Install webkit2gtk'
exec_command "pacman -S webkit2gtk --noconfirm"

print 'INFO: Install tk'
exec_command "pacman -S tk --noconfirm"

print 'INFO: Create content_sudo file'
exec_command "chown root:root ${SCRIPT_DIR}/user_content_sudo"
exec_command "cp -rp ${SCRIPT_DIR}/user_content_sudo /etc/sudoers.d"

print 'INFO: Move startSweelinq.sh file'
exec_command "mv -f ${SCRIPT_DIR}/startSweelinq.sh ${HOME}/.script"
exec_command "chmod +x ${HOME}/.script/startSweelinq.sh"

print 'INFO: Move sweelinq_delay.py file'
exec_command "mv -f ${SCRIPT_DIR}/sweelinq_delay.py ${HOME}/.script"

if [ $SWV2 = "NOTEXISTS" ]
then
	print 'INFO: Download Sweelinq binaries'
 	exec_command "wget https://cosweelinq.blob.core.windows.net/sweelinq/Sweelinq.tar"
fi

if [ $SWV2 = "NOTEXISTS" ]
then
	print 'INFO: Move current Sweelinq v1 version'
	exec_command "mv -f /opt/Sweelinq /opt/Sweelinq_v1_${TIME1}"
fi

if [ $SWV2 = "NOTEXISTS" ]
then
	print 'INFO: Install Sweelinq Version 2'
	exec_command "tar -xf /home/content/Downloads/Sweelinq.tar -C /opt"
fi

print 'INFO: Copy Sweelinq Configuration Files'
exec_command "cp -rp ${SCRIPT_DIR}/GeneralSettings* ${HOME}/.swlnqcfg"

if [ "${SUITE}" == "Suite_II" ]; then
	print 'INFO: Make symoblic link for Suite_II'
	exec_command "ln -sf ${HOME}/.swlnqcfg/GeneralSettings-Suite_II.swgs ${HOME}/Sweelinq/UserData/GeneralSettings.swgs"
fi

if [ "${SUITE}" == "Suite_III" ]; then
	print 'INFO: Make symoblic link for Suite_III'
	exec_command "ln -sf ${HOME}/.swlnqcfg/GeneralSettings-Suite_III.swgs ${HOME}/Sweelinq/UserData/GeneralSettings.swgs"
fi

print 'INFO: Install extra Packages'
exec_command "pacman -S acpid --noconfirm"
exec_command "systemctl start acpid"
exec_command "systemctl enable acpid"

print 'INFO: Create power files'
exec_command "sudo mkdir -p /etc/acpi/events"
exec_command "chown root:root ${SCRIPT_DIR}/power"
exec_command "cp -rp ${SCRIPT_DIR}/power /etc/acpi/events"
exec_command "chmod +x ${SCRIPT_DIR}/poweroff.sh"
exec_command "cp -rp ${SCRIPT_DIR}/poweroff.sh ${HOME}/.script"
exec_command "chown root:root ${SCRIPT_DIR}/snd-virmidi.conf"
exec_command "cp -rp ${SCRIPT_DIR}/snd-virmidi.conf /etc/modules-load.d"
exec_command "cp -rp ${SCRIPT_DIR}/powerdevilrc ${HOME}/.config"

print 'INFO: Remove all files in Downloads folder'
exec_command "rm -rf /home/content/Downloads/*"

if [ $SWV2 = "NOTEXISTS" ]
then
	print 'INFO: Remove old Organ files'
	exec_command "rm -rf ${HOME}/Sweelinq/Organs/*.swop"
	exec_command "rm -rf ${HOME}/Sweelinq/Organs/*.bin"
fi

print 'INFO: Restart System'
exec_command "shutdown -r -t0 now"