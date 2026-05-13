FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ros
ENV HOME=/home/ros
ENV DISPLAY=:1
ENV VNC_RESOLUTION=1920x1080
ENV VNC_PASSWORD=ros
ENV ROS_DISTRO=humble

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    wget \
    nano \
    vim \
    htop \
    net-tools \
    iputils-ping \
    build-essential \
    python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    autocutsel \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    mesa-utils \
    libgl1-mesa-dri \
    libgl1 \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ${USER} \
    && echo "${USER}:${USER}" | chpasswd \
    && usermod -aG sudo ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER}

RUN rosdep init || true

USER ${USER}
WORKDIR ${HOME}

RUN rosdep update || true

RUN mkdir -p ${HOME}/.vnc

RUN cat > ${HOME}/.vnc/xstartup <<'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
autocutsel -fork
autocutsel -selection PRIMARY -fork
exec startxfce4
EOF
RUN chmod +x ${HOME}/.vnc/xstartup

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc \
    && echo "if [ -f ${HOME}/ros2_ws/install/setup.bash ]; then source ${HOME}/ros2_ws/install/setup.bash; fi" >> ${HOME}/.bashrc \
    && echo "export ROS_DOMAIN_ID=\${ROS_DOMAIN_ID:-42}" >> ${HOME}/.bashrc \
    && echo "export RMW_IMPLEMENTATION=\${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp}" >> ${HOME}/.bashrc

COPY --chown=${USER}:${USER} scripts/start-desktop.sh /usr/local/bin/start-desktop.sh
USER root
RUN chmod +x /usr/local/bin/start-desktop.sh
USER ${USER}

WORKDIR ${HOME}/ros2_ws

CMD ["/usr/local/bin/start-desktop.sh"]
