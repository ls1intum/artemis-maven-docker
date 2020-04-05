FROM maven:3.6.3-jdk-14

MAINTAINER Stephan Krusche <krusche@in.tum.de>

RUN mkdir /opt/template

ADD pom.xml /opt/template/pom.xml

RUN cd /opt/template && pwd && ls -la && mvn install

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

CMD ["mvn"]