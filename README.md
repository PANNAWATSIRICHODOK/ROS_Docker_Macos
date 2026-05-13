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