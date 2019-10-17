#!/bin/bash -e

# figure out the snap architecture lib name
case $SNAP_ARCH in
    amd64)
        archLibName="x86_64-linux-gnu"
        ;;
    armhf)
        archLibName="arm-linux-gnueabihf"
        ;;
    arm64)
        archLibName="aarch64-linux-gnu"
        ;;
    i386)
        archLibName="i386-linux-gnu"
        ;;
    *)
        # unsupported or unknown architecture
        exit 1
        ;;
esac

# get the perl version
PERL_VERSION=$(perl -version | grep -Po '\(v\K([^\)]*)')

# perl lib paths are needed for some rocks that kong loads through luarocks dependencies
PERL5LIB="$PERL5LIB:$SNAP/usr/lib/$archLibName/perl/$PERL_VERSION"
PERL5LIB="$PERL5LIB:$SNAP/usr/share/perl/$PERL_VERSION"
PERL5LIB="$PERL5LIB:$SNAP/usr/share/perl5"

export PERL5LIB

exec "$@"
