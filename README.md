# relayctl
Simple bash scripts to control relays connected to your raspberry pi with a cron like scheduler to switch ac appliances on or off based on time of day of week and month.

## Install

Before you install make sure you have a fresh copy of rasbian cloned to an sd card, your realys conencted to GPIO Pins 22, 23. 24 or 25 *WILL ADD MORE PIN OPTIONS LATER*

Now Boot the Pi with the SD card once booted run the following command.

```bash
curl -s https://raw.githubusercontent.com/ReinierNel/relayctl/main/setup.sh | sudo bash
```

This will lauch an interactive installer, follow the proments.

|:warning:|Instructions incompliete will update later|
|---|---|
