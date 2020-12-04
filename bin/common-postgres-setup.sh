#!/bin/bash -e

# get the values of $SNAP_DATA and $SNAP using the current symlink instead of
# the default behavior which has the revision hard-coded, which breaks after
# a refresh
SNAP_DATA_CURRENT=${SNAP_DATA/%$SNAP_REVISION/current}
SNAP_CURRENT=${SNAP/%$SNAP_REVISION/current}

# setup postgres db config file with env vars replaced
if [ ! -f "$SNAP_DATA/etc/postgresql/10/main/postgresql.conf" ]; then
    mkdir -p "$SNAP_DATA/etc/postgresql/10/main"
    cp "$SNAP/etc/postgresql/10/main/postgresql.conf" "$SNAP_DATA/etc/postgresql/10/main/postgresql.conf"
    # do replacement of the $SNAP, $SNAP_DATA, $SNAP_COMMON environment variables in the config files
    sed -i -e "s@\$SNAP_COMMON@$SNAP_COMMON@g" \
        -e "s@\$SNAP_DATA@$SNAP_DATA_CURRENT@g" \
        -e "s@\$SNAP@$SNAP_CURRENT@g" \
        "$SNAP_DATA/etc/postgresql/10/main/postgresql.conf"
fi

# ensure the postgres data directory exists and is owned by snap_daemon
mkdir -p "$SNAP_DATA/postgresql" 
chown -R snap_daemon:snap_daemon "$SNAP_DATA/postgresql" 

# setup the postgres data directory
$SNAP/bin/setpriv-snap_daemon.sh "$SNAP/usr/lib/postgresql/10/bin/initdb" -D "$SNAP_DATA/postgresql/10/main"

# ensure the sockets dir exists and is properly owned
mkdir -p "$SNAP_COMMON/sockets"
chown -R snap_daemon:snap_daemon "$SNAP_COMMON/sockets" 

# start postgres up and wait a bit for it
snapctl start --enable "$SNAP_NAME.postgres"
sleep 2

# add a kong user and database in postgres - note we have to run these through
# the perl5lib-launch scripts to setup env vars properly
$SNAP/bin/setpriv-snap_daemon.sh "$SNAP/bin/perl5lib-launch.sh" "$SNAP/usr/bin/createuser" kong
$SNAP/bin/setpriv-snap_daemon.sh "$SNAP/bin/perl5lib-launch.sh" "$SNAP/usr/bin/createdb" kong

