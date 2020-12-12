FROM ubuntu:20.10

MAINTAINER Stephan Krusche <krusche@in.tum.de>

RUN apt-get update && apt-get install -y locales

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    git \
    maven \
 && rm -rf /var/lib/apt/lists/*
 
RUN mkdir -p /opt/openjdk \
 && cd /opt/openjdk \
 && curl -L https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz | tar zx --strip-components=1 \
 && test -f /opt/openjdk/bin/java \
 && test -f /opt/openjdk/bin/javac

ENV JAVA_HOME /opt/openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV M2_HOME /usr/share/maven


ADD artemis-java-template /opt/artemis-java-template

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN rm -rf /opt/artemis-java-template


CMD ["mvn"]
