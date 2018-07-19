#!/bin/sh

cp -r /exercise/ .

mv Hello.scala src/main/scala/
files=$(cd src/main/scala && move-to-package-dirs)

capture pre sbt test
points 10 $?
