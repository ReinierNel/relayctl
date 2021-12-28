#!/bin/bash

tui_h=20
tui_w=75
tui_t=4

#declate -a download_urls=(
#       "https://"
#)

function check_exit_status() {
        if [ ! "$exitstatus" = 0 ]
        then
                echo "[warn] user canceled!"
                exit 1
        fi
}

# relays connected?

read -r -d '' welcome_msg <<'EOF'
This wizard will help you set up your relays on your Pi.

Have you connected your relays to the Pi?.
EOF

relays_connected=$(whiptail --title "Setup Relayctl" --yesno "$welcome_msg" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# select gpio

read -r -d '' gpio_select_msg <<'EOF'
Select which GPIO pins your relays control circuit are connected to.
https://www.raspberrypi.com/documentation/computers/os.html#gpio-pin

      GPIO PIN
EOF

gpio_select=$(whiptail --title "Setup Relayctl" --checklist \
"$gpio_select_msg" "$tui_h" "$tui_w" "$tui_t" \
"22" "PIN 15" OFF \
"23" "PIN 16" OFF \
"24" "PIN 18" OFF \
"25" "PIN 22" OFF \
3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# set scheduler frequency

read -r -d '' schedule_msg1 <<'EOF'
Enter a value in seconds how often should the scheduler check
if a relay sould be on or off recommended 10 seconds
EOF

schedule_frequency=$(whiptail --title "Setup Relayctl" --inputbox "$schedule_msg1" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

echo ${gpio_select[@]}
echo $schedule_frequency
