#!/bin/bash

killbg() {
  for p in "${pids[@]}" ; do
    kill "$p";
  done
}

pkill livereload

trap killbg EXIT

pids=()
livereload -o 1 --host 0.0.0.0 --wait 2 --target ./doc/get-started.html ./doc &
pids+=($!)

inotifywait --monitor --recursive --event modify ./lib ./documentation mix.exs | while read; do
  mix docs --formatter html
done
