# relayctl

```
██████╗ ███████╗██╗      █████╗ ██╗   ██╗ ██████╗████████╗██╗     
██╔══██╗██╔════╝██║     ██╔══██╗╚██╗ ██╔╝██╔════╝╚══██╔══╝██║     
██████╔╝█████╗  ██║     ███████║ ╚████╔╝ ██║        ██║   ██║     
██╔══██╗██╔══╝  ██║     ██╔══██║  ╚██╔╝  ██║        ██║   ██║     
██║  ██║███████╗███████╗██║  ██║   ██║   ╚██████╗   ██║   ███████╗
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝   ╚═╝   ╚══════╝
```

Simple shell scripts to control relays connected to your raspberry pi with a via CLI, cron like scheduler, external switches REST API and a WEB UI.

![tests](https://github.com/reiniernel/relayctl/actions/workflows/testing.yml/badge.svg) ![version](https://img.shields.io/badge/Version-0.1.4-blue) ![stable branch](https://img.shields.io/badge/stable%20branch-main-lightgrey)

## Requirements

### Compatible Raspberry Pi Boards

* [Pi 1 Model B+](https://www.raspberrypi.com/products/raspberry-pi-1-model-b-plus/)
* [Pi 1 Model A+](https://www.raspberrypi.com/products/raspberry-pi-1-model-a-plus/)
* [Pi 2 Model B](https://www.raspberrypi.com/products/raspberry-pi-2-model-b/)
* [Pi Zero](https://www.raspberrypi.com/products/raspberry-pi-zero/)
* [Pi 3 Model B](https://www.raspberrypi.com/products/raspberry-pi-3-model-b/)
* [Pi Zero W](https://www.raspberrypi.com/products/raspberry-pi-zero-w/)
* [Pi 3 Model B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/)
* [Pi 3 Model A+](https://www.raspberrypi.com/products/raspberry-pi-3-model-a-plus/)
* [Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)

### Operating System

* [Raspberry Pi OS Lite](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf-lite.zip)
* [Raspberry Pi OS with desktop](https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf.zip)

## Installation
### Connect

1. Connect your relay’s control circuit to one of the GPIO pins marked with **O** and GND, max 6 relays at this time.
2. Connect your exnternal switches to GPIO pins makred with **I** and +5V, max 6 exnternal switches at this time

```
                  Pin Pin
           +3V3 [ ]1   2[ ] +5V
 SDA1 / GPIO  2 [ ]3   4[ ] +5V
 SCL1 / GPIO  3 [ ]5   6[ ] GND
        GPIO  4 [ ]7   8[ ] GPIO 14 / TXD0
            GND [ ]9   0[ ] GPIO 15 / RXD0
        GPIO 17 [O]11 12[O] GPIO 18
        GPIO 27 [O]13 14[ ] GND
        GPIO 22 [O]15 16[O] GPIO 23
           +3V3 [ ]17 18[O] GPIO 24
 MOSI / GPIO 10 [ ]19 20[ ] GND
 MISO / GPIO  9 [ ]21 22[I] GPIO 25
 SCLK / GPIO 11 [ ]23 24[ ] GPIO  8 / CE0#
            GND [ ]25 26[ ] GPIO  7 / CE1#
ID_SD / GPIO  0 [ ]27 28[ ] GPIO  1 / ID_SC
        GPIO  5 [I]29 30[ ] GND
        GPIO  6 [I]31 32[I] GPIO 12
        GPIO 13 [I]33 34[ ] GND
 MISO / GPIO 19 [ ]35 36[ ] GPIO 16 / CE2#
        GPIO 26 [I]37 38[ ] GPIO 20 / MOSI
            GND [ ]39 40[ ] GPIO 21 / SCLK

```
### Boot and Install

Boot Raspberry Pi OS once logged in you can install relayct using the following command.

```bash
curl -s https://raw.githubusercontent.com/ReinierNel/relayctl/main/setup.sh | sudo bash
```

This start an interactive wizard, follow the prompts to install relayctl

## Uninstall

### Update rc.local

Remove the following entrys from `rc.local`

```bash
/etc/relayctl/relayctl.sh test
/etc/relayctl/scheduler.sh &
/etc/relayctl/external.sh &
```
### Delete relayctl folder

delete the `relayctl` folder in `/etc`

```bash
sudo -rf /etc/relayct
```
### Uninstall Nginx, fcgiwrap and jq

If you enabled the API during the install process you will need uninstall the following packages

* nginx
* fcgiwrap
* jq

run the folloing command to do so

```bash
sudo apt remove -y nginx fcgiwrap jq
```
### Delete the cgi api script

Finaly you will need to delete the CGI api script

```bash
rm -f /usr/lib/cgi-bin/api.cgi
```

## More

For detailed instructions please see the [Wiki](https://github.com/ReinierNel/relayctl/wiki), If you have an Questions or concerns please create an issue here.
