#!/bin/bash

if [ "$(whoami)" != "root" ]
then
        echo "[error] you must be root or run using sudo $0"
        exit 1
fi

tui_h=20
tui_w=75
tui_t=6

declare -A download_urls=(
        ["LICENSE"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/LICENSE"
        ["functions.sh"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/functions.sh"
        ["relayctl.sh"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/relayctl.sh"
        ["schedule.list"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/schedule.list"
        ["scheduler.sh"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/scheduler.sh"
        ["settings.sh"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/settings.sh"
	["external.sh"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/external.sh"
	["inputs.list"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/external.sh"
)

function check_exit_status() {
        if [ ! "$exitstatus" = 0 ]
        then
                echo "[warn] user canceled!"
                exit 1
        fi
}

# licence agreement

read -r -d '' licence_msg <<'EOF'
MIT License

Copyright (c) 2021 ReinierNel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Do you Agree?
EOF

licence_agreement=$(whiptail --title "Setup Relayctl" --yesno "$licence_msg" 40 75 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# relays connected?

read -r -d '' welcome_msg <<'EOF'
This wizard will help you set up your relays on your Pi.

Have you connected your relays to the Pi?.
EOF

relays_connected=$(whiptail --title "Setup Relayctl" --yesno "$welcome_msg" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# select relay gpio

read -r -d '' gpio_select_msg <<'EOF'
Select which GPIO pins your relays control circuit are connected to.
https://www.raspberrypi.com/documentation/computers/os.html#gpio-pin

      GPIO PIN
EOF

gpio_select=$(whiptail --title "Setup Relayctl" --checklist \
"$gpio_select_msg" "$tui_h" "$tui_w" "$tui_t" \
"17" "PIN 11" OFF \
"18" "PIN 12" OFF \
"27" "PIN 13" OFF \
"22" "PIN 15" OFF \
"23" "PIN 16" OFF \
"24" "PIN 18" OFF \
3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# select inputs gpio

read -r -d '' input_gpio_select_msg <<'EOF'
Select which GPIO pins your external swicthes are connected to.
https://www.raspberrypi.com/documentation/computers/os.html#gpio-pin

      GPIO PIN
EOF

input_gpio_select=$(whiptail --title "Setup Relayctl" --checklist \
"$input_gpio_select_msg" "$tui_h" "$tui_w" "$tui_t" \
"25" "PIN 22" OFF \
"5 " "PIN 29" OFF \
"6 " "PIN 31" OFF \
"12" "PIN 32" OFF \
"13" "PIN 33" OFF \
"26" "PIN 37" OFF \
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

# setup folders
mkdir /etc/relayctl

# download needed files
dl_count=${#download_urls[@]}
dl_loading_bar_cunks=$((100 / 6))
dl_loading_bar=0

{
        for dl_item in ${!download_urls[@]}
        do
                dl_loading_bar=$(($dl_loading_bar + $dl_loading_bar_cunks))
                echo "$dl_loading_bar"
                curl --silent "${download_urls[$dl_item]}" --output "/etc/relayctl/$dl_item"
                chmod +x "/etc/relayctl/$dl_item"
                dl_loading_bar=$(($dl_loading_bar + $dl_loading_bar_cunks))
        done
} | whiptail --gauge "Downloading files from Github..." 6 50 0

chmod -x /etc/relayctl/schedule.list
chmod -x /etc/relayctl/LICENSE

# update settings.sh

sed -i "s/__OUT_GPIO_PIN__/${gpio_select[@]}/g" /etc/relayctl/settings.sh
sed -i "s/__IN_GPIO_PIN__/${input_gpio_select[@]}/g" /etc/relayctl/settings.sh
sed -i "s/__SCHEDULAR_FREQUEMCY__/$schedule_frequency/g" /etc/relayctl/settings.sh

# testing relays
read -r -d '' test_msg <<'EOF'
We are running a test agains the relays to check if everting is conencted and woring.

You should hear your relays clicking on and off

see /etc/relayctl.log for more details

Press OK to continue with the test
EOF
whiptail --title "Setup Relayctl" --msgbox "$test_msg" "$tui_h" "$tui_w"
/etc/relayctl/relayctl.sh test

# update rc.local
cat > /tmp/rc.local <<EOF
$(head -n -1 /etc/rc.local)

sudo /etc/relayctl/relayctl.sh test
sudo /etc/relayctl/scheduler.sh &
sudo /etc/relayctl/external.sh &

exit 0
EOF

rm -f /etc/rc.local
mv /tmp/rc.local /etc/rc.local
chmod 755 /etc/rc.local

# good bye
read -r -d '' bye_msg <<'EOF'
The Instilation was sucessfull...

relayctl installed @ /etc/relayctl

update your schedule @ /etc/relayct/schedule.list

for more info goto https://github.com/ReinierNel/relayctl#readme

Press OK to continue
EOF
whiptail --title "Setup Relayctl" --msgbox "$bye_msg" "$tui_h" "$tui_w"
clear
