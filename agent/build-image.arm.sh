#!/bin/bash
set -ex

cd $(dirname $0)

. ../.docker-env.arm || echo "Need to source .docker-env.arm to access Docker on ARM"

if [ -z "$TAG" ]; then
    TAG=$(grep RANCHER_AGENT_IMAGE Dockerfile.arm | cut -f2 -d:)
fi

IMAGE=rancher/agent:${TAG}

echo Building $IMAGE
docker build -t ${IMAGE} -f Dockerfile.arm .
