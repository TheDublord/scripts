
### Purpose

The idea here is a place for me to dump the scripts I make.

## dellSetStaticFanSpeed.sh

Quick and dirty script to prompt you for your IPMI login and what speed you want, then forces it with manual mode. 
A second, more advanced script is also planned in the in-dev folder, but the automatic/time based features that I have planned would require them to
be added to a cron script and that takes time to verify it works which I unfortunately dont have. 

## sysinfo.ps1

Displays system info, run by right clicking and run with powershell

# NOTE: You run these scripts at your own risk, blah blah blah if you value your hearing I wouldnt reccomend anything obove 50% fan speed for *any* server. The first script was designed for my Dell T420, but should work on any rack or tower server running iDRAC 7. It may work with newer servers, it may not. 
