#!/bin/bash

read -p "Enter the IP of iDRAC: " IDRAC_IP
read -p "Enter the iDRAC username: " IDRAC_USER
read -p "Enter the iDRAC password: " IDRAC_PASSWORD
echo "hacking server in background"
clear
read -p "Enter fan speed as a % (NOTE: 0-100 is valid, but >50% might be excessive): " FAN_BRRR
hex_speed=$(printf "0x%x" $FAN_BRRR)
echo "Enabling manual mode..."
ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x00
echo "Manual mode enabled! :)"
sleep 1
echo "Setting fans to desired speed..."
ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $hex_speed
sleep 2
echo "They should be at the desired speed now."
sleep 1
echo "Exiting."
sleep 1
exit 0
