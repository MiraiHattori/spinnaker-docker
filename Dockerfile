FROM osrf/ros:kinetic-desktop-full

ENV WORKHOME /home/leus
# install ros essential package
RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    sudo lsb-release ros-kinetic-catkin python-catkin-tools
# install spinnaker
RUN apt-get install --no-install-recommends -y python3 python3-pip
RUN pip3 install setuptools requests beautifulsoup4 tqdm
ADD ./download_spinnaker.py ${WORKHOME}/
ADD ./my_install_spinnaker.sh ${WORKHOME}/
RUN cd ${WORKHOME} && python3 download_spinnaker.py && tar xvzf *.tar.gz && cd `find . -type d | grep "spinnaker"` && mv ${WORKHOME}/my_install_spinnaker.sh . && ./my_install_spinnaker.sh
RUN pip3 uninstall -y setuptools requests beautifulsoup4 tqdm
RUN apt-get purge -y python3 python3-pip

# install pip
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
    pip install --upgrade pip
RUN mkdir -p ${WORKHOME}/catkin_ws
ADD ./rosinstall ${WORKHOME}/
RUN cd ${WORKHOME}/catkin_ws && \
    wstool init src --shallow && \
    cp ${WORKHOME}/rosinstall ${WORKHOME}/catkin_ws/src/.rosinstall && \
    wstool update -t src
RUN apt-get install --no-install-recommends -y python-rosdep
RUN cd ${WORKHOME}/catkin_ws && \
    if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then rosdep init; fi && \
    rosdep install --from-paths --ignore-src -y -r src
RUN apt-get install --no-install-recommends -y wget ros-kinetic-xmlrpcpp
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && cd ${WORKHOME}/catkin_ws && catkin build -c pointgrey_camera_driver ball_orbit_estimator"

### local changes ###

RUN mkdir -p ${WORKHOME}/.ros/camera_info
RUN cp ${WORKHOME}/catkin_ws/src/pointgrey_camera_driver/pointgrey_camera_driver/camera_info/16276501.yaml ${WORKHOME}/.ros/camera_info/
RUN cp ${WORKHOME}/catkin_ws/src/pointgrey_camera_driver/pointgrey_camera_driver/camera_info/16276527.yaml ${WORKHOME}/.ros/camera_info/

ADD ./my_entrypoint.sh /
ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
