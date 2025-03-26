# Peertube Remote Runner 
This repo is intended to provide a [peertube remote-runner](https://docs.joinpeertube.org/admin/remote-runners) Docker image with 
* the ability to overwrite the `ffmpeg` settings
* Captioning via Whisper (yet untested)

## Problem
In case of using Remote-runners, the `ffmpeg` settings cannot (yet) be adjusted from the server. In my case this resulted in very strong compression with rather low quality. Further more the CPU limit was set to 2 whereas I wanted the runner to use whatever it could get.

There are a couple of feature requests in the [Peertub Repo](https://github.com/Chocobozzz/PeerTube), like 
* https://github.com/Chocobozzz/PeerTube/issues/6042
* https://github.com/Chocobozzz/PeerTube/issues/5858


## Solution
Unfortunately I am not enough into TypeScript so that I could contribute the according changes. But the [comment](https://github.com/Chocobozzz/PeerTube/issues/5858#issuecomment-1987772950) about overriding the `ffmpeg` command led to this solution to alter the command call from Peertube without touching the peertube code.

## Usage
* enable remote runners in your Peertube instance and get a runner registration token ([follow the documentation](https://docs.joinpeertube.org/admin/remote-runners#enable-remote-runners))
* Optional: change the properties `maxrate` and `bufsize` values in [`ffmpeg`](blob/develop/ffmpeg)
* build the image: `docker build -t peertube-runner-whisper:latest .`
* start the container: 
```
    docker run --rm -it ^
        -e URL=https://your.peertube-instance.tld ^
        -e TOKEN=ptrrt-the-token ^
        -e NAME=MyRemoteRunner ^
        peertube-runner-whisper:latest
```

