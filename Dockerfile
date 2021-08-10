FROM apluslms/grade-scala:2.12-3.0

ARG SCALA_VER=2.12
ARG SCALA_DIR=/usr/local/scala
ENV JAVA_OPTS="-Dprism.order=sw -Dprism.text=t2k -Dtestfx.robot=glass -Dtestfx.headless=true -Dtestfx.setup.timeout=2500"

RUN : \
 # Download libraries
 && ivy_install -n "grade-scala-guis" -d "$SCALA_DIR/lib" \
    # Swing
    org.scala-lang.modules scala-swing_$SCALA_VER 2.1.1 \
    # ScalaFX
    org.scalafx scalafx_$SCALA_VER 16.0.0-R24 \
    # JavaFX
    org.openjfx javafx-base 14.0.1 \
    org.openjfx javafx-controls 14.0.1 \
    org.openjfx javafx-fxml 14.0.1 \
    org.openjfx javafx-graphics 14.0.1 \
    org.openjfx javafx-media 14.0.1 \
    org.openjfx javafx-swing 14.0.1 \
    org.openjfx javafx-web 14.0.1 \
    # TestFX
    org.testfx testfx-core 4.0.16-alpha \
    org.testfx testfx-junit5 4.0.16-alpha \
    org.testfx openjfx-monocle jdk-12.0.1+2 \
    # Junit
    org.junit.jupiter junit-jupiter-api 5.7.0-M1 \
    org.junit.jupiter junit-jupiter-engine 5.7.0-M1 \
    org.junit.platform junit-platform-runner 1.7.0-M1 \
 && :

ENV CLASSPATH=.:/exercise:/exercise/*:/exercise/lib/*:$SCALA_DIR/lib/*:/usr/local/java/lib/*
