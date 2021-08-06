#!/bin/bash

# Create docker image containing debug tools and scripts
# can be used with `kubectl debug`

# @author  Fabrice Jammes

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. $DIR/env.build.sh

# CACHE_OPT="--no-cache"

go build main.go
docker image build --tag "$IMAGE" "$DIR"
docker push "$IMAGE"
