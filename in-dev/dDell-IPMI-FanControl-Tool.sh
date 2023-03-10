#!/bin/bash

# Prompt user
read -p "Enter the IP of iDRAC: " IDRAC_IP
read -p "Enter the iDRAC username: " IDRAC_USER
read -p "Enter the iDRAC password: " IDRAC_PASSWORD

# Prompt user to enable manual mode
read -p "Force fans into manual mode? This is required to use the script. No disables manual mode. (Y/N): " manual_yn
manual_yn=$(manual_yn^^)
if [ "$manual_yn" = "Y"
  then
    echo "Enabling manual mode..."
    ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x00
    echo "Manual mode enabled! :)"
  elif [ "$manual_yn" = "N"
    echo "Disabling manual mode..."
    ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x01 0x01
    echo "Disabled manual mode :("
  else
    echo "Enter a valid input lol"
    exit 1
fi
clear 

# Get user input for fan control
echo "Please select fan control option:"
echo "1. Static fan speed"
echo "2. Time based static speed"
read -p "Enter selection: " fan_control
clear
# Set fan control settings based on user input
case $fan_control in
  1)
     read -p "Enter fan speed as a %. (0-100): " static_speed
     man_hex=$(printf "0x%x" $static_speed)
     if [ $static_speed -gt 100 ] || [ $static_speed -lt 0 ]
     then 
     echo "Enter in a valid number LUL"
     else 
     ipmitool -I lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff $man_hex
     fi
     ;;
  2) 
  echo "This is coming soon (probably never lol) + Id like to do an automatic curve as well. Bye!"
  sleep 5
  exit 0
  ;;
  *) echo "Invalid selection" && exit 1 ;;
esac

# Format output
