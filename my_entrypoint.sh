#!/bin/bash
set -e

# setup ros environment
source "/home/pointgrey/catkin_ws/devel/setup.bash"
roslaunch ball_orbit_estimator stereo.launch
exec "$@"
