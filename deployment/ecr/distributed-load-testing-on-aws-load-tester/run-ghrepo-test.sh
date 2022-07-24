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
let DURATION=RAMP_UP+HOLD_FOR
OUTFILE=/tmp/ghrepo-results/summary.xml
echo "<FinalStatus><TestDuration>$DURATION</TestDuration><Group label=\">\"" >$OUTFILE
echo "<concurrency value=\"$CONCURRENCY\"><name>concurrency</name><value>$CONCURRENCY</value></concurrency>" >>$OUTFILE
echo "<succ value=\"$SUCC\"><name>succ</name><value>$SUCC</value></succ>" >>$OUTFILE
echo "<fail value=\"$FAIL\"><name>fail</name><value>$FAIL</value></fail>" >>$OUTFILE
echo "<avg_rt value=\"$AVG\"><name>avg_rt</name><value>$AVG</value></avg_rt>" >>$OUTFILE
echo "<stdev_rt value=\"$STDDEV\"><name>stdev_rt</name><value>$STDDEV</value></stdev_rt>" >>$OUTFILE
echo "<perc value=\"$PERC0\" param=\"0.0\"><name>perc/0.0</name><value>$PERC0</value></perc>" >>$OUTFILE
echo "<perc value=\"$PERC50\" param=\"50.0\"><name>perc/50.0</name><value>$PERC50</value></perc>" >>$OUTFILE
echo "<perc value=\"$PERC90\" param=\"90.0\"><name>perc/90.0</name><value>$PERC90</value></perc>" >>$OUTFILE
echo "<perc value=\"$PERC95\" param=\"95.0\"><name>perc/95.0</name><value>$PERC95</value></perc>" >>$OUTFILE
echo "<perc value=\"$PERC99\" param=\"99.0\"><name>perc/99.0</name><value>$PERC99</value></perc>" >>$OUTFILE
echo "<perc value=\"$PERC100\" param=\"100.0\"><name>perc/100.0</name><value>$PERC100</value></perc>" >>$OUTFILE
echo "</Group></FinalStatus>" >>$OUTFILE
exit 0