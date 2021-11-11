#! /bin/bash

[ $(pgrep -c lemonbar) -gt 1 ] && pkill -o lemonbar.sh
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

Clock(){
	TIME=$(date "+%H:%M:%S")
	echo -ne "\uf017 ${TIME}"
}

Date(){
	DATE=$(date "+%d.%m.%y")
	echo -ne "\uf073 ${DATE}"
}

Battery() {
	BATTACPI=$(acpi --battery)
	BATPERC=$(echo $BATTACPI | cut -d, -f2 | tr -d '[:space:]')

	if [[ $BATTACPI == *"100%"* ]]
	then
		echo -e -n "\uf00c $BATPERC"
	elif [[ $BATTACPI == *"Discharging"* ]]
	then
		BATPERC=${BATPERC::-1}
		if [ $BATPERC -le "10" ]
		then
			echo -e -n "\uf244"
		elif [ $BATPERC -le "25" ]
		then
			echo -e -n "\uf243"
		elif [ $BATPERC -le "50" ]
		then
			echo -e -n "\uf242"
		elif [ $BATPERC -le "75" ]
		then
			echo -e -n "\uf241"
		elif [ $BATPERC -le "100" ]
		then
			echo -e -n "\uf240"
		fi
		echo -e " $BATPERC%"
	elif [[ $BATTACPI == *"Charging"* && $BATTACPI != *"100%"* ]]
	then
		echo -e "\uf0e7 $BATPERC"
	elif [[ $BATTACPI == *"Unknown"* ]]
	then
		echo -e "$BATPERC"
	fi
}

