#!/bin/bash
MYNAME=$1
NAP=2
STATE=starting
COUNTER=0

endservice() {
    COUNTER=3
    STATE=stopping
}

trap "endservice" SIGINT SIGTERM

nap() {
	sleep $NAP
}

beep() {
    echo "$MYNAME is $STATE"
    if [ "$STATE" == "stopped" ]
    then
		exit 1
	fi 
}

if [ "$MYNAME" = "" ]
then
    echo "usage: robot.sh "
    exit 1
fi

echo "Hi, I am $MYNAME, and I am at your service!"

while true 
do
	nap
	beep
	case $STATE in
	starting) STATE=started;;
	stopping) let COUNTER=COUNTER-1;
        if [ "$COUNTER" == "0" ]
        then
            STATE=stopped
		fi
		;; 
	esac
done