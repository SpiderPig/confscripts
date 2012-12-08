#!/bin/bash

#Layout
BAR_H=8
PIE_H=14
BIGBAR_W=60
SMABAR_W=30
HEIGHT=17

X_POS=0
Y_POS=0

#NUM_SCRNS=$(xdpyinfo |grep 'number of screens'|awk '{print $4}')
XRES=$(xdpyinfo |grep 'dimensions:'|perl -pe 's/\s*\S*\s*(\d*)x.*/\1/')
if [ $XRES -gt 2400 ]; then
  NUM_SCRNS=2
else
  NUM_SCRNS=1
fi
DZEN_WIDTH=$(($XRES/$NUM_SCRNS))

CLOCKPOS=$((DZEN_WIDTH-180))


#Look and feel
CRIT="#d74b73"
COLOR_WRN="#d8de91"
BAR_FG="#63a5b3"
BAR_BG="#3f6a73"
DZEN_FG="#adadad"
DZEN_FG2="#7f757b"

DZEN_BG="#050505"
COLOR_ICON="#adadad"
ICONPATH="$HOME/.icons/dzen-xbm"
#COLOR_SEP="#007b8c"
COLOR_SEP="#63a5b3"
FONT="xft:Clean:style=bold:size=9:antialias=true"
#-*-clean-bold-r-normal-*-12-*-*-*-*-*-*-*

#Options
IFS='|' #internal field separator (conky)
CONKYFILE="~/.conkyrc"
INTERVAL=1
CPUTemp=0
GPUTemp=0
HDDTemp=0
CPULoad0=0
CPULoad1=0
CPULoad2=0
CPULoad3=0
NetUp=0
NetDown=0
TopProc=""

MAILTICK=0;
HAVEMAIL="false"


printVolInfo() {
	Perc=$(amixer get Master|perl -pe 's/.*: Playback \d+ \[(\d+)%\].*/\1/; if ($_ > $g){$g = $_;} $_=$g;'|tail -1)
	Mute=$(amixer get Master|perl -pe 's/.* \[(o[nf]f?)\]/\1/'|tail -1)
	if [[ $Mute == "off" ]]; then
                echo -n "^ca(1, amixer sset Master toggle)"
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/sound_mute.xbm) "
		echo -n "^fg()${Perc}% "
		echo -n "$(echo $Perc | gdbar -fg \#404040 -bg \#202020 -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
#		echo -n "^fg()mute "
                echo -n "^ca()"
	else
                echo -n "^ca(1, amixer sset Master toggle)"
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/sound_high.xbm) "
#		echo -n "^fg()^i($ICONPATH/sound_high.xbm) "
		echo -n "^fg()${Perc}% "
		echo -n "$(echo $Perc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
                echo -n "^ca()"
	fi
	return
}

printCPUInfo() {
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/cpu.xbm) "
	echo -n "$(echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -ss 1 -sw 2 -nonl) "
	echo -n "$(echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -ss 1 -sw 2 -nonl) "
        echo -n "$(echo $CPULoad2 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -ss 1 -sw 2 -nonl) "
        echo -n "$(echo $CPULoad3 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -ss 1 -sw 2 -nonl) "
	echo -n "${CPUFreq}GHz"
	return
}

printTempInfo() {
#	CPUTemp=$(acpi --thermal | awk '{print substr($4,0,2)}')
	CPUTemp=$((sensors || echo 'CPU Temperature:+0.0')|grep 'CPU Temperature'|perl -pe 's/.*:\s*[+-]([0-9]*).*/\1/')
    if [[ -e /usr/bin/nvidia-settings ]]; then
      GPUTemp=$(nvidia-settings -q gpucoretemp | grep 'Attribute' | awk '{print $4}' | tr -d '.')
    else
      GPUTemp=0
    fi
	HDDTemp=$(env -u DISPLAY hddtemp -q /dev/sd?|perl -pe 's/.*not available//; s/.*:.*:\s+(\d+).*/\1/;  if ($_ > $g){$g = $_;} $_=$g;'|tail -1)

	HOT=`echo "$CPUTemp > 70" | bc`
	if [[ $HOT -eq "1" ]]; then
		CPUTemp="^fg($CRIT)$CPUTemp^fg()"
	fi

	HOT=`echo "$GPUTemp > 70" | bc`
	if [[ $HOT -eq "1" ]]; then
		GPUTemp="^fg($CRIT)$GPUTemp^fg()"
	fi

	HOT=`echo "$HDDTemp > 40" | bc`
	if [[ $HOT -eq "1" ]]; then
		HDDTemp="^fg($CRIT)$HDDTemp^fg()"
	fi

	echo -n "^fg($COLOR_ICON)^i($ICONPATH/temp.xbm)"
	echo -n "^fg($DZEN_FG2)cpu ^fg()${CPUTemp}°c  "
	echo -n "^fg($DZEN_FG2)gpu ^fg()${GPUTemp}°c  "
	echo -n "^fg($DZEN_FG2)hdd ^fg()${HDDTemp}°c"
	return
}

