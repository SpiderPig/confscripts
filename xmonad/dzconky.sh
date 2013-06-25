#!/bin/bash

#Layout
BAR_H=8
PIE_H=32
BIGBAR_W=60
SMABAR_W=30
HEIGHT=18

X_POS=0
Y_POS=0

#TEST_MODE="on"
if [[ -n $TEST_MODE ]]; then
  HEIGHT=32
fi

#NUM_SCRNS=$(xdpyinfo |grep 'number of screens'|awk '{print $4}')
XRES=$(xdpyinfo |grep 'dimensions:'|perl -pe 's/\s*\S*\s*(\d*)x.*/\1/')
if [ $XRES -gt 2400 ]; then
  NUM_SCRNS=2
else
  NUM_SCRNS=1
fi
DZEN_WIDTH=$(($XRES/$NUM_SCRNS))

CLOCKPOS=$((DZEN_WIDTH-180-30))


#Look and feel
CRIT="#d74b73"
COLOR_WRN="#d8de91"
BAR_FG="#63a5b3"
BAR_BG="#3f6a73"
DZEN_FG="#adadad"
DZEN_FG2="#7f757b"

DZEN_BG="#000000"
DZEN_OUTLINE="#808080" # "#63a5b3"
COLOR_ICON="#adadad"
ICONPATH="$HOME/.icons/dzen-xbm"
#COLOR_SEP="#007b8c"
COLOR_SEP="#63a5b3"
FONT="xft:Clean:style=bold:size=9:antialias=true"
#-*-clean-bold-r-normal-*-12-*-*-*-*-*-*-*
SEP_CODE="   ^fg(${DZEN_OUTLINE})^r(1x${HEIGHT})^fg(#000000)^r(2x${HEIGHT})^fg(${DZEN_OUTLINE})^r(1x${HEIGHT}) "

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

if [[ -n $TEST_MODE ]]; then
	echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h 32 -w 32 -s p -nonl
#	 echo -ne "^p(-32)^fg(#0f3a43)^co(32)"
	echo -ne "^p(-30)"
	echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h 28 -w 28 -s p -nonl
#	 echo -ne "^p(-28)^fg(#0f3a43)^co(28)"
	echo -ne "^p(-26)"
	echo $CPULoad2 | gdbar -fg $BAR_FG -bg $BAR_BG -h 24 -w 24 -s p -nonl
#	 echo -ne "^p(-24)^fg(#0f3a43)^co(24)"
	echo -ne "^p(-22)"
	echo $CPULoad3 | gdbar -fg $BAR_FG -bg $BAR_BG -h 20 -w 20 -s p -nonl
#	 echo -ne "^p(-20)^fg(#0f3a43)^co(20)"
	echo -ne "^p(-18)"
	echo -ne "^fg($DZEN_BG)^c(16)^p(-16)"
	echo -ne "^fg($BAR_BG)^co(16)^p(8)"
	echo -n "^fg()"
fi
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
                echo -ne "$SEP_CODE"
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
#          RBAR=$(echo $RFSP | gdbar -fg $BAR_FG -bg $BAR_BG -h $PIE_H -w $PIE_H -s p -nonl)
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

if [[ -n $TEST_MODE ]]; then
	echo $RFSP | gdbar -fg $BAR_FG -bg \#000000 -h 32 -w 32 -s p -nonl
	echo -ne "^p(-32)"
	echo -ne "^fg($BAR_BG)^co(${PIE_H})^p(-32)"
	echo -ne "^p(3)"
	echo -ne "^fg($DZEN_BG)^c(26)^p(-26)"
	echo -ne "^fg($BAR_BG)^co(26)"
#        echo -ne "^p(-26)root"
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
        rc-status -c >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
#            echo -n "^ca(1, rc-status|xmessage -file -)";
	    echo -n "^fg($COLOR_ICON)^i($ICONPATH/attention.xpm) "
#            echo -n "^ca()"
        fi
    fi
}

printNetwork() {
    if [[ -e /sbin/iwconfig ]]; then
        ifconfig wlan0 >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            read  Niface Nessid Nap Npow Nlink < <(iwconfig wlan0|tr -d '\n'|perl -pe 's/(\S*).*ESSID:"?([^" ]*)"?.*Access Point: (\S*).*Tx-Power=(\S*)(.*Link Quality=(\d+\/\d+))?.*/\1|\2|\3|\4|\6\n/')

            if [[ -n $Nlink ]]; then
                IFS="/" lnk=( $Nlink )
                Nlink=$((${lnk[0]} * 100 / ${lnk[1]}))
            else
                Nlink=0
            fi

            echo -n "^ca(1, wifi-radar)";
#	    echo -n "^fg($COLOR_ICON)^i($ICONPATH/net-wifi.xbm) "
            if [[ -z $Npow || $Npow == "off" ]]; then
                echo -n "^fg(#404040)$Niface "
                WFI_FG="#a0a0a0"
                WFI_BG="#404040"
            elif [[ $Nap == "Not-Associated" ]]; then
                echo -n "^fg($DZEN_FG2)$Niface "
                WFI_FG="#a0a0a0"
                WFI_BG="#404040"
            else
                echo -n "^fg($DZEN_FG2)$Nessid "
                WFI_FG=$BAR_FG
                WFI_BG=$BAR_BG
            fi

#	    echo -n "$(echo $Nlink | gdbar -fg $WFI_FG -bg $WFI_BG    -h 15 -w 10 -s v -sh 2 -ss 1 -sw 12 -nonl)"
	    echo -n "$(echo $Nlink | gdbar -fg $WFI_FG -bg $WFI_BG    -h $BAR_H -w 18  -sw 2 -ss 1 -nonl)"

            echo -n "^ca()^ib(1) "
#	    printSpace
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
                echo -ne "^p(_TOP)^fg(${DZEN_OUTLINE})^ro($((DZEN_WIDTH-2))x${HEIGHT-4})^p($((2-DZEN_WIDTH)))^p()^p(;1)^ib(1)^p()"
		printHostInfo
                echo -ne "$SEP_CODE"
#		printSpace
		printCPUInfo
                echo -ne "$SEP_CODE"
#		printSpace
		printMemInfo
                echo -ne "$SEP_CODE"
#               printSpace
#		printArrow
		printDiskInfo
                echo -ne "$SEP_CODE"
#		printSpace
#		printFileInfo
#		printSpace
		printTempInfo
                echo -ne "$SEP_CODE"
#		printSpace
		printBattery
#		printSpace
		printVolInfo
                echo -ne "$SEP_CODE"
#		printSpace
                printNetwork

                printAlarm
#		echo -n $TopProc
		echo
	return
}

printBarClock() {
                echo -n "9 "
		echo -n "^pa($CLOCKPOS)"
                echo -n "$SEP_CODE"
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
	      echo "3 ${SEP_CODE}^fg($COLOR_ICON)^i($ICONPATH/page_layout.xbm) $logstr   " >~/tmp/dmpipe
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
    timeout -s HUP 1d dzen2 -xs $1 -dock -x $X_POS -y $Y_POS -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e ''
  else
    let "NXT = $1 - 1"
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
