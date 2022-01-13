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
	["inputs.list"]="https://raw.githubusercontent.com/ReinierNel/relayctl/main/inputs.list"
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
██████╗ ███████╗██╗      █████╗ ██╗   ██╗ ██████╗████████╗██╗
██╔══██╗██╔════╝██║     ██╔══██╗╚██╗ ██╔╝██╔════╝╚══██╔══╝██║
██████╔╝█████╗  ██║     ███████║ ╚████╔╝ ██║        ██║   ██║
██╔══██╗██╔══╝  ██║     ██╔══██║  ╚██╔╝  ██║        ██║   ██║
██║  ██║███████╗███████╗██║  ██║   ██║   ╚██████╗   ██║   ███████╗
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝   ╚═╝   ╚══════╝

This wizard will help you set up your relays on your Pi.

Have you connected your relays to the Pi?. If not connect them now and hit OK.
EOF

relays_connected=$(whiptail --title "Setup Relayctl" --yesno "$welcome_msg" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# select relay gpio
read -r -d '' gpio_select_msg <<'EOF'
Select which GPIO pins your relays control circuit are connected to.

Goto for GPIO pin layout and numbering.
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

Goto for GPIO pin layout and numbering.
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
if a relay sould be on or off recommended 10 seconds.

A lower value will increase CPU load and also make the log files
grow faster.
EOF

schedule_frequency=$(whiptail --title "Setup Relayctl" --inputbox "$schedule_msg1" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3)

exitstatus=$?

check_exit_status

# setup folders
mkdir /etc/relayctl
chown root:gpio /etc/relayctl
chmod 775 /etc/relayctl
# download needed files
dl_count=${#download_urls[@]}
dl_loading_bar_cunks=$((100 / 8))
dl_loading_bar=0

{
        for dl_item in ${!download_urls[@]}
        do
                dl_loading_bar=$(($dl_loading_bar + $dl_loading_bar_cunks))
                echo "$dl_loading_bar"
                curl --silent "${download_urls[$dl_item]}" --output "/etc/relayctl/$dl_item"
                chmod +x "/etc/relayctl/$dl_item"
		chown root:gpio "/etc/relayctl/$dl_item"
                dl_loading_bar=$(($dl_loading_bar + $dl_loading_bar_cunks))
        done
} | whiptail --gauge "Downloading files from Github..." 6 50 0

chmod 775 /etc/relayctl/schedule.list
chmod 775 /etc/relayctl/inputs.list
chmod -x /etc/relayctl/LICENSE

# update settings.sh
sed -i "s/__OUT_GPIO_PIN__/${gpio_select[@]}/g" /etc/relayctl/settings.sh
sed -i "s/__IN_GPIO_PIN__/${input_gpio_select[@]}/g" /etc/relayctl/settings.sh
sed -i "s/__SCHEDULAR_FREQUEMCY__/$schedule_frequency/g" /etc/relayctl/settings.sh

# testing relays
read -r -d '' test_msg <<'EOF'
We are running a test agains the relays to check if everting is conencted and woring.

You should hear your relays clicking on and off one at a time.

see /etc/relayctl.log for more details.

Press OK to continue with the test
EOF
whiptail --title "Setup Relayctl" --msgbox "$test_msg" "$tui_h" "$tui_w"
/etc/relayctl/relayctl.sh test

# update rc.local
cat > /tmp/rc.local <<EOF
$(head -n -1 /etc/rc.local)

/etc/relayctl/relayctl.sh test
/etc/relayctl/scheduler.sh &
/etc/relayctl/external.sh &

exit 0
EOF

rm -f /etc/rc.local
mv /tmp/rc.local /etc/rc.local
chmod 755 /etc/rc.local

# ask sould we setup an API or not
read -r -d '' api_msg <<'EOF'
Sould we enable the the REST API required by UniPi

!NOTE! your API key will be show only once on the next screen.
API key can not be retrieved once setup is done, so copy it
and store it in a safe place before ending the setup.

The following software will be install

* nginx    - Web server that can also be used as a reverse proxy...
* fcgiwrap - Simple FastCGI wrapper for CGI scripts
* jq       - jq is like sed for JSON data

Select Yes to install or No to continue without installing
EOF

licence_agreement=$(whiptail --title "Setup Relayctl" --yesno "$api_msg" 40 75 3>&1 1>&2 2>&3)

exitstatus=$?

if [ "$exitstatus" = 0 ]
then
	apt-get update
	apt-get upgrade -y
	apt-get install -y nginx fcgiwrap jq

	usermod -a -G gpio www-data
	mkdir -p /usr/lib/cgi-bin

	curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/main/api/cgi-bin/api.cgi" --output "/usr/lib/cgi-bin/api.cgi"
	chown www-data:gpio /usr/lib/cgi-bin/api.cgi
	chmod +x /usr/lib/cgi-bin/api.cgi
	rm -f /etc/nginx/sites-available/default
	curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/main/api/nginx/default" --output "/etc/nginx/sites-available/default"
	curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/main/api/nginx/fastcgi_params" --output "/etc/nginx/fastcgi_params"
	curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/main/api-key.sh" --output "/etc/relayctl/api-key.sh"
	chmod 600 /etc/relayctl/api-key.sh
	chown root:root /etc/relayctl/api-key.sh
	cp /usr/share/doc/fcgiwrap/examples/nginx.conf /etc/nginx/fcgiwrap.conf
	sed -i "s/user www-data/user root/g" /etc/nginx/nginx.conf
	service nginx restart
	api_key=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/urandom)
	openssl passwd -6 -salt $(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '') -stdin -noverify <<< $(echo $api_key) >> /etc/relayctl/api.key
	chown root:gpio /etc/relayctl/api.key
fi

# good bye
read -r -d '' bye_msg << EOF
The Instilation complete.

+---------------------+----------------------------+
| File / Folder Name  | Path                       |
+---------------------+----------------------------+
| Installed Directory | /etc/relayctl/             |
| relayctl            | /etc/relayctl/relayctl.sh  |
| Schedule File       | /etc/relayct/schedule.list |
| Switches File       | /etc/relayct/inputs.list   |
+---------------------+----------------------------+

Pleaes copy the API Key and store in a safe place.

API key: "$api_key"

for more info goto https://github.com/ReinierNel/relayctl#readme

Your Pi will now reboot

Press OK to reboot
EOF
whiptail --title "Setup Relayctl" --msgbox "$bye_msg" "$tui_h" "$tui_w"
reboot
