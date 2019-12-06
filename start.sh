#!/bin/bash
NODEOS=/path/to/nodeos

DIR=$(dirname $(realpath $0))
cd "$DIR"

date
./stop.sh
timestamp=`date +%s`
$NODEOS --data-dir $DIR/data-dir --config-dir ./config-dir --disable-replay-opts --verbose-http-errors  "$@" > stdout.txt 2> logs/eos-$timestamp.log &  echo $! > nodeos.pid
rm -f eos.log
ln -s logs/eos-$timestamp.log eos.log

