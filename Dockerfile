ARG BASE_TAG=latest
FROM apluslms/grade-java:$BASE_TAG

ARG SCALA_VER=2.12
ARG SCALA_FVER=2.12.8
ARG SCALA_URL=https://downloads.lightbend.com/scala/$SCALA_FVER/scala-$SCALA_FVER.tgz
ARG SCALA_DIR=/usr/local/scala
ENV SCALA_HOME=$SCALA_DIR/scala-$SCALA_FVER

ARG TEST_VER=3.0.5
ARG MOCK_VER=4.1.0

RUN mkdir -p $SCALA_DIR && cd $SCALA_DIR \
\
 # Download scala
 && (curl -Ls $SCALA_URL | tar zx) \
 && update-alternatives --install "/usr/bin/scala" "scala" "$SCALA_HOME/bin/scala" 1 \
 && update-alternatives --install "/usr/bin/scalac" "scalac" "$SCALA_HOME/bin/scalac" 1 \
 && update-alternatives --install "/usr/bin/fsc" "fsc" "$SCALA_HOME/bin/fsc" 1 \
\
 # Download libraries
 && mkdir -p $SCALA_DIR/lib && cd $SCALA_DIR/lib \
 && gpg_recv 63BB5E152DFF95F0 6081CA15292021FB \
 && download_verify -a -s -as https://oss.sonatype.org/content/groups/public/org/scalatest/scalatest_$SCALA_VER/$TEST_VER/scalatest_$SCALA_VER-$TEST_VER.jar \
 && download_verify -a -s -as https://oss.sonatype.org/content/groups/public/org/scalactic/scalactic_$SCALA_VER/$TEST_VER/scalactic_$SCALA_VER-$TEST_VER.jar \
 && download_verify -a -s -as https://search.maven.org/remotecontent?filepath=org/scalamock/scalamock_$SCALA_VER/$MOCK_VER/scalamock_$SCALA_VER-$MOCK_VER.jar

# Add scala utilities
COPY bin /usr/local/bin

ENV CLASSPATH=.:/exercise:/exercise/*:/exercise/lib/*:$SCALA_DIR/lib/*:$SCALA_HOME/*:$JAVA_DIR/lib/*:$JAVA_HOME/lib/*:$JAVA_HOME/jre/lib/*
