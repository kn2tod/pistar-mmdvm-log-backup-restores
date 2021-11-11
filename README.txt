Every time a Pi-Star system is booted, the dashboard comes up with an empty LH (Last Heard)
list. Internally, Pi-Star creates a number of running log files in temporary storage (tmpf)
which are lost when the system is shut down and restarted. Retention of these files for post
analysis or to restore current activity after a sudden or planned outage is desirable.

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

Alternately, you can simply clone this project:

  rpi-rw
  git clone https://github.com/kn2tod/pistar-mmdvm-log-backup-restores.git
  cd pistar-mmdvm-log-backup-restores
  sudo bash Build-MMDVM-Log-Backup-Restore-Tasks.sh
  sudo bash Build-MMDVM-Log-Systemd-Tasks

(These two build scripts can be rerun as needed to incorporate any changes to the process.)

The remaining files (mmdvm-log-* and pistar-mmdvm-log-*) in this project are included for a
look-see for what's going on, as these files are created by the Build-* scripts and do not
need to be downloaded.

----

The MMDVM log files are created by the MMDVM "hat" firmware in the /var/log/pi-star directory;
only two or three files should be present: yesterday's file, today's file, and tomorrow's file;
as the firmware runs on UTC, a file postfixed with tomorrow's date (but with today's create
date) will be created depending on the time zone you are operating under (all the files in
/var/log/pi-star are time-stamped according to the current time zone).  The files in this
directory are aged (rotated) so no more than two or three files should be present at any given
time.

Log files are copied to the /home/pi-star/.mlogs directory; backups are scheduled every 10
minutes and usually cover most operating situtations.  Backups are also taken as part of a
regulary initiated shutdown/reboot.  If the system shuts down unexpectedly (power outage),
some log data may be lost.

14 days of backups are currently retained; only the last 2-3 files are restored however.
The retention is set to allow post-operative analysis of the logs for various activities.
Aging (rotation) of the backups is performed via a script added to /etc/cron.daily/ which runs
when the normal nightly Pi-Star update processing kicks off.

In addition to the MMDVM log files, additional files are created to log shutdowns and restores:
zero-length files (reboot-*/restore-*); because RPi's do not have an RTC, the restore event log
file will not have the correct time stamps, as the restore usally occurs before the system is
resynced with the Internet so that last known (faked) time is used for the time-stamp.

---

For monitoring, use this command (add to .bash_aliases):

  alias mlogq='ls -lAtr /home/pi-star/.mlogs; ls -lA /var/log/pi-star'

Sample result:

pi-star@pi-star-1(ro):~$ mlogq
total 5856
-rw-r--r-- 1 root root 227848 Oct 26 19:59 MMDVM-2021-10-26.log
-rw-r--r-- 1 root root 445545 Oct 27 19:59 MMDVM-2021-10-27.log
-rw-r--r-- 1 root root 546074 Oct 28 19:57 MMDVM-2021-10-28.log
-rw-r--r-- 1 root root 315078 Oct 29 19:58 MMDVM-2021-10-29.log
-rw-r--r-- 1 root root 794596 Oct 30 19:50 MMDVM-2021-10-30.log
-rw-r--r-- 1 root root 339394 Oct 31 19:36 MMDVM-2021-10-31.log
-rw-r--r-- 1 root root      0 Nov  1 13:58 reboot-2021-11-01-13:58:35
-rw-r--r-- 1 root root      0 Nov  1 13:58 restore-2021-11-01-13:58:57
-rw-r--r-- 1 root root 391424 Nov  1 19:55 MMDVM-2021-11-01.log
-rw-r--r-- 1 root root 359001 Nov  2 19:56 MMDVM-2021-11-02.log
-rw-r--r-- 1 root root 277095 Nov  3 19:59 MMDVM-2021-11-03.log
-rw-r--r-- 1 root root 324603 Nov  4 19:55 MMDVM-2021-11-04.log
-rw-r--r-- 1 root root      0 Nov  5 10:58 reboot-2021-11-05-10:58:52
-rw-r--r-- 1 root root      0 Nov  5 10:59 restore-2021-11-05-10:59:18
-rw-r--r-- 1 root root 650884 Nov  5 19:51 MMDVM-2021-11-05.log
-rw-r--r-- 1 root root 351975 Nov  6 19:58 MMDVM-2021-11-06.log
-rw-r--r-- 1 root root 660605 Nov  7 18:49 MMDVM-2021-11-07.log
-rw-r--r-- 1 root root 260342 Nov  8 18:56 MMDVM-2021-11-08.log
-rw-r--r-- 1 root root  29597 Nov  8 19:39 MMDVM-2021-11-09.log
total 936
-rw-r--r-- 1 root root 660605 Nov  7 18:49 MMDVM-2021-11-07.log
-rw-r--r-- 1 root root 260342 Nov  8 18:56 MMDVM-2021-11-08.log
-rw-r--r-- 1 root root  31047 Nov  8 19:42 MMDVM-2021-11-09.log

Sample (extract) from system logs:

pi-star@pi-star-1(ro):~$ grep -shie "MMDVM" {/var/log/syslog.1,/var/log/syslog} 
Nov  9 13:20:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 13:20:02 pi-star-9 pistar-mmdvm-log-backups[5138]: MMDVM-2021-11-09.log backed up
Nov  9 13:20:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 13:30:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 13:30:02 pi-star-9 pistar-mmdvm-log-backups[14346]: MMDVM-2021-11-09.log backed up
Nov  9 13:30:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 13:40:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 13:40:01 pi-star-9 pistar-mmdvm-log-backups[23556]: MMDVM-2021-11-09.log backed up
Nov  9 13:40:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 13:50:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 13:50:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:00:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:00:01 pi-star-9 pistar-mmdvm-log-backups[9641]: MMDVM-2021-11-09.log backed up
Nov  9 14:00:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:10:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:10:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:20:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:20:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:30:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:30:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:40:02 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:40:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 14:50:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 14:50:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 15:00:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 15:00:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 15:10:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 15:10:01 pi-star-9 pistar-mmdvm-log-backups[9479]: MMDVM-2021-11-09.log backed up
Nov  9 15:10:01 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 15:20:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 15:20:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 15:30:01 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 15:30:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
Nov  9 15:40:02 pi-star-9 systemd[1]: Started Backup MMDVM log files.
Nov  9 15:40:02 pi-star-9 systemd[1]: mmdvm-log-backup.service: Succeeded.
