#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(dirname $DIR)
CACHELINK_DIR=$DIR/node_modules/cachelink-service

cd $DIR

# Install NPM dependencies
docker run -it --rm \
	--name cachelink_npm_install \
	-v $DIR:/tests \
	-w /tests \
	node:6 \
	npm install

# Ensure build directory exists.
if [ ! -d "$CACHELINK_DIR/build" ]; then
  echo "Build directory ($CACHELINK_DIR/build) does not exist, cannot start redis.";
  exit 1;
fi

# Start redis single and redis cluster instances.
$CACHELINK_DIR/test/env/start-single.sh
$CACHELINK_DIR/test/env/start-cluster.sh

# Run cachelink instances.
docker-compose stop
docker-compose up -d