#!/usr/bin/bash -e

SUPERVISORD=/usr/local/bin/supervisord
PIDFILE=/tmp/supervisord.pid
OPTS="-c /usr/local/supervisord.conf"

test -x $SUPERVISORD || exit 0

. /lib/lsb/init-functions

export PATH="${PATH:+$PATH:}/usr/local/bin:/usr/sbin:/sbin"

case "$1" in
  start)
    log_begin_msg "Starting Supervisor daemon manager..."
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $SUPERVISORD -- $OPTS || log_end_msg 1
    log_end_msg 0
    ;;
  stop)
    log_begin_msg "Stopping Supervisor daemon manager..."
    start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE || log_end_msg 1
    log_end_msg 0
    ;;

  restart|reload|force-reload)
    log_begin_msg "Restarting Supervisor daemon manager..."
    start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile $PIDFILE
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $SUPERVISORD -- $OPTS || log_end_msg 1
    log_end_msg 0
    ;;

  *)
    log_success_msg "Usage: /etc/init.d/supervisor
{start|stop|reload|force-reload|restart}"
    exit 1
esac

exit 0
