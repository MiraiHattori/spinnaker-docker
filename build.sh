#!/bin/bash

# building debug image
sudo docker build -f ./Dockerfile.debug --rm --tag=future731/ball_orbit_estimator_debug .

# building device_reset image
cat Dockerfile.debug | sed -e '$ a \
ADD ./entrypoint/device_reset.sh /\
ENTRYPOINT ["/device_reset.sh"]\
CMD ["bash"]' > Dockerfile.spinnaker_device_reset
sudo docker build -f ./Dockerfile.spinnaker_device_reset --rm --tag=future731/device_reset .
rm ./Dockerfile.spinnaker_device_reset

# building device_reset image
cat Dockerfile.debug | sed -e '$ a \
ADD ./entrypoint/roslaunch.sh /\
ENTRYPOINT ["/roslaunch.sh"]\
CMD ["bash"]' > Dockerfile.ball_orbit_estimator

sudo docker build -f ./Dockerfile.ball_orbit_estimator --rm --tag=future731/ball_orbit_estimator .
rm ./Dockerfile.ball_orbit_estimator
