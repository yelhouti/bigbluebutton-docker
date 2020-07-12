FROM ubuntu:18.04
MAINTAINER ffdixon@bigbluebutton.org

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && apt-get install -y software-properties-common language-pack-en wget apt-utils
RUN update-locale LANG=en_US.UTF-8

# install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# install dev helpers
# RUN apt-get install -y  tcpdump telnet htop vim

# -- Install Dependencies
RUN (echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections) \
    && apt-get install -y supervisor apt-transport-https equivs libreoffice haveged ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea fonts-noto net-tools 

# bbb repo & packages
RUN LC_CTYPE=C.UTF-8 add-apt-repository ppa:bigbluebutton/support
RUN sh -c 'wget https://packages-eu.bigbluebutton.org/repo/bigbluebutton.asc -O- | apt-key add -' \
    && sh -c 'echo "deb https://ubuntu.bigbluebutton.org/bionic-230-dev bigbluebutton-bionic main" > /etc/apt/sources.list.d/bigbluebutton.list'

# create dummy packages to satisfy dependencies
RUN equivs-control redis-server.control \
    && sed -i 's/<package name; defaults to equivs-dummy>/redis-server/g' redis-server.control \
    && equivs-build redis-server.control \
    && dpkg -i /*.deb \
    && rm /*.deb

RUN apt-get update && apt-get install -y bbb-web bbb-apps-akka bbb-transcode-akka

# -- copy configuration files
COPY bigbluebutton.yml /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml

COPY web/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties.tmpl
COPY web/turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml.tmpl

COPY bbb-apps-akka/application.conf /usr/share/bbb-apps-akka/conf/application.conf.tmpl
COPY bbb-transcode-akka/application.conf /etc/bbb-transcode-akka/application.conf
COPY web-run.sh /usr/share/bbb-web/run-prod.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

COPY prefix-log /usr/local/bin/prefix-log
RUN mkdir -p /var/log/supervisor

ENTRYPOINT ["/entrypoint.sh"]
CMD []

