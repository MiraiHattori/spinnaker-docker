#!/usr/bin/env bash

source /opt/ros/kinetic/setup.bash
rossetip

#usb_arg=`python3 generate_usb_arg.py`
#echo $usb_arg


sudo docker run -it --rm --privileged \
    --net=host \
    -w="/home/pointgrey" \
    --net="host" \
    --env="ROS_IP" \
    --env="ROS_HOSTNAME" \
future731/pointgrey_test "$@"
