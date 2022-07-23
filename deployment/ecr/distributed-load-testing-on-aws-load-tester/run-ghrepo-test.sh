#!/bin/bash

# INPUTS:
# CONCURRENCY
# RAMP_UP
# HOLD_FOR
# WORKERNUM

mkdir -p /tmp/ghrepo-results
STARTTIME=$(date +%s)
let ENDTIME=STARTTIME+RAMP_UP+HOLD_FOR
THREADNUM=1
while [ "$THREADNUM" -le "$CONCURRENCY" ]; do
    let SLEEPTIME=((THREAD-1)*RAMP_UP)/CONCURRENCY
    ./run-ghrepo-thread.sh $WORKERNUM $THREADNUM $SLEEPTIME $ENDTIME >/dev/null 2>&1 &
    let THREADNUM++
done
sleep $RAMP_UP
sleep $HOLD_FOR
sleep 2

# TO DO - PARSE RESULTS FROM THREADS
cat /tmp/ghrepo-results/thread*.txt /tmp/ghrepo-results/all.txt
SUCC=$(cat /tmp/ghrepo-results/all.txt | grep pass | wc -l)
FAIL=$(cat /tmp/ghrepo-results/all.txt | grep fail | wc -l)
STATS="$(cat /tmp/ghrepo-results/all.txt | grep pass | awk '{print $2}' | datamash --round=1 mean 1 pstdev 1 min 1 perc:50 1 perc:90 1 perc:95 1 perc:99 1 max 1)"
AVG=$(echo "$STATS" | awk '{print $1}')
STDDEV=$(echo "$STATS" | awk '{print $2}')
PERC0=$(echo "$STATS" | awk '{print $3}')
PERC50=$(echo "$STATS" | awk '{print $4}')
PERC90=$(echo "$STATS" | awk '{print $5}')
PERC95=$(echo "$STATS" | awk '{print $6}')
PERC99=$(echo "$STATS" | awk '{print $7}')
PERC100=$(echo "$STATS" | awk '{print $8}')

exit 0