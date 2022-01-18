#!/bin/bash

# check if root
if [ "$(whoami)" != "root" ]
then
        echo "[error] you must be root or run using sudo $0"
        exit 1
fi

tui_h=20
tui_w=75
tui_t=6

# handel script arguments
for arg in "$@"
do
        case "$arg" in
                --test|-t)
                        test="true"
                ;;
                --silent|-s)
                        silent="true"
                ;;
        esac

done


# gitlab repo base url to download raw files
download_url="https://raw.githubusercontent.com/ReinierNel/relayctl"

# files in repo to download later
declare -a download_files=(
        "LICENSE"
        "functions.sh"
        "relayctl.sh"
        "schedule.list"
        "scheduler.sh"
        "settings.sh"
	"external.sh"
	"inputs.list"
        "api-key.sh"
)

# check if status is 0 else exit 1
function check_exit_status() {
        if [ ! "$1" = "0" ]
        then
                echo "[warn] user canceled. on $2"
                exit 1
        fi
}

# fetch branches on github repo
function fetch-branches() {
        #get_branches=($(curl --silent https://api.github.com/repos/reiniernel/relayctl/branches | jq .[]."name"))
        
        mapfile -t get_branches < <(curl --silent https://api.github.com/repos/reiniernel/relayctl/branches | jq -r .[]."name")

        branches=()
        for branch in "${get_branches[@]}"
        do
                branches+=("$branch")
                branches+=("")
        done
}

# download files
function download_files() {
        # setup folders
        mkdir /etc/relayctl

        # download needed files
        dl_count="${#download_url[@]}"
        dl_loading_bar_cunks=$((100 / dl_count))
        dl_loading_bar=0

        {
                for dl_item in "${download_files[@]}"
                do
                        dl_loading_bar=$((dl_loading_bar + dl_loading_bar_cunks))
                        echo "$dl_loading_bar"
                        curl --silent "$download_url/$1/$dl_item" --output "/etc/relayctl/$dl_item"
                        chmod +x "/etc/relayctl/$dl_item"
                        chown root:gpio "/etc/relayctl/$dl_item"
                        dl_loading_bar=$((dl_loading_bar + dl_loading_bar_cunks))
                done
        } | whiptail --gauge "Downloading files from Github..." 6 50 0
}

# update file prems and settings files
function update_files() {
        chown -R root:gpio /etc/relayctl
        chmod 775 /etc/relayctl

        chmod 775 /etc/relayctl/schedule.list
        chmod 775 /etc/relayctl/inputs.list
        chmod -x /etc/relayctl/LICENSE

        # update settings.sh
        #sed -i "s/__OUT_GPIO_PIN__/${gpio_select[*]}/g" /etc/relayctl/settings.sh
        #sed -i "s/__IN_GPIO_PIN__/${input_gpio_select[*]}/g" /etc/relayctl/settings.sh
        sed -i "s/__OUT_GPIO_PIN__/$1/g" /etc/relayctl/settings.sh
        sed -i "s/__IN_GPIO_PIN__/$2/g" /etc/relayctl/settings.sh
}

# update rc.local
function update_rc_local() {
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
}

# install api
function install_api() {
        if [ "$?" = "0" ]
        then
                # API setup
                apt-get update
                apt-get upgrade -y
                apt-get install -y nginx fcgiwrap jq
                usermod -a -G gpio www-data
                mkdir -p /usr/lib/cgi-bin
                curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/$1/api/cgi-bin/api.cgi" --output "/usr/lib/cgi-bin/api.cgi"
                chown www-data:gpio /usr/lib/cgi-bin/api.cgi
                chmod +x /usr/lib/cgi-bin/api.cgi
                rm -f /etc/nginx/sites-available/default
                curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/$1/api/nginx/default" --output "/etc/nginx/sites-available/default"
                curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/$1/api/nginx/fastcgi_params" --output "/etc/nginx/fastcgi_params"
                curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/$1/api-key.sh" --output "/etc/relayctl/api-key.sh"
                chmod 600 /etc/relayctl/api-key.sh
                chown root:root /etc/relayctl/api-key.sh
                cp /usr/share/doc/fcgiwrap/examples/nginx.conf /etc/nginx/fcgiwrap.conf
                sed -i "s/user www-data/user root/g" /etc/nginx/nginx.conf
                service nginx restart
                api_key=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/urandom)
                openssl passwd -6 -salt "$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')" -stdin -noverify <<< "$api_key" >> /etc/relayctl/api.key
                chown root:gpio /etc/relayctl/api.key
                # web UI setup
                curl --silent "https://raw.githubusercontent.com/ReinierNel/relayctl/$1/web-ui/index-wireframe.html" --output "/var/www/html/index.html"
        fi
}

