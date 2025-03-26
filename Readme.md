# Peertube Remote Runner 
This repo is intended to provide a [peertube remote-runner](https://docs.joinpeertube.org/admin/remote-runners) Docker image with 
* the ability to overwrite the `ffmpeg` quality settings
* Transcription via [Whisper](https://github.com/openai/whisper)

## Motivation
In case of using Remote-runners, the `ffmpeg` settings cannot (yet) be adjusted from the server. In my case this resulted in very strong compression with rather low quality. Furthermore the CPU limit was set to 2 whereas I wanted the runner to use whatever it could get.

There are a couple of feature requests in the [Peertub Repo](https://github.com/Chocobozzz/PeerTube) about it, like 
* https://github.com/Chocobozzz/PeerTube/issues/6042
* https://github.com/Chocobozzz/PeerTube/issues/5858

Unfortunately I'm not so much in the Peertube code so that I could make the according changes in the runner code (yet).


## Solution
The [comment](https://github.com/Chocobozzz/PeerTube/issues/5858#issuecomment-1987772950) about overriding the `ffmpeg` command led to this solution to change the process call to a [`ffmpeg-script`](blob/develop/ffmpeg) without touching the peertube code itself.

I tested GPU support as well but skipped it when it turned a bit too cumbersome.

## Usage
* Enable remote runners in your Peertube instance and get a runner registration token ([follow the documentation](https://docs.joinpeertube.org/admin/remote-runners#enable-remote-runners))
* __Optional__: change the properties `maxrate` and `bufsize` values in [`ffmpeg`](blob/develop/ffmpeg). I went with recommendations from [Youtube](https://support.google.com/youtube/answer/1722171).
* __Optional__: change the encoding preset "-preset slow" in [`ffmpeg`](blob/develop/ffmpeg). See possible values in the [H.264 wiki](https://trac.ffmpeg.org/wiki/Encode/H.264#Preset). Mind the impact to processing time [mentioned in the wiki](https://trac.ffmpeg.org/wiki/Encode/H.264#Howdothedifferentpresetsinfluenceencodingtime)!
* Build the image: `docker build -t peertube-runner-whisper:latest .`
* Start the container: 
```
    docker run --rm -it ^
        -e URL=https://your.peertube-instance.tld ^
        -e TOKEN=ptrrt-the-token ^
        -e NAME=MyRemoteRunner ^
        peertube-runner-whisper:latest
```

