# hifiberry
unofficial repo for scripts to set up hifiberry products on raspberry pi with airport

to install
- download raw image and burn onto sd card as per the [instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)
- if using raspberry pi imager, add wifi network and password before burning, enable ssh
- after booting raspberry pi, clone this repo and run `hifiberry.sh`, this will follow [official hifiberry instructions](https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/), you'll be asked for version of hifiberry you have
```
git clone http://github.com/pavelkrotkov/hifiberry.git
./hifiberry/scripts/hifiberry.sh
```
- check that hifiberry card is recognized by running:
```
aplay -l

**** List of PLAYBACK Hardware Devices **** card 0: sndrpihifiberry [snd_rpi_hifiberry_dac], device 0: HifiBerry DAC HiFi pcm5102a-hifi-0 []
Subdevices: 1/1
Subdevice #0: subdevice #0
```
- I found 64bit verion of pi os flaky with hifiberry, if the card doesn't get recognized, use 32bit version
- when the system comes back online after the reboot, you may additionally install airplay](https://appcodelabs.com/7-easy-steps-to-apple-airplay-on-raspberry-pi)
```
./hifiberry/scripts/airplay.sh
```
- enjoy
