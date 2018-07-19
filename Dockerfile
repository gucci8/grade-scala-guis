ARG BASE_TAG=latest
FROM apluslms/grade-java:$BASE_TAG

ARG SCALA_VER=2.12
ARG SCALA_FVER=2.12.6
ARG SCALA_URL=https://downloads.lightbend.com/scala/$SCALA_FVER/scala-$SCALA_FVER.tgz
ARG SCALA_DIR=/usr/local/scala
ENV SCALA_HOME=$SCALA_DIR/scala-$SCALA_FVER

RUN mkdir -p $SCALA_DIR && cd $SCALA_DIR \
\
 # Download scala
 && (curl -Ls $SCALA_URL | tar zx) \
 && update-alternatives --install "/usr/bin/scala" "scala" "$SCALA_HOME/bin/scala" 1 \
 && update-alternatives --install "/usr/bin/scalac" "scalac" "$SCALA_HOME/bin/scalac" 1 \
 && update-alternatives --install "/usr/bin/fsc" "fsc" "$SCALA_HOME/bin/fsc" 1

ADD bin /usr/local/bin

RUN mkdir -p $SCALA_DIR/lib && cd $SCALA_DIR/lib \
  && curl -LsO https://oss.sonatype.org/content/groups/public/org/scalatest/scalatest_2.12/3.0.1/scalatest_2.12-3.0.1.jar \
  && curl -LsO https://oss.sonatype.org/content/groups/public/org/scalactic/scalactic_2.12/3.0.1/scalactic_2.12-3.0.1.jar \
  && curl -LsO http://search.maven.org/remotecontent?filepath=org/scalamock/scalamock-core_2.12/3.6.0/scalamock-core_2.12-3.6.0.jar \
  && curl -LsO http://search.maven.org/remotecontent?filepath=org/scalamock/scalamock-scalatest-support_2.12/3.6.0/scalamock-scalatest-support_2.12-3.6.0.jar