# install everting scip whiptail
if [ "$silent" = "true" ]
then
        download_files "main"
        update_files "17 18 27 22 23 24" "25 5 6 12 13 26"
        update_rc_local
        install_api "main"
        exit 0
fi


# ask use to install jq if not already presint
read -r -d '' info_msg <<'EOF'
This installer needs the program jq to work. For more information about jq please visit https://stedolan.github.io/jq/

Can we go ahead and install jq onto this Pi?

Select “Yes” to continue or “No” to cancel
EOF

if ! command -v jq &> /dev/null
then
        whiptail --title "Setup Relayctl" --yesno "$info_msg" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3

        check_exit_status "$?" "Install jq?"

        apt update
        apt install -y jq
fi

# selec install branch
read -r -d '' select_branch_msg <<'EOF'
Select from witch github branch to install from, For stable releases select main
EOF

fetch-branches
branch_selected=$(whiptail --title "Setup Relayctl" --menu "$select_branch_msg" "$tui_h" "$tui_w" "$tui_t" "${branches[@]}" 3>&1 1>&2 2>&3)

check_exit_status "$?" "Select Branch"


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

whiptail --title "Setup Relayctl" --yesno "$licence_msg" 40 75 3>&1 1>&2 2>&3

check_exit_status "$?"

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

whiptail --title "Setup Relayctl" --yesno "$welcome_msg" "$tui_h" "$tui_w" 3>&1 1>&2 2>&3

check_exit_status "$?" "Inro"

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

check_exit_status "$?" "Relay GPIO Select"

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

check_exit_status "$?" "Switches GPIO Select"

if [ "$test" = "false" ]
then

        download_files "$branch_selected"
        update_files "${gpio_select[*]}" "${input_gpio_select[*]}"
        update_rc_local
fi

# testing relays
read -r -d '' test_msg <<'EOF'
We are running a test agains the relays to check if everting is conencted and woring.

You should hear your relays clicking on and off one at a time.

see /etc/relayctl.log for more details.

Press OK to continue with the test
EOF
whiptail --title "Setup Relayctl" --msgbox "$test_msg" "$tui_h" "$tui_w"
/etc/relayctl/relayctl.sh test

# ask sould we setup an API or not
read -r -d '' api_msg <<'EOF'
Sould we enable the the REST API and enable a web interface.

!NOTE! your API key will be show only once on the next screen.
API key can not be retrieved once setup is done, so copy it
and store it in a safe place before ending the setup.

The following software will be install

* nginx    - Web server that can also be used as a reverse proxy...
* fcgiwrap - Simple FastCGI wrapper for CGI scripts
* jq       - jq is like sed for JSON data

Select Yes to install or No to continue without installing
EOF

install_api=$(whiptail --title "Setup Relayctl" --yesno "$api_msg" 40 75 3>&1 1>&2 2>&3)

if [ "$test" = "false" ]
then
        install_api "$branch_selected"
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

Web Interface: http://$(hostname -I | awk '{ print $1 }')/

For more info goto https://github.com/ReinierNel/relayctl/wiki

Your Pi will now reboot

Press OK to reboot
EOF

whiptail --title "Setup Relayctl" --msgbox "$bye_msg" "$tui_h" "$tui_w"

if [ "$test" = "false" ]
then
        reboot
else
        read -r -d '' test_report << EOF
Testing Report

${!testing@} = $testing
${!branch_selected@} = $branch_selected
${!gpio_select@} = ${gpio_select[@]}
${!input_gpio_select@} = ${input_gpio_select[@]}
${!install_api@} = $install_api
EOF

        whiptail --title "Setup Relayctl" --msgbox "$test_report" "$tui_h" "$tui_w"

fi