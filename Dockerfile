FROM apluslms/grade-scala:latest

ARG SCALA_VER=2.13
ARG SBT_VERSION=1.5.5
ARG SCALA_DIR=/usr/local/scala

RUN : \
 # Download libraries
 && ivy_install -n "grade-scala-guis" -d "$SCALA_DIR/lib" \
    # Swing
    org.scala-lang.modules scala-swing_$SCALA_VER 2.1.1 \
    # ScalaFX
    org.scalafx scalafx_$SCALA_VER 16.0.0-R24 \
    # JavaFX
    org.openjfx javafx-base 12.0.1 \
    org.openjfx javafx-controls 12.0.1 \
    org.openjfx javafx-fxml 12.0.1 \
    org.openjfx javafx-graphics 12.0.1 \
    org.openjfx javafx-media 12.0.1 \
    org.openjfx javafx-swing 12.0.1 \
    org.openjfx javafx-web 12.0.1 \
    # TestFX
    org.testfx testfx-core 4.0.16-alpha \
    org.testfx testfx-junit5 4.0.16-alpha \
    org.testfx openjfx-monocle jdk-12.0.1+2 \
    # Junit
    org.junit.jupiter junit-jupiter-api 5.7.0 \
    org.junit.jupiter junit-jupiter-engine 5.7.0 \
    org.junit.platform junit-platform-runner 1.7.0 \
    net.aichler jupiter-interface 0.9.1 \
  && :

# Install sbt
RUN \
  mkdir /working/ && \
  cd /working/ && \
  curl -L -o sbt-$SBT_VERSION.deb https://repo.scala-sbt.org/scalasbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  cd && \
  rm -r /working/ && \
  sbt sbtVersion

# Install libgtk
RUN : \
  apt-get update && \
  apt-get install libgtk2.0-0

# Add scala utilities
COPY bin /usr/local/bin

ENV CLASSPATH=.:/exercise:/exercise/*:/exercise/lib/*:$SCALA_DIR/lib/*:/usr/local/java/lib/*
