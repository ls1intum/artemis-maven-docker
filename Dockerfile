# Explicitly use the image that is based on Ubuntu 20.04 Focal instead of 22.04,
# as the newer Ubuntu release includes an updated glibc that does not work with
# older Docker hosts.
# c.f. https://github.com/adoptium/containers/issues/215#issuecomment-1142046045
FROM maven:3-eclipse-temurin-17-focal

MAINTAINER Stephan Krusche <krusche@in.tum.de>

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    gnupg \
 && rm -rf /var/lib/apt/lists/*

ENV M2_HOME /usr/share/maven

RUN echo "$LANG -- $LANGUAGE -- $LC_ALL" \
    && curl --version \
    && gpg --version \
    && git --version \
    && mvn --version \
    && java --version \
    && javac --version


ADD artemis-java-template /opt/artemis-java-template

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test -Pcoverage && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN cd /opt/artemis-java-template && pwd && ls -la && ./gradlew clean test check -x test publishToMavenLocal && ./gradlew --version

RUN rm -rf /opt/artemis-java-template

CMD ["mvn"]
