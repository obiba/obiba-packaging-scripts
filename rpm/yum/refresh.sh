#!/bin/bash

BASEDIR=$(readlink -f $(dirname $0))
REPODIR="/nfs/obiba/rpm"

# Delete unstable releases older than 3 days except release candidates
find $REPODIR/unstable -mtime +3 | grep -v html | grep -iv '\-RC[0-9]\.' | xargs rm -f

if [ -e $REPODIR/unstable/repodata/repomd.xml ]; then
FOUND=`find $REPODIR -newermm $REPODIR/unstable/repodata/repomd.xml`
else
FOUND="yes"
fi

if [ ! -z "$FOUND" ]; then
cd $REPODIR
for d in `echo unstable stable`;
do
  PKGDIR=$REPODIR/$d
  rm -rf $PKGDIR/repodata
  $BASEDIR/rpmsign.expect $PKGDIR/*.rpm
  createrepo $PKGDIR
done
fi