printMemInfo() {
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/mem.xbm) "
	echo -n "^fg()${MemUsed} "
	echo -n "$(echo $MemPerc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl) "
	return
}

printFileInfo() {
	NPKGS=$(pacman -Q | wc -l)
	NPROC=$(expr $(ps -A | wc -l) - 1)
#	echo -n "^fg($COLOR_ICON)^i($ICONPATH/pc.xbm) "
	echo -n "^fg($DZEN_FG2)proc ^fg()$NPROC "
	echo -n "^fg($DZEN_FG2)pkgs ^fg()$NPKGS"
	return
}

printBattery() {
	BatPresent=$(acpi -b 2>/dev/null|grep Battery| wc -l)
	ACPresent=$(acpi -a 2>/dev/null| grep -c on-line)
	if [[ $ACPresent == "1" ]]; then
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/power-ac.xbm) "
#		echo -n "AC  "
	elif [[ $BatPresent == "1" ]]; then
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/power-bat.xbm) "
#                echo -n "Bat "
	fi

	if [[ $BatPresent == "1" ]]; then
		RPERC=$(acpi -b | awk '{print $4}' | tr -d "%,")
#		echo -n "^fg()$RPERC% "
		if [[ $RPERC -gt 20 ]]; then
			echo -n "$(echo $RPERC | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
		else
			echo -n "$(echo $RPERC | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
		fi
	fi
	return
}

printDiskInfo() {
	RFSP=$(df -h / | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
	HFSP=$(df -h /home | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
	if [[ $RFSP -gt 70 ]]; then
#	    RBAR=$(echo $RFSP | gdbar -fg $CRIT -bg \#202020 -h $PIE_H -w $PIE_H -s p -nonl)
	    RFSP="^fg($CRIT)"$RFSP"^fg()"
#        else
#	    RBAR=$(echo $RFSP | gdbar -fg $BAR_FG -bg $BAR_BG -h $PIE_H -w $PIE_H -s p -nonl)
	fi
	if [[ $HFSP -gt 70 ]]; then
#	    HBAR=$(echo $HFSP | gdbar -fg $CRIT -bg \#202020 -h $PIE_H -w $PIE_H -s p -nonl)
            HFSP="^fg($CRIT)"$HFSP"^fg()"
#        else
#	    HBAR=$(echo $HFSP | gdbar -fg $BAR_FG -bg $BAR_BG -h $PIE_H -w $PIE_H -s p -nonl)
	fi

	echo -n "^fg($COLOR_ICON)^i($ICONPATH/db.xpm) "
	echo -n "^fg($DZEN_FG2)root ^fg()${RBAR}^fg()${RFSP}%"
    if [[ $(mountpoint /home|grep not|wc|awk '{print $1}') -lt 1 ]];then
    	echo -n "  ^fg($DZEN_FG2)home ^fg()${HBAR}^fg()${HFSP}%"
    fi
}

printAlarm() {
    ATQS=$(atq|wc -l)

    if [[ $ATQS -gt 0 ]]; then
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/clock.xpm) "
        if [[ $ATQS -gt 1 ]]; then
            echo -n "$ATQS"
        fi
    fi

    # notice icon when snort logs an alert
    if [ ~/tmp/snorttime -ot /var/log/snort/alert ]; then
        echo -n "^ca(1, touch -r /var/log/snort/alert ~/tmp/snorttime)";
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/bug.xpm) "
        echo -n "^ca()"
    fi

    # notice icon when a service crashes
    if [[ -e /bin/rc-status ]]; then
        rc-status -c >/dev/null 2&>1
        if [[ $? -eq 0 ]]; then
#            echo -n "^ca(1, rc-status|xmessage -file -)";
	    echo -n "^fg($COLOR_ICON)^i($ICONPATH/attention.xpm) "
#            echo -n "^ca()"
        fi
    fi
}


printHostInfo() {
    echo -n " ^fg()$(hostname)^fg(#007b8c)/^fg(#5f656b)$(uname -m) ^fg(#a488d9)| ^fg()$Uptime"
    return
}

