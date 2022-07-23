#!/bin/bash

# $1 = WORKER NUMBER (Starts from 1)
# $2 = THREAD NUMBER (Starts from 1)
# $3 = STARTDELAY (Sleep before starting)
# $4 = ENDTIME (in date +%s format)

cd /root/repo
sleep $3
COUNT=0

while true; do
    ITERSTART="$(date +%s%N)"
    /tmp/run.sh $1 $2 $COUNT
    ITEREND="$(date +%s%N)"
    let ELAPSED_MS=(ITEREND-ITERSTART)/1000000
    let COUNT++
    if [ $(date +%s) -ge $4 ]; then
        break
    fi
done

