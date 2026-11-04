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

# detekt is the static code analysis tool of Kotlin exercises. Artemis runs it as `detekt` and reads its SARIF report.
ARG DETEKT_VERSION=1.23.8
ARG DETEKT_SHA256=3afe89a11120303c73c9bdda3d8fe558dd9070a6937d27819ddc04b275381245
RUN mkdir -p /opt/detekt \
    && curl -fsSL -o /opt/detekt/detekt-cli-all.jar "https://repo1.maven.org/maven2/io/gitlab/arturbosch/detekt/detekt-cli/${DETEKT_VERSION}/detekt-cli-${DETEKT_VERSION}-all.jar" \
    && echo "${DETEKT_SHA256}  /opt/detekt/detekt-cli-all.jar" | sha256sum -c -
COPY detekt /usr/local/bin/detekt
RUN chmod +x /usr/local/bin/detekt && detekt --version

CMD ["mvn"]
