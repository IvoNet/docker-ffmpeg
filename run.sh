#!/usr/bin/env bash
NAME=ffmpeg
PORT=8080
if [ ! -z $1 ]; then
   EP="--entrypoint bash"
fi

docker run          \
    -it             \
    --rm            \
    --name $NAME    \
    -p ${PORT}:8080 \
    $EP             \
    ivonet/$NAME

