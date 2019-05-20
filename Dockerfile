FROM jsimonetti/alpine-edge

RUN	apk add --no-cache postfix

CMD	[ "/usr/sbin/postfix", "start-fg" ]
