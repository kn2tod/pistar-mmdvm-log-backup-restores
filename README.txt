Pi-Star creates a number of running log files in temporary storage (tmpf) which are lost when 
the system is shut down and restarted. Retention of these files for post analysis or to restore 
current activity after a sudden outage is desirable.

This project creates the necessary scripts and SYSTEMD units (.service and .timer) to backup
(save) and restore the MMDVM files automatically. Backups are taken on a periodic basis and 
during shutdowns; restores are initiated during regular system startup. Aging (rotation) of
the backups occurs during Pi-Star's nightly update processing.

To install, download the two Build-* files; execute BUILD-Log-Backup-Restore-Tasks.sh first 
(install the required scripts), then execute the BUILD-Log-Systemd-Tasks.sh file to actually 
set the system to run the necessary scripts on a periodic basis and during shutdowns/restarts.

 wget 'https://github.com/kn2tod/pistar-mmdvm-log-backup-restores/raw/main/Build-MMDVM-Log-Backup-Restore-Tasks.sh'
 wget 'https://github.com/kn2tod/pistar-mmdvm-log-backup-restores/raw/main/Build-MMDVM-Log-Systemd-Tasks.sh'

or

 wget 'https://raw.githubusercontent.com/kn2tod/pistar-mmdvm-log-backup-restores/main/Build-MMDVM-Log-Backup-Restore-Tasks.sh'
 
wget 'https://raw.githubusercontent.com/kn2tod/pistar-mmdvm-log-backup-restores/main/Build-MMDVM-Log-Systemd-Tasks.sh'


then

 sudo bash Build-MMDVM-Log-Backup-Restore-Tasks.sh
 sudo bash Build-MMDVM-Log-Systemd-Tasks.sh
 
The remaining files (mmdvm-log-* and pistar-mmdvm-log-*) in this project are included for a 
look-see for what's going on, as these files are created by the Build-* scripts and do not
need to be downloaded.

----

The MMDVM log files are created by the MMDVM "hat" firmware in the /var/log/pi-star directory; only
two or three files should be present: yesterday's file, today's file, and tomorrow's file; as the
firmware runs on UTC, a file postfixed with tomorrow's date (but with today's create date) will 
created depending on the time zone you are operating under (all the files in /var/log/pi-star are 
time-stamped according to the current time zone). 

The files in /var/log/pi-star are aged (rotated) so no more than two or three files should be 
present at any given time.  Log files are copied to the /home/pi-star/.mlogs directory; as
presently set up, 14 days of logs are kept.  

In addition to the MMDVM log files, additional files are created to log shutdowns and restores:
zero-length files (reboot-*/restore-*); because RPI's do not have a RTC, the restore event log file 
will not have the correct time stamps, as the restore usally occurs before the system is resynced 
with the Internet so that last known (faked) time is used for the time-stamp.

---

Backups are scheduled every 10 minutes and usually cover most operating sitatations.  Backups are 
also taken as part of a regulary initiated shutdown/reboot.  If the system shuts down unexpectedly
(power outage), some log data may be lost. 

---

14 days of backups are currently retained; only the last 2-3 files are restored however.
The retention is set to allow post-operative analysis of the logs for various activities.

Aging (rotation) of the backups is performed via a script added to /etc/cron.daily/ which runs
when the normal nightly Pi-Star update processing kicks off.

---

total 5024
-rw-r--r-- 1 root root 256156 Oct 11 19:55 MMDVM-2021-10-11.log
-rw-r--r-- 1 root root      0 Oct 12 15:48 reboot-2021-10-12-15:48:30
-rw-r--r-- 1 root root      0 Oct 12 15:49 restore-2021-10-12-15:49:11
-rw-r--r-- 1 root root 294295 Oct 12 19:58 MMDVM-2021-10-12.log
-rw-r--r-- 1 root root 222663 Oct 13 19:58 MMDVM-2021-10-13.log
-rw-r--r-- 1 root root      0 Oct 14 10:41 reboot-2021-10-14-10:41:14
-rw-r--r-- 1 root root      0 Oct 14 10:41 restore-2021-10-14-10:41:53
-rw-r--r-- 1 root root 271210 Oct 14 19:56 MMDVM-2021-10-14.log
-rw-r--r-- 1 root root 233509 Oct 15 19:51 MMDVM-2021-10-15.log
-rw-r--r-- 1 root root 419743 Oct 16 19:56 MMDVM-2021-10-16.log
-rw-r--r-- 1 root root 341063 Oct 17 19:46 MMDVM-2021-10-17.log
-rw-r--r-- 1 root root 234474 Oct 18 19:55 MMDVM-2021-10-18.log
-rw-r--r-- 1 root root 601816 Oct 19 19:59 MMDVM-2021-10-19.log
-rw-r--r-- 1 root root 315666 Oct 20 19:53 MMDVM-2021-10-20.log
-rw-r--r-- 1 root root 466228 Oct 21 19:52 MMDVM-2021-10-21.log
-rw-r--r-- 1 root root 657346 Oct 22 19:59 MMDVM-2021-10-22.log
-rw-r--r-- 1 root root 477595 Oct 23 19:55 MMDVM-2021-10-23.log
-rw-r--r-- 1 root root 322558 Oct 24 14:52 MMDVM-2021-10-24.log
total 784
-rw-r--r-- 1 root root 477595 Oct 23 19:55 MMDVM-2021-10-23.log
-rw-r--r-- 1 root root 323554 Oct 24 15:05 MMDVM-2021-10-24.log

