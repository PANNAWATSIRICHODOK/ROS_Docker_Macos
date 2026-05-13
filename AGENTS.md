# AGENTS.md

## Token-saving mode

Be extremely concise. Optimize for minimum token usage while still being correct.

## Project context

This repository is for ROS2 robot development.

Typical stack:
- ROS2 Humble
- Docker / Docker Compose
- colcon workspace
- Python ROS2 nodes
- C++ ROS2 nodes
- launch files
- URDF / xacro
- RViz2
- Gazebo / simulation tools
- robot interfaces, messages, services, and actions

Default workspace:
- `ros2_ws/`
- `ros2_ws/src/`

Do not assume the exact robot, package names, hardware, simulator, middleware, or message definitions without checking the repository.

## Core rules

- Do not read the whole repository unless explicitly asked.
- Do not inspect all ROS2 packages unless required.
- Do not open large files unless directly relevant.
- Prefer targeted search commands over broad exploration.
- Prefer editing the smallest possible set of files.
- Do not paste full files, full diffs, long logs, or long explanations unless requested.
- Do not summarize every file inspected.
- Do not repeat unchanged code.
- Do not introduce new ROS2 packages, dependencies, launch structure, robot descriptions, or middleware changes unless required.
- Preserve existing ROS2 package structure, naming, topics, services, actions, parameters, frames, launch arguments, and namespace behavior.
- Ask at most one clarification question only if the task is blocked.

## Before working

1. Classify the task as:
   - ROS2 node
   - launch
   - message/service/action interface
   - robot description
   - simulation
   - navigation
   - perception
   - control
   - hardware interface
   - Docker/dev environment
   - build/test
   - documentation
2. Detect the package and language from existing files.
3. Identify the smallest set of likely relevant files.
4. Inspect only those files first.
5. Search narrowly by package name, node name, topic, service, action, parameter, frame, launch file, error text, or dependency.
6. Stop searching once enough context exists to make a safe change.

## Repository discovery

Use narrow commands first:

```bash
find ros2_ws/src -maxdepth 3 -name package.xml
find ros2_ws/src -maxdepth 4 -name CMakeLists.txt
find ros2_ws/src -maxdepth 4 -name setup.py
find ros2_ws/src -maxdepth 4 -name "*.launch.py"
rg "<node-name>" ros2_ws/src
rg "<topic-name>" ros2_ws/src
rg "<service-name>" ros2_ws/src
rg "<parameter-name>" ros2_ws/src
rg "<frame-name>" ros2_ws/src
rg "<error-message>" ros2_ws/src
