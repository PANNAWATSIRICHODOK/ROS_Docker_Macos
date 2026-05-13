SHELL := /bin/bash

.PHONY: build up down shell logs clean create-demo build-ws run-demo

build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

shell:
	docker compose exec ros2-desktop bash

logs:
	docker compose logs -f

clean:
	docker compose down -v --remove-orphans

create-demo:
	docker compose exec ros2-desktop bash -lc "cd /home/ros/ros2_ws/src && ros2 pkg create demo_py --build-type ament_python --dependencies rclpy std_msgs"

build-ws:
	docker compose exec ros2-desktop bash -lc "cd /home/ros/ros2_ws && source /opt/ros/humble/setup.bash && colcon build --symlink-install"

run-demo:
	docker compose exec ros2-desktop bash -lc "source /opt/ros/humble/setup.bash && source /home/ros/ros2_ws/install/setup.bash && ros2 run demo_py demo_node"
