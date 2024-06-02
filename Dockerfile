FROM maven:3.9.6-eclipse-temurin-17

MAINTAINER Stephan Krusche <krusche@tum.de>

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

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN cd /opt/artemis-java-template && pwd && ls -la && ./gradlew clean test check -x test publishToMavenLocal && ./gradlew --version && ./gradlew --stop

RUN rm -rf /opt/artemis-java-template

CMD ["mvn"]
