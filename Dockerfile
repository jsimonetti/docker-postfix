FROM jsimonetti/alpine-edge:latest

RUN	apk add --no-cache bash postfix rsyslog 
ADD start.sh /start.sh
EXPOSE 25/tcp 587/tcp
CMD	[ "/start.sh" ]
