#!/bin/bash

if [ $# -eq 0 ]; then
    echo "-------------------------------------------------------------------"
    echo "You need to specify the number of the trace file"
    echo "For example: ./diff.sh 05"
    echo "to compare the reference shell and your shell with trace05.txt"
    echo "This script will replace the PID from the output with *PID*, since"
    echo "it will be different between the reference shell and your shell"
    echo "If you want the PID number to be preserved, make the second"
    echo "parameter be -pid, that is: ./diff.sh 05 -pid"
    echo "-------------------------------------------------------------------"
    exit 1
fi


NOPID=true
if [ $# -eq 2 ]; then
    if [ $2 == "-pid" ]; then
        NOPID=false
    fi
fi

echo "Getting output from reference tsh and your tsh..."
make rtest$1 > r$1 & make test$1 > y$1 &
wait

if $NOPID
then 
    sed -e '1d' -e 's/([0-9][0-9]*)/(*PID*)/g' < r$1 > r$1nopid
    sed -e '1d' -e 's/([0-9][0-9]*)/(*PID*)/g' < y$1 > y$1nopid
fi

echo "Difference between outputs:"

if $NOPID
then
    diff r$1nopid y$1nopid -y
else
    diff r$1 y$1 -y
fi

rm r$1 y$1

if $NOPID
then
    rm r$1nopid y$1nopid
fi
