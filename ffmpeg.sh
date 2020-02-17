#!/usr/bin/env bash
NAME=ffmpeg
PORT=8080

if [ ! "$(docker ps -q -f name=$NAME)" ]; then

    if [ "$(docker ps -aq -f status=exited -f name=$NAME)" ]; then
        echo "Starting existing $NAME container..."
        docker start $NAME
        sleep $WAIT
        open http://localhost:$PORT
    else
        echo "Starting new $NAME container..."
        docker run                                    \
            -d                                        \
            --name $NAME                              \
            -p $PORT:8080                             \
            ivonet/$NAME
    fi
else
    echo "Stopping $NAME..."
    docker stop $NAME
fi

