#!/bin/sh

docker build -t temp:latest -f gvm.Dockerfile . || exit 0

docker run --rm -v `pwd`/temp:/code -it temp /bin/bash -c '
cd /tmp/scalac-native
cp /code/*.scala .
time ./scalac-native -d . HelloTest.scala
'
#time $SCALA_HOME/bin/scalac HelloTest.scala
