#!/bin/bash
# Create MMDVM Log backup/restore/age tasks
#
fs=$(grep "/dev/root" /proc/mounts | sed -n "s/.*\(r[ow]\).*/\1/p")
#fs=$(sed -n "/\/dev\/root/ {s/.*\(r[ow]\).*/\1/p}" /proc/mounts)
#rpi-rw
if [ "$fs" == "ro" ]; then
  sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot
fi
#
cd /usr/local/sbin
#=================================================================================================================
echo '#!/bin/bash'                                                      > pistar-mmdvm-log-backups
echo '# Backup MMDVM logs during shutdown/reboots'                     >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo 'if [ ! -d /var/log/pi-star ]; then'                              >> pistar-mmdvm-log-backups
echo '  exit 0'                                                        >> pistar-mmdvm-log-backups
echo 'fi'                                                              >> pistar-mmdvm-log-backups
echo '#rpi-rw'                                                         >> pistar-mmdvm-log-backups
echo 'xro=$(grep "/dev/root" /proc/mounts | sed -n "s/.*\(r[ow]\).*/\1/p")'  >> pistar-mmdvm-log-backups
echo 'if [ "$xro" == "ro" ]; then'                                     >> pistar-mmdvm-log-backups
echo '  sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot'   >> pistar-mmdvm-log-backups
echo 'fi'                                                              >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo 'rbt=0'                                                           >> pistar-mmdvm-log-backups
echo 'while getopts ur opt; do'                                        >> pistar-mmdvm-log-backups
echo '  case $opt in'                                                  >> pistar-mmdvm-log-backups
echo '    r) rbt=1;;'                                                  >> pistar-mmdvm-log-backups
echo '  esac'                                                          >> pistar-mmdvm-log-backups
echo 'done'                                                            >> pistar-mmdvm-log-backups
echo 'shift $(($OPTIND - 1))'                                          >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo 'if [ ! -d /home/pi-star/.mlogs ]; then'                          >> pistar-mmdvm-log-backups
echo '  sudo mkdir /home/pi-star/.mlogs'                               >> pistar-mmdvm-log-backups
echo 'fi'                                                              >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo '#sudo cp -p /var/log/pi-star/MMDVM* /home/pi-star/.mlogs'        >> pistar-mmdvm-log-backups
echo 'cd /var/log/pi-star/'                                            >> pistar-mmdvm-log-backups
echo 'for f in $(ls -tr MMDVM*)'                                       >> pistar-mmdvm-log-backups
echo 'do'                                                              >> pistar-mmdvm-log-backups
echo '  if [ /var/log/pi-star/$f -nt /home/pi-star/.mlogs/$f ]; then'  >> pistar-mmdvm-log-backups
echo '    sudo cp -p /var/log/pi-star/$f /home/pi-star/.mlogs/$f'      >> pistar-mmdvm-log-backups
echo '#   echo $f "backed up"'                                         >> pistar-mmdvm-log-backups
echo '    echo $f "("$(stat -c %y /home/pi-star/.mlogs/$f | cut -c12-19)") backed up"' >> pistar-mmdvm-log-backups
echo '  fi'                                                            >> pistar-mmdvm-log-backups
echo 'done'                                                            >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo '#logger -t "[$$]" "Pi-Star --> MMDVM logs backed up"'            >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo 'if [ $rbt == 1 ]; then'                                          >> pistar-mmdvm-log-backups
echo '  sudo touch /home/pi-star/.mlogs/reboot-$(date +%Y-%m-%d-%H:%M:%S)'   >> pistar-mmdvm-log-backups
echo 'fi'                                                              >> pistar-mmdvm-log-backups
echo '#'                                                               >> pistar-mmdvm-log-backups
echo '#rpi-ro'                                                         >> pistar-mmdvm-log-backups
echo 'if [ "$xro" == "ro" ]; then'                                     >> pistar-mmdvm-log-backups
echo '  sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot'   >> pistar-mmdvm-log-backups
echo 'fi'                                                              >> pistar-mmdvm-log-backups
#=================================================================================================================
sudo chmod +x         pistar-mmdvm-log-backups
sudo chown root:staff pistar-mmdvm-log-backups
#=================================================================================================================
echo '#!/bin/bash'                                                      > pistar-mmdvm-log-restores
echo '# Restore MMDVM logs during startups (reboots)'                  >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '#rpi-rw'                                                         >> pistar-mmdvm-log-restores
echo 'xro=$(grep "/dev/root" /proc/mounts | sed -n "s/.*\(r[ow]\).*/\1/p")'      >> pistar-mmdvm-log-restores
echo 'xmv=$(sudo systemctl is-active mmdvmhost.service)'               >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo 'rbt=0'                                                           >> pistar-mmdvm-log-restores
echo 'all=0'                                                           >> pistar-mmdvm-log-restores
echo 'while getopts ra opt; do'                                        >> pistar-mmdvm-log-restores
echo '  case $opt in'                                                  >> pistar-mmdvm-log-restores
echo '    r) rbt=1;;'                                                  >> pistar-mmdvm-log-restores
echo '    a) all=1;;'                                                  >> pistar-mmdvm-log-restores
echo '  esac'                                                          >> pistar-mmdvm-log-restores
echo 'done'                                                            >> pistar-mmdvm-log-restores
echo 'shift $(($OPTIND - 1))'                                          >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo 'if [ -d /home/pi-star/.mlogs ]; then'                            >> pistar-mmdvm-log-restores
echo '    if [ "$xro" == "ro" ]; then'                                 >> pistar-mmdvm-log-restores
echo '       sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot'        >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '    if [ "$xmv" == "active" ]; then'                             >> pistar-mmdvm-log-restores
echo '       sudo systemctl stop mmdvmhost.service'                    >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '    if [ ! -d /var/log/pi-star ]; then'                          >> pistar-mmdvm-log-restores
echo '       sudo mkdir /var/log/pi-star'                              >> pistar-mmdvm-log-restores
echo '       sudo chown root:mmdvm /var/log/pi-star'                   >> pistar-mmdvm-log-restores
echo '       sudo chmod 775 /var/log/pi-star'                          >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '    n=3'                                                         >> pistar-mmdvm-log-restores
echo '    if [ $all == 1 ]; then'                                      >> pistar-mmdvm-log-restores
echo '       n=10000'                                                  >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '    file1="MMDVM"'                                               >> pistar-mmdvm-log-restores
echo '    file2="/var/log/pi-star/"'                                   >> pistar-mmdvm-log-restores
echo '    file3="/home/pi-star/.mlogs"'                                >> pistar-mmdvm-log-restores
echo '    cd /home/pi-star/.mlogs'                                     >> pistar-mmdvm-log-restores
echo '#   for f in $(ls -tr ${file3}/${file1}* | tail -n $n)'          >> pistar-mmdvm-log-restores
echo '    for f in $(ls -tr ${file1}* | tail -n $n)'                   >> pistar-mmdvm-log-restores
echo '    do'                                                          >> pistar-mmdvm-log-restores
echo '       echo "$f"'                                                >> pistar-mmdvm-log-restores
echo '       sudo cp -p $f ${file2}$f'                                 >> pistar-mmdvm-log-restores
echo '    done'                                                        >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '    reboot=""'                                                   >> pistar-mmdvm-log-restores
echo '    if [ $rbt == 1 ]; then'                                      >> pistar-mmdvm-log-restores
echo '       sudo touch /home/pi-star/.mlogs/restore-$(date +%Y-%m-%d-%H:%M:%S)' >> pistar-mmdvm-log-restores
echo '       reboot="(on reboot)"'                                     >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '    logger -t "[$$]" "Pi-Star --> MMDVM logs restored $reboot <--"'        >> pistar-mmdvm-log-restores
echo '#'                                                               >> pistar-mmdvm-log-restores
echo '    if [ "$xmv" == "active" ]; then'                             >> pistar-mmdvm-log-restores
echo '       sudo systemctl start mmdvmhost.service'                   >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo '    if [ "$xro" == "ro" ]; then'                                 >> pistar-mmdvm-log-restores
echo '       sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot'        >> pistar-mmdvm-log-restores
echo '    fi'                                                          >> pistar-mmdvm-log-restores
echo 'fi'                                                              >> pistar-mmdvm-log-restores
#=================================================================================================================
sudo chmod +x         pistar-mmdvm-log-restores
sudo chown root:staff pistar-mmdvm-log-restores
#=================================================================================================================
echo '#!/bin/bash'                                                      > pistar-mmdvm-log-backup-age
echo '# Age MMDVM log file backups'                                    >> pistar-mmdvm-log-backup-age
echo '#'                                                               >> pistar-mmdvm-log-backup-age
echo 'xro=$(grep "/dev/root" /proc/mounts | sed -n "s/.*\(r[ow]\).*/\1/p")' >> pistar-mmdvm-log-backup-age
echo '#rpi-rw'                                                         >> pistar-mmdvm-log-backup-age
echo 'if [ "$xro" == "ro" ]; then'                                     >> pistar-mmdvm-log-backup-age
echo '  sudo mount -o remount,rw / # sudo mount -o remount,rw /boot'   >> pistar-mmdvm-log-backup-age
echo 'fi'                                                              >> pistar-mmdvm-log-backup-age
echo '#'                                                               >> pistar-mmdvm-log-backup-age
echo 'file=/home/pi-star/.mlogs'                                       >> pistar-mmdvm-log-backup-age
echo 'm0=14                             # number to be kept'           >> pistar-mmdvm-log-backup-age
echo 'if [[ $1 =~ [0-9] ]]; then'                                      >> pistar-mmdvm-log-backup-age
echo '  m0=$1'                                                         >> pistar-mmdvm-log-backup-age
echo 'fi'                                                              >> pistar-mmdvm-log-backup-age
echo 'm1=$(ls ${file}/MMDVM* | wc -l)   # total number of files'       >> pistar-mmdvm-log-backup-age
echo 'm2=$(expr ${m1} - ${m0})          # number to be deleted'        >> pistar-mmdvm-log-backup-age
echo 'if [ ${m2} -gt 0 -a ${m0} -gt 0 ]; then'                         >> pistar-mmdvm-log-backup-age
echo '  filed=$(ls -tr ${file}/MMDVM* | head -n ${m2})'                >> pistar-mmdvm-log-backup-age
echo '  for f in ${filed}; do'                                         >> pistar-mmdvm-log-backup-age
echo '#   echo $f'                                                     >> pistar-mmdvm-log-backup-age
echo '    sudo rm $f'                                                  >> pistar-mmdvm-log-backup-age
echo '  done'                                                          >> pistar-mmdvm-log-backup-age
echo '  filed=$(find ${file}/re* -mtime +${m0})   # del related reboot/restore msgs' >> pistar-mmdvm-log-backup-age
echo '  for f in ${filed}; do'                                         >> pistar-mmdvm-log-backup-age
echo '#   echo $f'                                                     >> pistar-mmdvm-log-backup-age
echo '    sudo rm $f'                                                  >> pistar-mmdvm-log-backup-age
echo '  done'                                                          >> pistar-mmdvm-log-backup-age
echo 'else'                                                            >> pistar-mmdvm-log-backup-age
echo '  m2=0'                                                          >> pistar-mmdvm-log-backup-age
echo 'fi'                                                              >> pistar-mmdvm-log-backup-age
echo 'logger -t "[$$]" "Pi-Star --> MMDVM log backups aged: $m2 files <--"' >> pistar-mmdvm-log-backup-age
echo '#'                                                               >> pistar-mmdvm-log-backup-age
echo '#rpi-ro'                                                         >> pistar-mmdvm-log-backup-age
echo 'if [ "$xro" == "ro" ]; then'                                     >> pistar-mmdvm-log-backup-age
echo '  sudo mount -o remount,ro / # sudo mount -o remount,ro /boot'   >> pistar-mmdvm-log-backup-age
echo 'fi'                                                              >> pistar-mmdvm-log-backup-age
#=================================================================================================================
sudo chmod +x         pistar-mmdvm-log-backup-age
sudo chown root:staff pistar-mmdvm-log-backup-age
#=================================================================================================================
cd /etc/cron.daily
echo '#!/bin/bash'                                                      > pistar-daily-mmdvm-log-backup-age
echo '# Age MMDVM log backups'                                         >> pistar-daily-mmdvm-log-backup-age
echo '/usr/local/sbin/pistar-mmdvm-log-backup-age'                     >> pistar-daily-mmdvm-log-backup-age
echo 'exit 0'                                                          >> pistar-daily-mmdvm-log-backup-age
#=================================================================================================================
sudo chmod +x         pistar-daily-mmdvm-log-backup-age
sudo chown root:root  pistar-daily-mmdvm-log-backup-age
#
#rpi-ro
if [ "$fs" == "ro" ]; then
  sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot
fi
