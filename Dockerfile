FROM maven:3.6.3-openjdk-15

MAINTAINER Stephan Krusche <krusche@in.tum.de>

ADD artemis-java-template /opt/artemis-java-template

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN rm -rf /opt/artemis-java-template

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

CMD ["mvn"]