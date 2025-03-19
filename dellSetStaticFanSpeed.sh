#!/bin/bash
read -p "Enter the IP of iDRAC: " IDRAC_IP
read -p "Enter the iDRAC username: " IDRAC_USER
read -p "Enter the iDRAC password: " IDRAC_PASSWORD
# To set static entry: Connect read statement, uncomment below variables
#IDRAC_IP="IP"
#IDRAC_USER="user"
#IDRAC_PASSWORD="pass"
echo "hacking server beep boop beep boop"
clear
read -p "Enter fan speed as a % (NOTE: 0-100 is valid, but >50% might be excessive): " FAN_SPEED
# Converts entered number into hex, and appends 0x to make ipmitool happy
hex_speed=$(printf "0x%x" $FAN_SPEED)
echo "Enabling manual mode..."
ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x00
echo "Setting fans to desired speed..."
ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $hex_speed

