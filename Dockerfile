FROM aler9/rtsp-simple-server

# Work in progress, we will need to add some additional libraries to make this work.
# Depending on the arguments we might also need to tweak the rtsp-simple-server config file.
# https://github.com/aler9/rtsp-simple-server#publish-to-the-server

# Opened an issue for this -> https://github.com/aler9/rtsp-simple-server/issues/1010
RUN git clone https://git.libcamera.org/libcamera/libcamera.git && \
    cd libcamera && \
    meson build && \
    ninja -C build install