FROM alpine:3.11

RUN	apk add --no-cache bash postfix rsyslog 
ADD start.sh /start.sh
EXPOSE 25/tcp 587/tcp
CMD	[ "/start.sh" ]
