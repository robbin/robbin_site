#!/bin/sh

# set ruby GC parameters
RUBY_HEAP_MIN_SLOTS=600000
RUBY_FREE_MIN=200000
RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_HEAP_MIN_SLOTS RUBY_FREE_MIN RUBY_GC_MALLOC_LIMIT

pid="log/rainbows.pid"

case "$1" in
  start)
    bundle exec rainbows -c config/rainbows.rb -E production -D
    ;;
  stop)
    kill -QUIT `cat $pid`
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  reload)
    kill -USR2 `cat $pid`
    ;;
  force-stop)
    kill -INT `cat $pid`
    ;;
  shutdown-workers)
    kill -WINCH `cat $pid`
    ;;
  increment-worker)
    kill -TTIN `cat $pid`
    ;;
  decrement-worker)
    kill -TTOU `cat $pid`
    ;;
  logrotate)
    kill -USR1 `cat $pid`
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|reload|force-stop|shutdown-workers|increment-worker|decrement-worker|logrotate|}"
    ;;
esac