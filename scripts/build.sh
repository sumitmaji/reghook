#!/usr/bin/env bash
[[ "TRACE" ]] && set -x

source ./scripts/config
: ${BUILD_PATH:=/tmp}

NUMBER=$[ ( $RANDOM % 100 )  + 1 ]
mkdir /$BUILD_PATH/$NUMBER
pushd /$BUILD_PATH/$NUMBER
git clone -b $BRANCH $URL/${REP}.git
pushd $REP
source config
helm del --purge $RELEASE_NAME
helm install $PATH_TO_CHART --name $RELEASE_NAME
popd
popd
