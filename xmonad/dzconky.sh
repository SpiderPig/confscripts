#!/bin/bash

#Layout
BAR_H=8
BIGBAR_W=60
SMABAR_W=30
HEIGHT=16

X_POS=0
Y_POS=0

#NUM_SCRNS=$(xdpyinfo |grep 'number of screens'|awk '{print $4}')
if [ `xdpyinfo |grep 'dimensions:'|perl -pe 's/\s*\S*\s*(\d*)x.*/\1/'` -gt 2400 ]; then
  NUM_SCRNS=2
else
  NUM_SCRNS=1
fi

#Look and feel
CRIT="#d74b73"
#BAR_FG="#60a0c0"
#BAR_BG="#363636"
#DZEN_FG="#9d9d9d"
#DZEN_FG2="#5f656b"

BAR_FG="#63a5b3"
BAR_BG="#3f6a73"
DZEN_FG="#adadad"
DZEN_FG2="#7f757b"

DZEN_BG="#050505"
COLOR_ICON="#60a0c0"
COLOR_SEP="#007b8c"
FONT="-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*"

#Options
IFS='|' #internal field separator (conky)
CONKYFILE="~/.conkyrc"
ICONPATH="/home/msytsma/.icons/subtlexbm"
INTERVAL=1
CPUTemp=0
GPUTemp=0
CPULoad0=0
CPULoad1=0
CPULoad2=0
CPULoad3=0
NetUp=0
NetDown=0
TopProc=""

printVolInfo() {
	Perc=$(amixer get Master | grep "Front:" | awk '{print $4}' | tr -d '[]%')
	Mute=$(amixer get Master | grep "Front:" | awk '{print $6}')
	if [[ $Mute == "[off]" ]]; then
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_off.xbm) "
		echo -n "^fg()off "
		echo -n "$(echo $Perc | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -o -nonl)"
	else
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_on.xbm) "
		echo -n "^fg()${Perc}% "
		echo -n "$(echo $Perc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -o -nonl)"
	fi
	return
}

printCPUInfo() {
#	echo -n "^fg($COLOR_ICON)^i($ICONPATH/cpu.xbm) "
#	echo -n "^fg()${CPULoad0}% "
	echo -n "$(echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -o -nonl) "
#	echo -n "^fg()${CPULoad1}% "
	echo -n "$(echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -o -nonl) "
    echo -n "$(echo $CPULoad2 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -o -nonl) "
    echo -n "$(echo $CPULoad3 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -o -nonl) "
	echo -n "${CPUFreq}GHz"
	return
}

printTempInfo() {
#	CPUTemp=$(acpi --thermal | awk '{print substr($4,0,2)}')
	CPUTemp=$(sensors|grep 'CPU Temperature'|perl -pe 's/.*:\s*[+-]([0-9.]*).*/\1/')
    if [[ -e /usr/bin/nvidia-settings ]]; then
      GPUTemp=$(nvidia-settings -q gpucoretemp | grep 'Attribute' | awk '{print $4}' | tr -d '.')
    else
      GPUTemp=0
    fi
	HDDTemp=$(hddtemp -q /dev/sd?|perl -pe 's/.*not available//; s/.*:.*:\s+(\d+).*/\1/;  if ($_ > $g){$g = $_;} $_=$g;'|tail -1)

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

#	echo -n "^fg($COLOR_ICON)^i($ICONPATH/temp.xbm) "
	echo -n "^fg($DZEN_FG2)cpu ^fg()${CPUTemp}c "
	echo -n "^fg($DZEN_FG2)gpu ^fg()${GPUTemp}c "
	echo -n "^fg($DZEN_FG2)hdd ^fg()${HDDTemp}c"
	return
}

