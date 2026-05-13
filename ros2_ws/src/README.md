# ROS 2 packages

Put your ROS 2 packages in this folder.

Example inside the container:

```bash
cd /home/ros/ros2_ws/src
ros2 pkg create demo_py --build-type ament_python --dependencies rclpy std_msgs
cd /home/ros/ros2_ws
colcon build --symlink-install
source install/setup.bash
```
