#!/usr/bin/env bash

source /opt/ros/${ROS_DISTRO}/setup.bash

usb_arg=`python3 generate_usb_arg.py`
echo $usb_arg

if [ "$DISPLAY" == "localhost:10.0" ]; then
    sudo docker run -it --rm \
        --net=host \
        --env="DISPLAY" \
        --volume="${HOME}/.Xauthority:/root/.Xauthority:rw" \
        -w="/home/leus" \
        --net="host" \
        --env="ROS_MASTER_URI" \
        ${usb_arg} \
    future731/ball_orbit_estimator "$@"
else
    xhost +local:
    sudo docker run -it --rm \
        --net=host \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -w="/home/leus" \
        --net="host" \
        --env="ROS_MASTER_URI" \
        ${usb_arg} \
    future731/ball_orbit_estimator "$@"
fi

