[![Snap Status](https://build.snapcraft.io/badge/anonymouse64/kong-snap.svg)](https://build.snapcraft.io/user/anonymouse64/kong-snap)
# Kong snap packaging

[![snap store badge](https://raw.githubusercontent.com/snapcore/snap-store-badges/master/EN/%5BEN%5D-snap-store-black-uneditable.png)](https://snapcraft.io/kong)


This repo contains necessary wrappers and config files to package and publish Kong as a snap.

The snap currently bundles both Cassandra and PostgeSQL as possible databases to use with Kong. If you installed the snap before PostgeSQL was added to the snap, you will have Cassandra as your default, however if you install a fresh version, then you will have PostgreSQL as your database. 

Since previous versions of this snap only bundled Cassandra, to not break anyone who might have had the snap previously installed running with Cassandra, the `kong-daemon` service in the snap will continue to use Cassandra if you upgrade to the new version of the snap with PostgreSQL in it. 

To switch from using Cassandra to PostgreSQL is simple however if you desire. Run the following:

```bash
sudo snap run --shell kong -c "sed -i \"s@database = cassandra@database = postgres@\" \$SNAP_DATA/config/kong.conf"
snap stop --disable kong.cassandra
snap restart kong.kong-daemon
```

And you should be using PostgreSQL now instead of Cassandra and Cassandra should not automatically startup anymore.

**Note**: that this will only change the config file to tell Kong to use PostgreSQL, if you had important data for Kong stored in Cassandra, you will need to manually migrate that data as well. Consult the Kong docs for more information on how to do this.

This code is released under the same license as the kong project: https://github.com/Kong/kong
