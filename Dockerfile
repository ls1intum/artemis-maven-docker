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

# Resolve Ares 2 on its own (including its transitive dependencies): Artemis exercises resolve exactly this tree, which
# differs from the one above where the template pins other versions of the same artifacts (e.g. commons-lang3, objenesis)
RUN cd /opt/artemis-java-template && mvn dependency:get -Dartifact=de.tum.cit.ase:ares:$(sed -n 's:.*<ares.version>\(.*\)</ares.version>.*:\1:p' pom.xml)

RUN cd /opt/artemis-java-template && pwd && ls -la && ./gradlew clean test check -x test publishToMavenLocal resolveAresDependencies && ./gradlew --version && ./gradlew --stop

RUN rm -rf /opt/artemis-java-template

CMD ["mvn"]
