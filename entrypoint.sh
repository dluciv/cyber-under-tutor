#!/bin/sh -l

echo "Hello $1!"
pwd
ls
time=$(date)
echo "::set-output name=time::$time"
