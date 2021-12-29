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
### Connect

Connect your relay’s control circuit to one of the GPIO pins marked an **X** and GND, max 4 relays at this time.

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
### Boot

Boot Raspberry Pi OS once logged in you can install relayct using the following command.

### Install

```bash
curl -s https://raw.githubusercontent.com/ReinierNel/relayctl/main/setup.sh | sudo bash
```

This start an interactive wizard, follow the prompts to install relayctl

#### 1. License Agreement
![License Agreement](https://github.com/ReinierNel/relayctl/blob/main/docs/1.PNG?raw=true)
#### 2. Acknowledge that your Relays are connected
![Acknowledge that your Relays are connected](https://github.com/ReinierNel/relayctl/blob/main/docs/2.PNG?raw=true)
#### 3. Select the GPIO Pins your relays are connected to
![Select the GPIO Pins your relays are connected to](https://github.com/ReinierNel/relayctl/blob/main/docs/3.PNG?raw=true)
#### 4. Enter an integer to represent how often the scheduler sould poll recommended is 10 seconds
![Select the GPIO Pins your relays are connected to](https://github.com/ReinierNel/relayctl/blob/main/docs/4.PNG?raw=true)
#### 5. The next step will run a test to check if all your relays are working
![run a test](https://github.com/ReinierNel/relayctl/blob/main/docs/5.PNG?raw=true)
#### 6. End of installation wizard
![End](https://github.com/ReinierNel/relayctl/blob/main/docs/6.PNG?raw=true)

## Update Schedule

Edit the following file /etc/relayctl/schedule.list 

Add an ```#``` in front of a schedule to disable it. To add a new schedule add a new line to the file and enter the following details separated by ```|```

|**schedule name**|**start time**|**end time**|**day of week**|**month**|**relay_index**|**on cmd**|**off cmd**|
|-----------------|--------------|------------|---------------|---------|---------------|----------|-----------|
|Geyser1|10:25:00|11:45:00|1 2 3 4 5 6 7|1 2 3 4 5 6 7 8 9 10 11 12|0|/home/pi/relayctl.sh -r=0 on|/home/pi/relayctl.sh -r=0 off
|Geyser2|15:00:00|16:30:00|1 2 3 4 5 6 7|1 2 3 4 5 6 7 8 9 10 11 12|1|/home/pi/relayctl.sh -r=1 on|/home/pi/relayctl.sh -r=1 off

### schedule name

Name of your schedule, will show up in the logs

### start time

Time to execute commands listed in **on cmd** section based on frequency set during the installation process

### end time

Time to execute commands listed in **off cmd** section based on frequency set during the installation process

### day of week

The day of the week to execute on e.g. 1 = Monday, 2 = Tuesday etc.

### month

The month to execute on e.g. 1 = January 2 = February, etc.

### relay_index

Position of Relay e.g. 0 = Relay Connected to GPIO pin 22. etc.

### on cmd

Command to execute when the start time, day of week and month conditions are met 

### off cmd

Command to execute when start time, day of week and month conditions are not met

## Running Manual Relay Actions

> :warning: if there is a schedule running it will overwrite your manual action

See below commands

```bash
/etc/relayctl/relayctl.sh test
/etc/relayctl/relayctl.sh status
/etc/relayctl/relayctl.sh -r={enter relay index here} {on or off}


