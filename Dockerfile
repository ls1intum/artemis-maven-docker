FROM maven:3.6.3-openjdk-15

MAINTAINER Stephan Krusche <krusche@in.tum.de>

ENV gitversion=2.29.2

#install git
RUN microdnf install wget 
RUN microdnf install make 
RUN microdnf install curl-devel 
RUN microdnf install expat-devel 
RUN microdnf install gettext-devel 
RUN microdnf install openssl-devel 
RUN microdnf install zlib-devel
RUN microdnf install gcc
RUN microdnf install perl-ExtUtils-MakeMaker

RUN cd /usr/src && wget https://www.kernel.org/pub/software/scm/git/git-${gitversion}.tar.gz && tar xzf git-${gitversion}.tar.gz && cd git-${gitversion} && make prefix=/usr/local all && make prefix=/usr/local install && git --version && rm -rf /usr/src/git-${gitversion}.tar.gz && rm -rf /usr/src/git-${gitversion}

ADD artemis-java-template /opt/artemis-java-template

RUN cd /opt/artemis-java-template && pwd && ls -la && mvn clean install test && mvn spotbugs:spotbugs checkstyle:checkstyle pmd:pmd

RUN rm -rf /opt/artemis-java-template

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

CMD ["mvn"]
