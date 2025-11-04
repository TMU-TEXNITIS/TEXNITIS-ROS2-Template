FROM ros:humble-ros-base

ENV DEBIAN_FRONTEND=noninteractive

# 必要なビルドツールとユーティリティ
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-rosdep \
    python3-colcon-common-extensions \
    clang \
    clang-format \
    curl \
    git \
    cmake \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# natto_library を取得
ARG NATTO_REPO=https://github.com/NITIC-Robot-Club/natto_library.git
WORKDIR /opt
RUN git clone --depth 1 ${NATTO_REPO} natto_library

# rosdep の初期化と依存解決（natto_library 分）
RUN rosdep update && \
    rosdep install -y --from-paths /opt/natto_library/src --ignore-src

# プロジェクトワークスペース
WORKDIR /workspaces/project
COPY . /workspaces/project

SHELL ["/bin/bash", "-c"]

# natto_library をビルド（キャッシュ層を作成）
RUN source /opt/ros/humble/setup.bash && \
    colcon build --merge-install --base-paths /opt/natto_library

# エントリーポイント
CMD ["/bin/bash"]
