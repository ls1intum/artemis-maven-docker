FROM maven:3.9.16-eclipse-temurin-25

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

RUN cd /opt/artemis-java-template && pwd && ls -la && ./gradlew clean test check -x test publishToMavenLocal && ./gradlew --version && ./gradlew --stop

RUN rm -rf /opt/artemis-java-template

# Warm up the dependency caches with the test repositories that Artemis generates for Java (Maven, Gradle) and Kotlin (Maven) exercises.
# They resolve the dependencies and plugins of Ares 2 (including its transitive versions), so that builds on Artemis do not need to download them.
ADD artemis-templates /opt/artemis-templates

RUN cd /opt/artemis-templates/java-maven && mvn -B clean test && mvn -B spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN cd /opt/artemis-templates/kotlin-maven && mvn -B clean test

RUN cd /opt/artemis-templates/java-gradle && chmod +x gradlew && ./gradlew clean test check && ./gradlew --stop

RUN rm -rf /opt/artemis-templates

CMD ["mvn"]
