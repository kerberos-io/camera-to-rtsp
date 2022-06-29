# Camera to RTSP

The goal of this project is convert any camera to a RTSP stream, which then can be handled by an agent, for example the [Kerberos Agent](https://github.com/kerberos-io/agent).

This project is initiated due to following issue [New Kerberos Agent: Plans for USBCamera and Raspberry PI camera #35
](https://github.com/kerberos-io/agent/issues/35). Read more at the previous link to understand better the context.

## Work in progress

The idea of this container is that a camera stream `/dev/video0` or others are converted to a RTSP streaming using the [rtsp-simple-server project)[https://github.com/aler9/rtsp-simple-server]. 

As of now we have the idea, to have a container with its base pointing to `aler9/rtsp-simple-server` and by pass through different arguments `type`, `deviceid` and/or others we would be able to chance the relevant video device to RTSP stream. 

As mentioned [in this issue](https://github.com/kerberos-io/agent/issues/35) we already have a working approach but this definetly not something for production (doesn't have recover or healthchecks) and it requires seperate commands to be executed:

1. Start the `rtsp-simple-server` container:

    docker run -d --network=host aler9/rtsp-simple-server

2. Depending on the camera, inject the camera stream using the correct library.

For a USB camera

    ffmpeg -f v4l2 -i /dev/video1 -preset ultrafast -b:v 600k  -c:v libx264 -f rtsp rtsp://localhost:8554/mystream

For a Raspberry Pi camera

    libcamera-vid -t 0 --inline -o - | ffmpeg -i pipe: -c copy -f rtsp rtsp://localhost:8554/mystream


## Finaly result

We hope to have some configurable container that would fix previously mentioned work in progress. Any work work should go in the Dockerfile mentioned in this repo.