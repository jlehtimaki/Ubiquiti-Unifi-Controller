FROM ubuntu:18.04

MAINTAINER joonas.lehtimaki@gmail.com

ENV BASEDIR=/usr/lib/unifi \
  DATADIR=/var/lib/unifi \
  RUNDIR=/var/run/unifi \
  LOGDIR=/var/log/unifi \
  JVM_MAX_HEAP_SIZE=1024M \
  JVM_INIT_HEAP_SIZE=1024M \
  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update
RUN apt-get install -y apt-utils wget gnupg haveged

RUN apt install -y openjdk-8-jre-headless

# Mongodb
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add - \
&& echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
&& apt-get update && apt-get install -y mongodb-org

#unifi install
RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50 \ 
  && echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" |  tee /etc/apt/sources.list.d/ubiquiti.list \
  && apt-get update && apt-get -q -y install unifi


RUN /etc/init.d/haveged restart
RUN /etc/init.d/unifi restart

CMD /etc/init.d/unifi start && tail -f /dev/null
EXPOSE 6789/tcp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 3478/udp
