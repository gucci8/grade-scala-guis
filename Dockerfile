FROM apluslms/grading-java:1.8

ARG SCALA_URL=https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz
ARG SCALA_DIR=scala-2.12.2

RUN mkdir -p /usr/local/scala && cd /usr/local/scala \
  && (curl -Ls $SCALA_URL | tar zx)

ENV SCALA_HOME /usr/local/scala/$SCALA_DIR
ENV PATH $PATH:$SCALA_HOME/bin

ADD aplus /aplus

RUN mkdir -p /usr/local/scala/lib && cd /usr/local/scala/lib \
  && curl -LsO https://oss.sonatype.org/content/groups/public/org/scalatest/scalatest_2.12/3.0.1/scalatest_2.12-3.0.1.jar \
  && curl -LsO https://oss.sonatype.org/content/groups/public/org/scalactic/scalactic_2.12/3.0.1/scalactic_2.12-3.0.1.jar \
  && curl -LsO http://search.maven.org/remotecontent?filepath=org/scalamock/scalamock-core_2.12/3.6.0/scalamock-core_2.12-3.6.0.jar \
  && curl -LsO http://search.maven.org/remotecontent?filepath=org/scalamock/scalamock-scalatest-support_2.12/3.6.0/scalamock-scalatest-support_2.12-3.6.0.jar
