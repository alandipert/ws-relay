#!/usr/bin/env bash

set -e

_mktemp() {
  case $(uname -s) in
    Darwin) mktemp -t temp ;;
    Linux) mktemp ;;
    *) (>&2 echo "Unknown system '$(uname -s)', don't now how to _mktemp");
       exit 1 ;;
  esac
}

_mkfifos() {
	FIFO_IN=$(_mktemp)
	FIFO_OUT=$(_mktemp)
	rm -f $FIFO_IN $FIFO_OUT
	mkfifo $FIFO_IN $FIFO_OUT
}

_cleanup() {
	kill $(jobs -p)
	rm -f $FIFO_IN $FIFO_OUT
}

echo ">> Listening at http://localhost:8081"
echo ">> Type Javascript code followed by a newline to evaluate it in the browser and print its return value."
echo

_mkfifos
websocketd --staticdir=$PWD --port=8081 ./relay.rb $FIFO_IN $FIFO_OUT &
trap _cleanup EXIT

cat $FIFO_OUT &
cat - > $FIFO_IN
