# ROS 2 Humble Ubuntu Desktop on Mac Apple Silicon with Docker

Starter project for running ROS 2 Humble with an Ubuntu 22.04 desktop UI on MacBook Apple Silicon.

It gives you:

- ROS 2 Humble
- Ubuntu desktop through noVNC
- RViz support
- Gazebo / `gz sim` support if available in the base image
- Mounted ROS 2 workspace at `./ros2_ws`
- Shared files folder at `./shared`
- VS Code Dev Container config

## Requirements

Install:

- Docker Desktop for Mac
- VS Code
- VS Code extension: Dev Containers

## Start

From this folder:

```bash
docker compose build
docker compose up -d
```

Open this in your browser:

```text
http://localhost:6080/
```

You should see an Ubuntu/XFCE desktop.

## Open terminal in the Ubuntu UI

Try:

```bash
rviz2
```

Try Gazebo:

```bash
gazebo
```

or:

```bash
gz sim
```

Depending on the exact ROS/Gazebo packages available in the base image, one of these may be available.

## Open a shell from macOS Terminal

```bash
docker compose exec ros2-desktop bash
```

## Move files between macOS and Ubuntu

Use the shared folder:

```text
./shared
```

Inside Ubuntu it appears at:

```text
/home/ros/shared
```

Text clipboard sync is supported through noVNC/VNC. If direct `Cmd+C` / `Cmd+V` does not work in a browser field or terminal, use the noVNC clipboard panel on the left side of the browser window.

## Create a demo ROS 2 Python package

```bash
cd /home/ros/ros2_ws/src
ros2 pkg create demo_py --build-type ament_python --dependencies rclpy std_msgs
```

Build:

```bash
cd /home/ros/ros2_ws
colcon build --symlink-install
source install/setup.bash
```

## Useful commands

Build image:

```bash
make build
```

Start desktop:

```bash
make up
```

Enter shell:

```bash
make shell
```

Stop:

```bash
make down
```

## Notes for Mac

This setup uses software rendering by default:

```text
LIBGL_ALWAYS_SOFTWARE=1
```

This is usually more stable on Docker Desktop for Mac. RViz and Gazebo can run, but heavy 3D simulation may be slower than Ubuntu native.

For real robot hardware such as USB camera, LiDAR, serial, CAN, and realtime motor control, a native Ubuntu robot computer is still recommended.
