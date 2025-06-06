# ベース：Webブラウザ付きUbuntu GUI環境
FROM linuxserver/webtop:ubuntu-mate

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ARG INSTALL_PACKAGE=desktop #ros-base に変更可能

# ---------------------------
# 1. 基本パッケージと universe リポジトリ追加
# ---------------------------
RUN apt-get update && \
    apt-get install -y curl lsb-release software-properties-common && \
    add-apt-repository universe

# ---------------------------
# 2. ros2-apt-source のインストール（推奨新方式）
# ---------------------------
RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" && \
    apt-get install -y /tmp/ros2-apt-source.deb && \
    rm /tmp/ros2-apt-source.deb

# ---------------------------
# 3. ROS 2 パッケージのインストール
# ---------------------------
RUN apt-get update && \
    apt-get install -y \
    ros-${ROS_DISTRO}-${INSTALL_PACKAGE} \
    ros-${ROS_DISTRO}-ros-gz \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------
# 4. rosdep の初期化（rootで）※updateは起動後ユーザーで推奨
# ---------------------------
RUN rosdep init || true

# ---------------------------
# 5. ユーザー環境の準備
# ---------------------------
ENV HOME=/config
ENV USER=abc

RUN mkdir -p "$HOME/.ros" && chown -R 1000:1000 "$HOME/.ros"

# 必要に応じて rosdep update をコンテナ起動後に実行してください：
# source /opt/ros/jazzy/setup.bash
# rosdep update