# This Dockerfile describes an image on top of a base.Dockerfile output,
# that has `rosdep` installed, for inspecting a workspace and listing its dependencies

# To use this image, run a container and mount your ROS workspace at /root/ws
# It will output a file cc_internals/install_rosdeps.sh in your workspace,
# that can be used by a next phase to setup a sysroot

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install -y \
      python-rosdep \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update
COPY gather_rosdeps.sh /root/
RUN mkdir -p /root/ws
WORKDIR /root/ws
ENTRYPOINT ["/root/gather_rosdeps.sh"]
