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
    RES=$?
    ITEREND="$(date +%s%N)"
    let ELAPSED_MS=(ITEREND-ITERSTART)/1000000
    if [ $RES -eq 0 ]; then
        RES=pass
    else
        RES=fail
    fi
    echo "$RES $ELAPSED_MS" >> /tmp/ghrepo-results/thread$2.txt
    let COUNT++
    if [ $(date +%s) -ge $4 ]; then
        break
    fi
done

