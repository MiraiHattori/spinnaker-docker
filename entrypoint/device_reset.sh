#!/bin/bash
set -e

# setup ros environment
source "/home/leus/catkin_ws/devel/setup.bash"
rosrun pointgrey_camera_driver device_reset
exit
