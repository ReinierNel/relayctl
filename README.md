# relayctl
Simple bash scripts to control relays connected to your raspberry pi with a cron like scheduler to switch ac appliances on or off based on time of day, day of week and month of year. Useful to automate switching appliances on and off based on schedule.

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
Connect
```
              Pin 1 Pin2
           +3V3 [ ] [ ] +5V
 SDA1 / GPIO  2 [ ] [ ] +5V
 SCL1 / GPIO  3 [ ] [ ] GND
        GPIO  4 [ ] [ ] GPIO 14 / TXD0
            GND [ ] [ ] GPIO 15 / RXD0
        GPIO 17 [ ] [ ] GPIO 18
        GPIO 27 [ ] [ ] GND
        GPIO 22 [x] [x] GPIO 23
           +3V3 [ ] [x] GPIO 24
 MOSI / GPIO 10 [ ] [ ] GND
 MISO / GPIO  9 [ ] [x] GPIO 25
 SCLK / GPIO 11 [ ] [ ] GPIO  8 / CE0#
            GND [ ] [ ] GPIO  7 / CE1#
ID_SD / GPIO  0 [ ] [ ] GPIO  1 / ID_SC
        GPIO  5 [ ] [ ] GND
        GPIO  6 [ ] [ ] GPIO 12
        GPIO 13 [ ] [ ] GND
 MISO / GPIO 19 [ ] [ ] GPIO 16 / CE2#
        GPIO 26 [ ] [ ] GPIO 20 / MOSI
            GND [ ] [ ] GPIO 21 / SCLK
             Pin 39 Pin 40
```

Connect your relay’s control circuit to one of the GPIO pins marked an **X** and GND, max 4 relays at this time.

Boot Raspberry Pi OS once logged in you can install relayct using the following command.

```bash
curl -s https://raw.githubusercontent.com/ReinierNel/relayctl/main/setup.sh | sudo bash
```

This start an interactive wizard, follow the prompts to install relayctl

1. Agree License Agreement 
2. Acknowledge that your Relays are connected
3. Select the GPIO Pins your relays are connected to
4. Enter an integer to represent how often the scheduler sould poll recommended is 10 seconds 
5. The next step will run a test to check if all your relays are working
6. End of installation wizard
