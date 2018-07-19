#!/bin/sh

files="Hello.scala /exercise/HelloTest.scala"
files=$(move-to-package-dirs -v $files)

if ! capture pre scala-compile -M; then
    title -e p "Compilation failed, no tests were run. Compilation errors:"
    #err-to-out
elif capture pre scalatest example.unitTests.HelloTest; then
    err-to-out
    title -e p "Everything is ok and you got full points. Well done!"
fi
