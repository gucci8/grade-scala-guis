#!/bin/bash

files="Hello.scala /exercise/HelloTest.scala"
files=$(move-to-package-dirs -v $files)

set -x

# -Xshow-phases
export SCALACFLAGS="-encoding utf-8 -deprecation -feature -language:postfixOps -Ymacro-debug-lite"

if ! time capture pre scala-compile -M; then
    title -e p "Compilation failed, no tests were run. Compilation errors:"
    #err-to-out
elif time capture pre scalatest example.unitTests.HelloTest; then
    #err-to-out
    title -e p "Everything is ok and you got full points. Well done!"
fi
