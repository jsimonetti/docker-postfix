#!/bin/bash
cat <<End-of-message > /etc/rsyslog.conf
\$ModLoad imuxsock
\$template noTimestampFormat,"%syslogtag%%msg%\n"
\$ActionFileDefaultTemplate noTimestampFormat
*.*;auth,authpriv.none /dev/stdout
End-of-message

rm -f /var/run/rsyslogd.pid
chown -R postfix:postfix /var/lib/postfix
chown -R postfix:root /var/spool/postfix/{active,bounce,corrupt,defer,deferred,flush,hold,incoming,private,saved,trace}
chown -R postfix:postdrop /var/spool/postfix/{maildrop,public}
chown -R root:postfix /var/spool/postfix/pid

BACKGROUND_TASKS=()

/usr/sbin/rsyslogd -n &
RSYSLOG=$!
BACKGROUND_TASKS+=($RSYSLOG)

postfix start &
POSTFIX=`ps ux | awk '/master/ && !/awk/ {print $1}'`
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
