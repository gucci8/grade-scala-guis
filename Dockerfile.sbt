ARG FULL_TAG
FROM apluslms/grade-scala:$FULL_TAG

ARG SBT_VER=1.1.6

RUN cd /tmp \
 # Download sbt
 && gpg_recv 99E82A75642AC823 \
 && download_verify -a -m https://dl.bintray.com/sbt/debian/sbt-$SBT_VER.deb \
 && dpkg -i sbt-$SBT_VER.deb \
 && rm sbt-$SBT_VER.deb \
 && apt_install sbt \
 && sbt sbtVersion
