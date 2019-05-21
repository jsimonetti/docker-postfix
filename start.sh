#!/bin/bash
cat <<End-of-message > /etc/rsyslog.conf
\$ModLoad imuxsock
\$template noTimestampFormat,"%syslogtag%%msg%\n"
\$ActionFileDefaultTemplate noTimestampFormat
*.*;auth,authpriv.none /dev/stdout
End-of-message

rm -f /var/run/rsyslogd.pid

BACKGROUND_TASKS=()

/usr/sbin/rsyslogd -n &
RSYSLOG=$!
BACKGROUND_TASKS+=($RSYSLOG)

/usr/lib/postfix/sbin/master &
POSTFIX=$!
BACKGROUND_TASKS+=($POSTFIX)

while true; do
  for bg_task in ${BACKGROUND_TASKS[*]}; do
    if ! kill -0 ${bg_task} 1>&2; then
      echo "Worker ${bg_task} died, stopping container waiting for respawn... (Postfix: $POSTFIX, Rsyslog: $RSYSLOG)"
      exit 1
    fi
    sleep 10
  done
done