Desktops(){
	dtLine=$(bspc subscribe -c 1|sed 's/\(.*\):L.*/\1/g'|perl -pe 's/(.*?:)//')
	IFS=':' read -r -a dtArray <<< $dtLine

	dtAll=${#dtArray[@]}

	for ind in ${!dtArray[@]}; do
		tmpString=${dtArray[ind]}
		firstSymbol=${tmpString:0:1}
		[[ $firstSymbol =~ [[:upper:]] ]] && dtCurrent=$(($ind+1)) && break
	done

	echo -e "\uf108 ${dtCurrent}/$dtAll"
}

ActiveWindow(){
	longLine=$(xdotool getwindowfocus getwindowname)
	if [[ ${#longLine} -gt 40 ]]; then
		shortLine=${longLine:0:40}
		echo -n "%{F#ffffff}$shortLine%{F#000000}.."
	else
		echo -n "%{F#ffffff}$longLine"
	fi
}

CPU(){
	CPU_usage=$(ps -eo pcpu | awk 'BEGIN {sum=0.0f} {sum+=$1} END {print sum}')
	CPU_rounded=$(bc -l $XDG_CONFIG_HOME/lemonbar/scale0.b <<< "(${CPU_usage}+0.5)/1")
	echo -e "\uf2db ${CPU_rounded}%"
}

Temperature(){
	read -d '\n' c0 c1 <<< $(sensors|sed -n '4,5p'|awk '{print $3}'|sed -E 's/^.//g;s/..(..)$/\1/g')
	echo -e "\uf2c9 $c0 $c1"
}

HDD(){
	USED_SPACE=$(df -h|sed -n '/cryptroot/p'|awk '{print $3}'|sed 's/.$//g')
	# ALL_SPACE=$(df -h|sed -n '/cryptroot/p'|awk '{print $2}'|sed 's/.$//g')
	echo -en "\uf0a0 ${USED_SPACE}G"
}

RAM(){
	read -d '\n' t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo |awk '{print $2}'`
	read -d '\n' b c <<< `grep -E '^(Buffers|Cached)' /proc/meminfo |awk '{print $2}'`
	RAM_usage=$(bc -l $XDG_CONFIG_HOME/lemonbar/scale2.b <<< "($t-$f-$c-$b)/1000000" | awk '{printf "%.1f", $0}')
	RAM_total=$(bc -l $XDG_CONFIG_HOME/lemonbar/scale2.b <<< "$t/1000000")
	echo -e "\uf538 ${RAM_usage}/${RAM_total}G"
}

SWAP(){
	read -d '\n' sc st sf <<< `grep -E 'Swap' /proc/meminfo |awk '{print $2}'`
	SWAP_usage=$(bc -l $XDG_CONFIG_HOME/lemonbar/scale2.b <<< "($st-$sf-$sc)/1000000")
	SWAP_total=$(bc -l $XDG_CONFIG_HOME/lemonbar/scale2.b <<< "$st/1000000")
	echo -e "\uf7c2 ${SWAP_usage}/${SWAP_total}G"
}


Sound(){
#	NOTMUTED=$( amixer sget Master | grep "\[on\]" )
#	if [[ ! -z $NOTMUTED ]] ; then
#		VOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master) | sed 's/%//g')
#		if [ $VOL -ge 85 ] ; then
#			echo -e "\uf028 ${VOL}%"
#		elif [ $VOL -ge 50 ] ; then
#			echo -e "\uf027 ${VOL}%"
#		else
#			echo -e "\uf026 ${VOL}%"
#		fi
#	else
#		echo -e "\uf026 M"
#	fi

	VOL=$(pamixer --get-volume-human)

	if [[ ! $VOL == 'muted'  ]]; then
		VOL=$(echo $VOL | sed 's/%//g')
		if [ $VOL -ge 85 ] ; then
			echo -e "\uf028 ${VOL}%"
		elif [ $VOL -ge 50 ] ; then
			echo -e "\uf027 ${VOL}%"
		else
			echo -e "\uf026 ${VOL}%"
		fi
	else
		echo -e "\uf026 M"
	fi

}

Wifi(){
	WIFISTR=$(cat /proc/net/wireless | sed -n '3p' | grep -o '\s\+[[:digit:]]\+\.\s\+' | sed 's/[^[:digit:]]//g')
	if [ ! -z $WIFISTR ] ; then
		WIFISTR=$((${WIFISTR} * 100 / 70))
		ESSID=$(iw dev wlan0 link | grep 'SSID' | sed 's/SSID: //g; s/[^[:graph:]]//g')

		# OUTIP=$(wget --timeout=2 --tries=2 https://duckduckgo.com/\?q\=whats+my+ip -q -O - | grep  -Eo '[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}')

		if [[ $WIFISTR -ge 1 && $WIFISTR -lt 70 ]] ; then
			echo -e "${WIFISTR}% $(Network)"
		elif [ $WIFISTR -ge 1 ] ; then
			echo -e "\uf1eb $(Network)"
		fi
	fi
}

Network(){
     s=$(ip addr|awk '/state UP/ {print $2}'|sed -n '1p')
     INTERFACE=$(echo -n ${s:0:-1})
     R1=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
     T1=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
     sleep 1
     R2=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
     T2=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
     RBPS=`expr $R2 - $R1`
     TBPS=`expr $T2 - $T1`
     RKBPS=$(bc -l <<< "($RBPS)*8/1000" | awk '{printf "%.0f", $0}')
     TKBPS=$(bc -l <<< "($TBPS)*8/1000" | awk '{printf "%.0f", $0}')
     line="      "
     echo -en "%{F#66ffcc}\uf0ab$(printf "%s%s" "${line:${#RKBPS}}" "$RKBPS") %{F#db4dff}\uf0aa$(printf "%s%s" "${line:${#TKBPS}}" "$TKBPS") %{F#99ebff}kbit/s"
}

Language(){
	CURRENTLANG=$(xset -q|grep LED| awk '{ print $10 }'|sed 's/....\(.\).../\1/')
	if [[ $CURRENTLANG == '0' ]] ; then
		echo -e "\uf0ac ENG"
	elif [[ $CURRENTLANG == '1' ]] ; then
		echo -e "\uf0ac RUS"
	else
		echo -e "\uf0ac \uf128"
	fi
}

while true; do
	echo -n " %{F#990000}$(Battery) %{F#002db3}$(HDD) %{F#004d00}$(RAM) $(SWAP) %{F#660066}$(CPU) %{F#990000}$(Temperature)%{F-}%{c}$(ActiveWindow)%{r}%{F#99ebff}$(Wifi) %{F#660066}$(Sound) %{F#ffff99}$(Language) %{F#ffffff}$(Clock)%{F-} " 
	sleep 0.2s
done > "$PANEL_FIFO" &

raw_string=$(xdpyinfo  | grep 'dimensions:')
raw_array=($raw_string)
dimensions=${raw_array[1]}
monitor_width=$(echo $dimensions | cut -d'x' -f1)

cat "$PANEL_FIFO" | lemonbar -B "#93b4cd" -F "#213045" -g "${monitor_width}x40" \
-f "xos4 Terminus:Bold:size=18" \
-f "Font Awesome 5 Free:style=Regular:size=16" \
-f "Font Awesome 5 Free:style=Solid:size=16" \
-f "Font Awesome 5 Brands:size=16" &
