[![Snap Status](https://build.snapcraft.io/badge/anonymouse64/kong-snap.svg)](https://build.snapcraft.io/user/anonymouse64/kong-snap)
# Kong snap packaging

[![snap store badge](https://raw.githubusercontent.com/snapcore/snap-store-badges/master/EN/%5BEN%5D-snap-store-black-uneditable.png)](https://snapcraft.io/kong)


This repo contains necessary wrappers and config files to package and publish Kong as a snap.

Note that the snap bundles Cassandra as a database provider for Kong, as Postgres doesn't work well inside a snap. Cassandra automatically runs in the background as a service in the snap. You can disable cassandra with:

```bash
$ sudo snap stop --disable kong.cassandra
```

This code is released under the same license as the kong project: https://github.com/Kong/kong
