#!/bin/bash
set -e

# setup ros environment
source "/home/leus/catkin_ws/devel/setup.bash"

# update git repos
cd catkin_ws && wstool status -t src && wstool update pointgrey_camera_driver ball_orbit_estimator -t src && catkin build pointgrey_camera_driver ball_orbit_estimator
roslaunch ball_orbit_estimator detect_ball_orbit.launch
exec "$@"
