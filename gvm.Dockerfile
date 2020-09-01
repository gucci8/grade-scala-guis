FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

# Install bases system, including OpenJDK
RUN : \
 # install openjdk
 && echo "deb http://deb.debian.org/debian sid main" > /etc/apt/sources.list.d/sbt.list \
 && apt-get update -qqy \
 && mkdir -p /usr/share/man/man1 \
 && apt-get install -qqy \
    -o APT::Install-Recommends="false" -o APT::Install-Suggests="false" \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    curl \
    git \
    openjdk-8-jdk-headless \
    # for graalvm
    build-essential \
    zlib1g-dev \
    # for apt-key
    gnupg2 \
 && rm -rf /usr/share/man \
           /var/lib/apt/lists/* \
           /var/cache/apt/* || true

# Install sbt
COPY scalasbt@gmail.com.asc /tmp/sbt.key
RUN : \
 && echo "" > /etc/java-8-openjdk/accessibility.properties \
 && echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list \
 && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=x apt-key add /tmp/sbt.key \
 && apt-get update -qqy \
 && apt-get install -qqy \
    -o APT::Install-Recommends="false" -o APT::Install-Suggests="false" \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    sbt \
 && rm -rf /usr/share/man \
           /var/lib/apt/lists/* \
           /var/cache/apt/* || true

# Install GraalVM
# TODO: 19.0.2..19.1.0 fails to build scalac
#ARG GRAALVM_VER=19.1.0
#ARG GRAALVM_URL=https://github.com/oracle/graal/releases/download/vm-$GRAALVM_VER/graalvm-ce-linux-amd64-$GRAALVM_VER.tar.gz
ARG GRAALVM_VER=1.0.0-rc16
ARG GRAALVM_URL=https://github.com/oracle/graal/releases/download/vm-$GRAALVM_VER/graalvm-ce-$GRAALVM_VER-linux-amd64.tar.gz
ENV GRAALVM_HOME=/usr/local/graalvm

RUN mkdir -p $GRAALVM_HOME && cd $GRAALVM_HOME  \
 && curl -LSs $GRAALVM_URL | tar zx --strip-components=1 \
 && ln -s $GRAALVM_HOME/bin/* /usr/local/bin \
 # TODO: graalvm 19+
 #&& gu install native-image \
 && :

# Install Scala
ARG SCALA_VER=2.12
ARG SCALA_FVER=2.12.8
ARG SCALA_URL=https://downloads.lightbend.com/scala/$SCALA_FVER/scala-$SCALA_FVER.tgz
ENV SCALA_HOME=/usr/local/scala

RUN mkdir -p $SCALA_HOME && cd $SCALA_HOME  \
 && curl -LSs $SCALA_URL | tar zx --strip-components=1 \
 && ln -s $SCALA_HOME/bin/* /usr/local/bin \
 && :


# Build scalac-native
RUN git clone -q https://github.com/graalvm/graalvm-demos.git \
 && (cd graalvm-demos && git reset --hard 1c0b44e0f108fc87fa54a8c92db18925b6a144e7) \
 && ln -s graalvm-demos/scala-days-2018/scalac-native scalac-native

RUN cd scalac-native/scalac-substitutions \
 && echo "scalaVersion := \"$SCALA_FVER\"" > build.sbt \
 && sbt package

RUN cd scalac-native \
 && ./scalac-image.sh \
    -H:+ReportExceptionStackTraces \
    --report-unsupported-elements-at-runtime \
    # TODO: graalvm 19+
    #--initialize-at-build-time=scala.runtime.StructuralCallSite \
    #--initialize-at-build-time=scala.runtime.EmptyMethodCache \
 && :

RUN : \
 && apt-get update -qqy \
 && mkdir -p /usr/share/man/man1 \
 && apt-get install -qqy \
    -o APT::Install-Recommends="false" -o APT::Install-Suggests="false" \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    ant \
    ivy \
 && rm -rf /usr/share/man \
           /var/lib/apt/lists/* \
           /var/cache/apt/* || true

COPY temp/ivy_install /usr/local/sbin/

ARG SCALA_VER=2.12
ARG SCALA_FVER=2.12.9

RUN ivy_install -n "grade-scala" -d "/usr/local/scala/lib" \
    org.scala-lang scala-library $SCALA_FVER \
    org.scala-lang scala-compiler $SCALA_FVER \
    # extra libs
    org.scala-lang.modules scala-swing_$SCALA_VER 2.0.3 \
    # for grading
    org.scalatest scalatest_$SCALA_VER 3.0.5 "default->master,compile,runtime" \
    org.scalamock scalamock_$SCALA_VER [4.1.0,4.2[ \
    org.scalastyle scalastyle_$SCALA_VER [1.0.0,1.1[ \
    com.typesafe.akka akka-actor_$SCALA_VER [2.5.20,2.6[ \
 && :


