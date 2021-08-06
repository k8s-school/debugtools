#!/usr/bin/env bash

# Build and push debugtools image release to docker hub

# @author  Fabrice Jammes, IN2P3

set -euo pipefail

releasetag=""

DIR=$(cd "$(dirname "$0")"; pwd -P)

usage() {
  cat << EOD

Usage: `basename $0` [options] release-tag

  Available options:
    -h          this message

- Release tag template i.j.k, i,j and k are integers
EOD
}

# get the options
while getopts h c ; do
    case $c in
	    h) usage ; exit 0 ;;
	    \?) usage ; exit 2 ;;
    esac
done
shift `expr $OPTIND - 1`

if [ $# -ne 1 ] ; then
    usage
    exit 2
fi

releasetag="$1"
. "$DIR/env.build.sh"

echo "-- Run command below to publish the release:"
echo "git add . &&  git commit -m \"Release $releasetag\" && git tag -a \"$releasetag\" -m \"Version $releasetag\" && git push --tag"
echo "-- Rebuild and push debugtools image with release tag:"
echo "./build.sh"
