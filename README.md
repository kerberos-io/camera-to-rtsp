# Camera to RTSP

The goal of this project is convert any camera to a RTSP stream, which then can be handled by an agent, for example the [Kerberos Agent](https://github.com/kerberos-io/agent).

This project is initiated due to following issue [New Kerberos Agent: Plans for USBCamera and Raspberry PI camera #35
](https://github.com/kerberos-io/agent/issues/35). Read more at the previous link to understand better the context.

## Side car

The approach we are following is to convert the camera stream of an USB, RPi or any other camera into a h264 encoded stream. Once done you'll be able to integrate that stream with the [Kerberos Agent](https://github.com/kerberos-io/agent).

So to conclude next to running the Kerberos Agent container, you'll need to run a side car container which will translate your camera specific stream into a readable h264 RTSP connection.

## RTSP Simple Server

We are leveraging the [rtsp-simple-server](https://github.com/aler9/rtsp-simple-server) from [@alert9](https://github.com/aler9) to run as a side car container. The project supports the majority of plugins for USB and RPi cameras, and allows us to avoid supporting and maintaining those integrations.

To run the side container run following Docker command.

    docker run --rm -it --network=host -v $PWD/rtsp-simple-server.yml:/rtsp-simple-server.yml aler9/rtsp-simple-server

Depending on which camera you are using, you might need to tweak the configuration, `rtsp-simple-server.yml`, to meet your needs. You could require additional settings if you are using a Raspberry Pi or USB camera.

### Raspberry Pi camera

To activate the Raspberry Pi camera stream, make sure [to review the Raspberry Pi camera section](https://github.com/aler9/rtsp-simple-server#from-a-raspberry-pi-camera).

You'll find the relevant configuration settings (hflip, vlip, etc) in [the sample `rtsp-simple-server.yml`](https://github.com/aler9/rtsp-simple-server/blob/main/rtsp-simple-server.yml#L230) configuration file.


    docker run --rm -it \
    --network=host \
    --privileged \
    --tmpfs /dev/shm:exec \
    -v /usr:/usr:ro \
    -v /lib:/lib:ro \
    -v /run/udev:/run/udev:ro \
    -e RTSP_PATHS_CAM_SOURCE=rpiCamera \
    aler9/rtsp-simple-server


### USB camera

The same should be done if you are using a "simple" USB camera. Please [follow the `webcam` section](https://github.com/aler9/rtsp-simple-server#from-a-webcam) to understand which settings to enabled to forward a `/dev/video` device.

In the case of webcam, ffmpeg will be used to encode the camera to a h264 stream. Adapt the `rtsp-simple-server.yml` as following:

    paths:
    cam:
        runOnInit: ffmpeg -f v4l2 -i /dev/video0 -pix_fmt yuv420p -preset ultrafast -b:v 600k -f rtsp rtsp://localhost:$RTSP_PORT/$RTSP_PATH
        runOnInitRestart: yes

Run the container with the configuration as following.

    docker run --rm -it --network=host -v $PWD/rtsp-simple-server.yml:/rtsp-simple-server.yml aler9/rtsp-simple-server





