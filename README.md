
### Purpose

The idea here is a place for me to dump the scripts I make.

## dellSetStaticFanSpeed.sh

Requires `ipmitool` to be installed and in the system $PATH

Quick and dirty script to prompt you for your IPMI login and what speed you want, then forces it with manual mode. Script can be altered to have static credentials as well, see file for details.
A second, more advanced script is also planned in the in-dev folder, but the automatic/time based features that I have planned would require them to
be added to a cron script and that takes time to verify it works which I unfortunately dont have. 

## sysinfo.ps1

Displays system info, run by right clicking and run with powershell

# NOTE: You run these scripts at your own risk, blah blah blah if you value your hearing I wouldnt reccomend anything obove 50% fan speed for *any* server. The fan speed script was designed for my Poweredge T420 with iDRAC 7, however it does also appear to work with my R630 running iDRAC 8. Be aware that newer iDRAC 8 versions may have stripped this functionality. 
