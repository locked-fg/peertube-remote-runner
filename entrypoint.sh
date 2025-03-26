#!/bin/bash
if [ -n "$NAME" ]; then
    NAME="$NAME"_$(uname -n)
else
    NAME=$(uname -n)
fi

cleanup() {
    echo "Container is stopping, removing runner '$NAME'..."
    peertube-runner unregister --url $URL --runner-name $NAME
	# and don't forget to kill it now explicitly
    kill $SERVER_PID
	wait $SERVER_PID 2>/dev/null
}
trap cleanup SIGINT SIGTERM

# Start the runner in other processgroup so that a SIGINT SIGTERM 
# doesn't kill the runner before we can unregister
echo "Starting runner $NAME"...
setsid peertube-runner server &
SERVER_PID=$!

sleep 5
peertube-runner register --url $URL --registration-token $TOKEN --runner-name $NAME

wait
