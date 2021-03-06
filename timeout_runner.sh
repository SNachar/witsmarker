#!/bin/bash

# Arg 1 - working directory
cd $1
# Arg 2 - program to run
# Connect stdin (&0) to stdin of the program
# Connect stdout (&1) to stdout of program
# Connect stderr (&2) to stderr of program
# Run program in the background
$2 <&0 >&1 2>&2 &
# Get the PID of the last program
i=$!
count=0
ps aux | grep $i | grep -v grep >/dev/null
running=$?
while [ "$running" -eq "0" ] && [ "$count" -lt "$3" ]
do
    ps aux | grep $i | grep -v grep >/dev/null
    running=$?
    let "count=count+1"
    sleep 1
done
# Arg 3 - the amount of time in sec to wait before killing the program

# Try kill the program, if kill is successful, echo that it was running
# TODO: Make sure that the PID isn't reused!!!
kill -9 $i 2>/dev/null && echo -n "Time limit exceeded" >&2
