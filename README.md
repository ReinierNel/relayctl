# relayctl -- TBA

## Install

Write [Raspberry Pi OS Lite](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz) to micro SD card, insert and boot the Pi

Set your your time zone using `sudo raspi-config` and any other preferences you might have.

Next install using the following command

```bash
curl https://raw.githubusercontent.com/ReinierNel/relayctl/1.0.0/setup.sh | bash
```