#!/bin/sh

# set ruby GC parameters
RUBY_HEAP_MIN_SLOTS=600000
RUBY_FREE_MIN=200000
RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_HEAP_MIN_SLOTS RUBY_FREE_MIN RUBY_GC_MALLOC_LIMIT

state_file="log/puma.state"

case "$1" in
  start)
    bundle exec puma -C config/puma.rb
    ;;
  stop)
    bundle exec pumactl -S $state_file stop
    ;;
  restart)
    bundle exec pumactl -S $state_file restart
    ;;
  status)
    bundle exec pumactl -S $state_file status
    ;;
  force-stop)
    bundle exec pumactl -S $state_file halt
    ;;
  *)
    echo $"Usage: $0 {start|stop|force-stop|restart|status}"
    ;;
esac