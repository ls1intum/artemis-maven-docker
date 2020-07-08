FROM maven:3.6.3-jdk-14

MAINTAINER Stephan Krusche <krusche@in.tum.de>

ADD artemis-java-template /opt/artemis-java-template

RUN yum -y install git

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test

RUN rm -rf /opt/artemis-java-template

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

CMD ["mvn"]