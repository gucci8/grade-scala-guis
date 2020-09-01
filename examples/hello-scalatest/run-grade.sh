#!/bin/sh

cd "${0%/*}"

file=Hello.scala
for src in Hello.scala; do
    echo "Running test with $src -> should return $code"
    echo "----------------------------------------------------------------------"
    docker run --rm \
        --mount=type=tmpfs,tmpfs-size=20M,destination=/submission/user \
        -v `pwd`:/submission/test:ro \
        -v `pwd`/en:/exercise:ro \
        apluslms/grade-scala:2.12-3.0 \
        /bin/bash -c "cp '/submission/test/$src' '$file'; /exercise/run.sh; ret=\$?; cat /feedback/out /feedback/err; exit \$ret"
    echo "----------------------------------------------------------------------"
    docker run --rm \
        --mount=type=tmpfs,tmpfs-size=20M,destination=/submission/user \
        -v `pwd`:/submission/test:ro \
        -v `pwd`/en:/exercise:ro \
        -e SCALAC=scalac-native \
        apluslms/grade-scala:2.12-3.0 \
        /bin/bash -c "cp '/submission/test/$src' '$file'; /exercise/run.sh; ret=\$?; cat /feedback/out /feedback/err; exit \$ret"
    ret=$?
    echo "----------------------------------------------------------------------"
    echo
    echo
done