printDateInfo() {
	echo -n "^fg()$(date '+%Y^fg(#444).^fg()%m^fg(#444).^fg()%d^fg(#007b8c)/^fg(#5f656b)%a ^fg(#a488d9)| ^fg()%H^fg(#444):^fg()%M^fg(#444):^fg()%S')"
	return
}

printSpace() {
#	echo -n "^fg($COLOR_SEP)| ^fg() "
        echo -n "   "
	return
}

printArrow() {
	echo -n " ^fg(#a488d9)>^fg(#007b8c)>^fg(#444444)> "
	return
}

printBar1() {
		read CPULoad0 CPULoad1 CPULoad2 CPULoad3 CPUFreq MemUsed MemPerc Uptime TopProc
                echo -n "0 "
		printHostInfo
		printSpace
		printCPUInfo
		printSpace
		printMemInfo
                printSpace
#		printArrow
		printDiskInfo
		printSpace
#		printFileInfo
#		printSpace
		printTempInfo
		printSpace
		printBattery
		printSpace
		printVolInfo
		printSpace
                printAlarm
#		echo -n $TopProc
		echo
	return
}

printBarClock() {
                echo -n "9 "
		echo -n "^pa($CLOCKPOS)"
		printDateInfo
		echo
	return
}

streamStatsBar() {
	while true; do
	    tmpbar=$(printBar1)
	    (
	    flock 200
	      echo $tmpbar >~/tmp/dmpipe
            ) 200>~/tmp/dmlock
#	      flock ~/tmp/dmlock -c "(conky -i 1 | printBar1 >~/tmp/dmpipe)"
	done
	return
}

streamClockBar() {
	while true; do
	      sleep 1
	    (
	      flock 200
	      printBarClock >~/tmp/dmpipe
            ) 200>~/tmp/dmlock
	done
	return
}

streamMailCheck() {

    mkfifo ~/tmp/ulockmail
    MAILRATE="30m"

	while true; do
              checkgmail >/dev/null
              if [[ $? -eq 0 ]]; then
                  MAILSTR="^ca(1, echo 'done' >~/tmp/ulockmail)^fg($COLOR_ICON)^i($ICONPATH/mail.xpm)^ca() "
              else
                  MAILSTR=""
                  MAILRATE="30m"
              fi

	    (
	      flock 200
	      echo "2 $MAILSTR" >~/tmp/dmpipe
            ) 200>~/tmp/dmlock
	    
            # create a delay that can be interupted by writting done to a fifo
            # return will be 124 for timeout, 0 for match, 1 for not match
            timeout -s HUP $MAILRATE grep -m 1 done ~/tmp/ulockmail
            case $? in
                0)
                    firefox 'https://mail.google.com/mail/?tab=wm#inbox'
                    MAILRATE="1m"
                    ;;
                1)
                    ;;
                124)
                    ;;
            esac

	done
	return
}

streamDynLogBar() {
	while true; do
	        read logstr
	    (
	      flock 200
	      echo "3    ^fg($COLOR_ICON)^i($ICONPATH/page_layout.xbm) $logstr   " >~/tmp/dmpipe
            ) 200>~/tmp/dmlock
	done
	return
}

monitorDzen() {
    # the dzen process should not terminate unless there is a crash of some type
    while true; do
      tail -f ~/tmp/dmpipe | dmplex | barDzen $NUM_SCRNS
      sleep 1
    done
  return
}

#conky -u $INTERVAL | printBar1 |tee testy.txt |
#exit
#Print all and pipe into dzen

#TRAP 'exit 0' SIGPIPE

barDzen() {
  if [ $1 -eq 1 ]; then
#    (sleep 0.6;xdotool mousemove 0 0;transset -p .7)&
    timeout -s HUP 1d dzen2 -xs $1 -dock -x $X_POS -y $Y_POS -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e ''
  else
    let "NXT = $1 - 1"
#    (sleep 0.8;xdotool mousemove 2000 0;transset -p .7)&
    tee >(timeout -s HUP 1d dzen2 -xs $1 -dock -x $X_POS -y $Y_POS -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e '') | barDzen $NXT
  fi
}

mkfifo ~/tmp/dmpipe
rm ~/tmp/dmlock
monitorDzen &

conky -u $INTERVAL| streamStatsBar &
streamClockBar &
streamMailCheck &
tail -f ~/.xmonad/dynlogpipe |streamDynLogBar
