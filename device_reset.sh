#!/usr/bin/env bash

source /opt/ros/${ROS_DISTRO}/setup.bash
# execute .bashrc if it has "source */setup.bash"
if [ ! -z "`cat ${HOME}/.bashrc | grep "^source .*setup\.bash *$"`" ]; then source ${HOME}/.bashrc; fi

usb_arg=`python3 ./util/generate_usb_arg.py`
echo $usb_arg

sudo docker run -it --rm \
    -w="/home/leus" \
    --net="host" \
    --env ROS_MASTER_URI="${ROS_MASTER_URI}" \
    ${usb_arg} \
future731/spinnaker_device_reset "$@"
