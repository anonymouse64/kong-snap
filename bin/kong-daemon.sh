#!/bin/bash -e

# run kong migrations up to bootstrap the cassandra database
# note that sometimes cassandra can be in a "starting up" state, etc.
# and in this case we should just loop and keep trying
# we don't implement a timeout here because systemd will kill us if we 
# don't succeed in 15 minutes (or whatever the configured stop-timeout is)
until kong migrations bootstrap --conf "$KONG_CONF"; do
    sleep 5
done

# # handle additional kong migrations from previous kong versions
# set +e
# kong migrations list --conf "$KONG_CONF"
# code=$?
# set -e
# if [ $code -eq 5 ]; then
#   kong migrations up --conf "$KONG_CONF"
#   kong migrations finish --conf "$KONG_CONF"
# fi

# now start kong normally
kong start --conf "$KONG_CONF" --v
