FROM jsimonetti/alpine-edge:latest

RUN	apk add --no-cache bash postfix rsyslog 
ADD start.sh /start.sh
CMD	[ "/start.sh" ]
