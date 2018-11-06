#!/bin/bash
set -e

# setup ros environment
source "/home/leus/catkin_ws/devel/setup.bash"
roslaunch ball_orbit_estimator detect_ball_orbit.launch
exec "$@"