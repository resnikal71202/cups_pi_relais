#! /bin/bash

# printer script

DIR="/var/spool/cups"

echo "using dir: ${DIR}"

#   Exports pin to userspace
echo "18" > /sys/class/gpio/export

# Sets pin 18 as an output
echo "out" > /sys/class/gpio/gpio18/direction
#my relais is reverse activated perhaps you shoud use 0 here
echo "1" > /sys/class/gpio/gpio18/value

COUNTER=$(ls -A $DIR | wc -l);
TIMER=0;

while true
do
        FILENUMBER=$(ls -A $DIR | wc -l)
        if [[ $FILENUMBER -gt $COUNTER ]]
        then
        TIMER=$(($FILENUMBER - $COUNTER + $TIMER + 10))
        COUNTER=$FILENUMBER
        fi
        if [[ $TIMER -gt $((0)) ]]
        then
                # Sets pin 18 to low
                echo "0" > /sys/class/gpio/gpio18/value
                TIMER=$(($TIMER - 1))
        else
                # Sets pin 18 to high
                echo "1" > /sys/class/gpio/gpio18/value
        fi
        sleep 5
done
