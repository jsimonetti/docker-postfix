FROM debian:stretch-slim

#RUN	apk add --no-cache bash postfix rsyslog 
ENV	DEBIAN_FRONTEND noninteractive
RUN	apt-get update -q --fix-missing && \
	apt-get -y upgrade && \
	apt-get -y install postfix rsyslog lsb-release wget gnupg && \
	wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \
	echo "deb [arch=amd64] http://rspamd.com/apt-stable/ stretch main" > /etc/apt/sources.list.d/rspamd.list && \
	apt-get update && \
	apt-get -y --no-install-recommends install rspamd

ADD start.sh /start.sh
CMD	[ "/start.sh" ]
