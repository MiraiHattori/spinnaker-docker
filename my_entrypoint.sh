#!/bin/bash
set -e

# setup ros environment
source "/home/pointgrey/catkin_ws/devel/setup.bash"
roslaunch pointgrey_camera_driver stereo.launch
exec "$@"
