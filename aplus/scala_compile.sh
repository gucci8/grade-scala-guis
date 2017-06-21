#!/bin/bash
SCRIPTDIR=`dirname $0`
#FSC=fschost:30000
ARGS="-encoding utf-8 -deprecation -feature -language:postfixOps"
CP=$1
if [ "$CP" == "" ]; then
	CP=.:/usr/local/java/lib/*:/usr/local/scala/lib/*
fi

# Fix package directories for files uploaded to root.
find . -maxdepth 1 -name \*.scala -exec $SCRIPTDIR/addpackagedirs.sh {} +

FILES=`find . -name \*.scala`
if [ "$FILES" == "" ]; then
	echo "No files to compile."
	exit 1
fi

# Compile files.
if [ -n "$FSC" ]; then
	fsc -ipv4 -server $FSC -classpath $CP $ARGS $FILES
else
	scalac -classpath $CP $ARGS $FILES
fi
COMPILE_RESULT=$?

# Clean up all source files.
rm $FILES
exit $COMPILE_RESULT
