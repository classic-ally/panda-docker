# panda-docker
All-in-one container for interfacing with Franka Emika Panda robot.

## Software versions
- ROS Noetic
- libfranka v0.9.0
- franka-ros v0.9.0
- MoveIt! v1

## Usage
See `docker-compose.yml` for example. We need host network access to communicate with robot, escalated privileges to allow realtime operation, and a ROS core (which can exist *outside* the Docker network, but a shell example is provided in the compose stack).