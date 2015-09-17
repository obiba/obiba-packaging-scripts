#!/bin/bash

REPODIR="/nfs/obiba/pkg"

# Delete unstable releases older than 3 days except release candidates
find $REPODIR/unstable -mtime +3 | grep -v html | grep -iv '\-RC[0-9]\.' | xargs rm -f

if [ -e $REPODIR/unstable/Release ]; then
FOUND=`find $REPODIR -newermm $REPODIR/unstable/Release`
else
FOUND="yes"
fi

if [ ! -z "$FOUND" ]; then
cd $REPODIR
apt-ftparchive generate $REPODIR/.apt/apt.conf
for d in `echo unstable stable`;
do
  PKGDIR=$REPODIR/$d
  rm $PKGDIR/Release $PKGDIR/Release.gpg
  apt-ftparchive -c $REPODIR/.apt/$d-release.conf release $PKGDIR > $PKGDIR/Release
  gpg -abs -o $PKGDIR/Release.gpg $PKGDIR/Release
done
fi