printMemInfo() {
#	echo -n "^fg($COLOR_ICON)^i($ICONPATH/memory.xbm) "
	echo -n "^fg()${MemUsed} "
	echo -n "$(echo $MemPerc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -o -nonl) "
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
#		echo -n "^fg($COLOR_ICON)^i($ICONPATH/ac1.xbm) "
		echo -n "AC  "
	else
#		echo -n "^fg($COLOR_ICON)^i($ICONPATH/battery_vert3.xbm) "
                echo -n "Bat "
	fi
	if [[ $BatPresent == "0" ]]; then
		echo -n "^fg($DZEN_FG2)AC ^fg()on ^fg($DZEN_FG2)Bat ^fg()off"
		return
	else
		RPERC=$(acpi -b | awk '{print $4}' | tr -d "%,")
#		echo -n "^fg()$RPERC% "
		if [[ $RPERC -gt 20 ]]; then
			echo -n "$(echo $RPERC | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -o -nonl)"
		else
			echo -n "$(echo $RPERC | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -o -nonl)"
		fi
	fi
	return
}

printDiskInfo() {
	RFSP=$(df -h / | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
	HFSP=$(df -h /home | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
	if [[ $RFSP -gt 70 ]]; then
		RFSP="^fg($CRIT)"$RFSP"^fg()"
	fi
	if [[ $HFSP -gt 70 ]]; then
		HFSP="^fg($CRIT)"$HFSP"^fg()"
	fi
#	echo -n "^fg($COLOR_ICON)^i($ICONPATH/file1.xbm) "
	echo -n "^fg($DZEN_FG2)root ^fg()${RFSP}% "
    if [[ $(mountpoint /home|grep not|wc|awk '{print $1}') -lt 1 ]];then
    	echo -n "^fg($DZEN_FG2)home ^fg()${HFSP}%"
    fi
}

printKerInfo() {
	echo -n " ^fg()$(uname -r)^fg(#007b8c)/^fg(#5f656b)$(uname -m) ^fg(#a488d9)| ^fg()$Uptime"
	return
}

printHostInfo() {
    echo -n " ^fg()$(hostname)^fg(#007b8c)/^fg(#5f656b)$(uname -m) ^fg(#a488d9)| ^fg()$Uptime"
    return
}

printDateInfo() {
	echo -n "^fg()$(date '+%Y^fg(#444).^fg()%m^fg(#444).^fg()%d^fg(#007b8c)/^fg(#5f656b)%a ^fg(#a488d9)| ^fg()%H^fg(#444):^fg()%M^fg(#444):^fg()%S')"
	return
}

printDynLog() {
    Dynlog=$(tail ~/.xmonad/logstatus -n 1)
    if [[ -n $Dynlog ]];then
      echo -n "$Dynlog"
    fi
}

printSpace() {
	echo -n " ^fg($COLOR_SEP)|^fg() "
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
		printArrow
#		echo -n "^pa(100)"
		printDiskInfo
		printSpace
#		printFileInfo
#		printSpace
		printTempInfo
		printSpace
		printBattery
		printSpace
#        printDynLog
#		printVolInfo
#		printArrow
#		echo -n $TopProc
		echo
	return
}

printBar2() {
                echo -n "3 "
		echo -n "^pa(1750)"
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
	      printBar2 >~/tmp/dmpipe
            ) 200>~/tmp/dmlock
	done
	return
}

streamDynLogBar() {
	while true; do
	        read logstr
	    (
	      flock 200
	      echo "2 $logstr" >~/tmp/dmpipe
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
    (sleep 0.6;xdotool mousemove 0 0;transset -p .7)&
    dzen2 -xs $1 -x $X_POS -y $Y_POS -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e ''
  else
    let "NXT = $1 - 1"
    (sleep 0.8;xdotool mousemove 2000 0;transset -p .7)&
    tee >(dzen2 -xs $1 -x $X_POS -y $Y_POS -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e '') | barDzen $NXT
  fi
}

mkfifo ~/tmp/dmpipe
rm ~/tmp/dmlock
monitorDzen &

conky -u $INTERVAL| streamStatsBar &
streamClockBar &
tail -f ~/.xmonad/dynlogpipe |streamDynLogBar