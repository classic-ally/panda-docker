FROM ros:noetic
ENV DEBIAN_FRONTEND noninteractive

# Initial update
RUN apt-get update
RUN rosdep update
RUN apt-get upgrade -y

# libfranka v0.9.0 install - exists *outside* catkin workspace
RUN apt-get install -y build-essential cmake git libpoco-dev libeigen3-dev git
WORKDIR /compile
RUN git clone --recursive https://github.com/frankaemika/libfranka
WORKDIR /compile/libfranka
RUN git checkout 0.9.0
RUN git submodule update
WORKDIR /compile/libfranka/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build . -j 10

# catkin configuration
RUN apt-get install -y ros-noetic-catkin python3-catkin-tools python3-osrf-pycommon python3-wstool git
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src
RUN wstool init .
RUN wstool merge -t . https://raw.githubusercontent.com/cjbentley/panda-docker/main/requirements.rosinstall
RUN wstool update -t .
RUN rosdep install --from-paths . --ignore-src --rosdistro noetic -y --skip-keys libfranka
WORKDIR /catkin_ws
RUN catkin config --extend /opt/ros/${ROS_DISTRO} --cmake-args -DCMAKE_BUILD_TYPE=Release -DFranka_DIR:PATH=/compile/libfranka/build
RUN catkin build -j10