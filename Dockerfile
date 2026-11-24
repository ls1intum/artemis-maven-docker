FROM maven:3.10.0-eclipse-temurin-25

LABEL maintainer="Stephan Krusche <krusche@tum.de>"

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends gnupg && \
    rm -rf /var/lib/apt/lists/*

ENV M2_HOME=/usr/share/maven

RUN echo "$LANG -- $LANGUAGE -- $LC_ALL" \
    && curl --version \
    && gpg --version \
    && git --version \
    && mvn --version \
    && java --version \
    && javac --version

ADD artemis-java-template /opt/artemis-java-template

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

# Resolve Ares 2 the way Artemis exercises do (its own dependency tree, only Guava and commons-beanutils managed): the template project above pins other
# versions of the same artifacts (e.g. commons-lang3, objenesis). It must not keep the vulnerable Guava that Ares brings.
ADD ares-resolve /opt/ares-resolve

RUN cd /opt/ares-resolve && mvn dependency:resolve \
    -Dares.version=$(sed -n 's:.*<ares.version>\(.*\)</ares.version>.*:\1:p' /opt/artemis-java-template/pom.xml) \
    -Dguava.version=$(sed -n 's:.*<guava.version>\(.*\)</guava.version>.*:\1:p' /opt/artemis-java-template/pom.xml) \
    -Dcommons-beanutils.version=$(sed -n 's:.*<commons-beanutils.version>\(.*\)</commons-beanutils.version>.*:\1:p' /opt/artemis-java-template/pom.xml)

RUN cd /opt/artemis-java-template && pwd && ls -la && ./gradlew clean test check -x test publishToMavenLocal resolveAresDependencies && ./gradlew --version && ./gradlew --stop

RUN rm -rf /opt/artemis-java-template /opt/ares-resolve

CMD ["mvn"]
