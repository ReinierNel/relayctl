# relayctl

```
██████╗ ███████╗██╗      █████╗ ██╗   ██╗ ██████╗████████╗██╗     
██╔══██╗██╔════╝██║     ██╔══██╗╚██╗ ██╔╝██╔════╝╚══██╔══╝██║     
██████╔╝█████╗  ██║     ███████║ ╚████╔╝ ██║        ██║   ██║     
██╔══██╗██╔══╝  ██║     ██╔══██║  ╚██╔╝  ██║        ██║   ██║     
██║  ██║███████╗███████╗██║  ██║   ██║   ╚██████╗   ██║   ███████╗
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝   ╚═╝   ╚══════╝
```

Simple shell scripts to control relays connected to your raspberry pi with a via CLI, cron like scheduler, external switches and a REST API. 

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

#### 1. License Agreement
![License Agreement](https://github.com/ReinierNel/relayctl/blob/main/docs/1.PNG?raw=true)
#### 2. Acknowledge that your Relays are connected
![Acknowledge that your Relays are connected](https://github.com/ReinierNel/relayctl/blob/main/docs/2.PNG?raw=true)
#### 3. Select the GPIO Pins your relays are connected to
![Select the GPIO Pins your relays are connected to](https://github.com/ReinierNel/relayctl/blob/main/docs/3.PNG?raw=true)
#### 4. Select the GPIO Pins your external switches are conencted to
![Select the GPIO Pins your external switches are conencted to](https://github.com/ReinierNel/relayctl/blob/main/docs/4.PNG?raw=true)
#### 5. Enter an integer to represent how often the scheduler sould poll recommended is 10 seconds
![Select the GPIO Pins your relays are connected to](https://github.com/ReinierNel/relayctl/blob/main/docs/5.PNG?raw=true)
#### 6. The next step will run a test to check if all your relays are working
![run a test](https://github.com/ReinierNel/relayctl/blob/main/docs/6.PNG?raw=true)
#### 7. End of installation wizard
![End](https://github.com/ReinierNel/relayctl/blob/main/docs/7.PNG?raw=true)

## Update Schedule

Edit the following file /etc/relayctl/schedule.list 

Add an ```#``` in front of a schedule to disable it.

To add a new schedule add a new line to the file and enter the following details separated by ```|```

|**schedule name**|**start time**|**end time**|**day of week**|**month**|**relay_index**|**on cmd**|**off cmd**|
|-----------------|--------------|------------|---------------|---------|---------------|----------|-----------|
|Geyser1|10:25:00|11:45:00|1 2 3 4 5 6 7|01 02 03 04 05 06 07 08 09 10 11 12|0|/etc/relayctl/relayctl.sh -r=0 on|/etc/relayctl/relayctl.sh -r=0 off
|Geyser2|15:00:00|16:30:00|1 2 3 4 5 6 7|01 02 03 04 05 06 07 08 09 10 11 12|1|/etc/relayctl/relayctl.sh -r=1 on|/etc/relayctl/relayctl.sh -r=1 off

### schedule name

Name of your schedule, will show up in the logs

### start time

Time to execute commands listed in **on cmd** section based on frequency set during the installation process

### end time

Time to execute commands listed in **off cmd** section based on frequency set during the installation process

### day of week

The day of the week to execute on e.g. 1 = Monday, 2 = Tuesday etc.

### month

The month to execute on e.g. 01 = January 02 = February, etc.

> ⚠️ Note that month when in the single digets needs to be set with a 0 infront 01 for Jan 02 for Feb 03 March etc,

### relay_index

Position of Relay e.g. 0 = Relay Connected to GPIO pin 22. etc.

### on cmd

Command to execute when the start time, day of week and month conditions are met 

### off cmd

Command to execute when start time, day of week and month conditions are not met

## Setup enxternal switches

External switches are used to put on or off a relay if the switch state is open or closed

Edit the following file /etc/relayctl/inputs.list to map switches to relays

|**name**|**input index**|**relay index**|**mode**|**cmd**|
|---|---|---|---|---|
|jojo 2400L ball valve|0|0|on|echo "hello world"|

### name

The name of the index mapping, arbitrary string to will appear in log files

### input index

The index of the input as set in ```settings.sh``` under variable ```inputs_gpio=()``` for instance if ```inputs_gpio=(5 6)``` 5 would be index 0 and 6 will be index 1

## relay index

The index of the relay as set in ```settings.sh``` under variable ```relays=()``` for instance if ```relays=(17 18)``` 17 would be index 0 and 18 would be index 1

The input index is mapped to the relay index.

## mode

Action to perform when external input is closed open.

mode **on** will switch on a relay if the external input is closed
mode **off** will switch off an relay if the external input is closed
mode **cmd** will run a command if the external input is closed and the cmd field is populated with a command

## cmd

This runs a command set under the cmd field if the external input is closed

> :warning: WIll only run if mode is set to cmd

## Running Manual Relay Actions

> :warning: if there is a schedule running or an external switch mapped thats on, this will overwrite your manual action

See below commands

```bash
/etc/relayctl/relayctl.sh test
/etc/relayctl/relayctl.sh status
/etc/relayctl/relayctl.sh -r={enter relay index here} {on or off}
```

## Manual Install

Install git

```bash
sudo apt update; sudo apt install git -y
```

clone the repo to the /etc/relayctl directory

```bash
cd /etc
sudo git clone https://github.com/ReinierNel/relayctl.git
```

Update the ```settings.sh``` file and replace ```__OUT_GPIO_PIN__``` in variable ```relays=()``` with the GPIO numbers where your relays are connected to.

Example 

```bash
# update this
relays=(__OUT_GPIO_PIN__)
# to this
relays=(17 18 22 16)
```

Update the ```settings.sh``` file and replace ```__IN_GPIO_PIN__``` in variable ```inputs_gpio=()``` with the GPIO numbers where your external switches are connected to.

Example 

```bash
# update this
inputs_gpio=(__IN_GPIO_PIN__)
# to this
inputs_gpio=(5 6 32 13)
``` 

Update the ```settings.sh``` file and replace ```__SCHEDULAR_FREQUEMCY__``` in variable ```scheduler_frequency=””``` with an integer representing seconds witch the scheduler will wait before retrying.

Example

```bash
# update this
scheduler_frequency="__SCHEDULAR_FREQUEMCY__"
# to this
scheduler_frequency="10"
```

Finally update the file ```/etc/rc.local``` and add the following before the ```exit 0```

```bash
sudo /etc/relayctl/relayctl.sh test
sudo /etc/relayctl/scheduler.sh &
sudo /etc/relayctl/external.sh &
```

example 

```bash
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

# ADD HERE
sudo /etc/relayctl/relayctl.sh test
sudo /etc/relayctl/scheduler.sh &
sudo /etc/relayctl/external.sh &
# BEFORE exit 0
exit 0

```

Once done reboot your pi, update your schedule.list and inputs.list files to set schedules and external inputs mapping
