#!/bin/bash

# Enable error handling, command echoing, and trap for last command on error
set -e
set -x
trap 'echo "Last command executed: $BASH_COMMAND"' ERR

# Update and upgrade packages
sudo apt-get update
sudo apt-get -y upgrade

# Install required packages
sudo apt-get install -y autoconf automake avahi-daemon build-essential git libasound2-dev libavahi-client-dev libconfig-dev libdaemon-dev libpopt-dev libssl-dev libtool xmltoman rsyslog

# Clone shairport-sync repository and build it
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
autoreconf -i -f
./configure --with-alsa --with-avahi --with-ssl=openssl --with-systemd --with-metadata
make
sudo make install

# Start shairport-sync service and enable it to run on startup
sudo service shairport-sync start
sudo systemctl enable shairport-sync

# Add configuration to /etc/network/interfaces
echo "# Disable wifi power management
wireless-power off" | sudo tee -a /etc/network/interfaces

# Add cron job for updates
(crontab -l 2>/dev/null; echo "0 2 1 * * sudo apt update; sudo apt -y upgrade") | crontab -

# Enable cron logs
sudo systemctl enable rsyslog
sudo sed -i '/#cron.*/s/^#//' /etc/rsyslog.conf

# Reboot the system
sudo reboot

