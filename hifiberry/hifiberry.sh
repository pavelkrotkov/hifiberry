#!/bin/bash

# Enable error handling and command echoing
set -e
set -x
trap 'echo "Last command executed: $BASH_COMMAND"' ERR

# update system
sudo apt update
sudo apt -y upgrade

# Comment out dtparam=audio=on
sudo sed -i '/dtparam=audio=on/ s/^/# /' /boot/config.txt

# Modify dtoverlay lines
sudo sed -i '/dtoverlay=vc4-fkms-v3d/ s/$/,audio=off/' /boot/config.txt
sudo sed -i '/dtoverlay=vc4-kms-v3d/ s/$/,noaudio/' /boot/config.txt

# User selection for dtoverlay option
echo "Select the DAC type:"
options=("DAC FOR RASPBERRY PI 1/DAC+ LIGHT/DAC ZERO/MINIAMP/BEOCREATE/DAC+ DSP/DAC+ RTC" "DAC+ STANDARD/PRO/AMP2" "DAC2 HD" "DAC+ ADC" "DAC+ ADC PRO" "DIGI+" "DIGI+ PRO" "AMP+ (NOT AMP2!)" "AMP3")
commands=("dtoverlay=hifiberry-dac" "dtoverlay=hifiberry-dacplus" "dtoverlay=hifiberry-dacplushd" "dtoverlay=hifiberry-dacplusadc" "dtoverlay=hifiberry-dacplusadcpro" "dtoverlay=hifiberry-digi" "dtoverlay=hifiberry-digi-pro" "dtoverlay=hifiberry-amp" "dtoverlay=hifiberry-amp3")

select opt in "${options[@]}"
do
    case $opt in
        "DAC FOR RASPBERRY PI 1/DAC+ LIGHT/DAC ZERO/MINIAMP/BEOCREATE/DAC+ DSP/DAC+ RTC")
            echo "${commands[0]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DAC+ STANDARD/PRO/AMP2")
            echo "${commands[1]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DAC2 HD")
            echo "${commands[2]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DAC+ ADC")
            echo "${commands[3]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DAC+ ADC PRO")
            echo "${commands[4]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DIGI+")
            echo "${commands[5]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "DIGI+ PRO")
            echo "${commands[6]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "AMP+ (NOT AMP2!)")
            echo "${commands[7]}" | sudo tee -a /boot/config.txt
            break
            ;;
        "AMP3")
            echo "${commands[8]}" | sudo tee -a /boot/config.txt
            break
            ;;
        *)
            echo "Invalid option $REPLY"
            ;;
    esac
done

# for linux > 5.4 disable the onboard EEPROM by adding
echo "force_eeprom_read=0" | sudo tee -a /boot/config.txt

# Create /etc/asound.conf
echo "pcm.!default {
  type hw card 0
}
ctl.!default {
  type hw card 0
}" | sudo tee /etc/asound.conf

# Delete .asound.conf in the home directory
rm -f ~/.asound.conf

# Reboot
sudo reboot

