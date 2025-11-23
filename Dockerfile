FROM ros:jazzy-ros-base

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


# プロジェクトワークスペース
WORKDIR /home/texnitis/TEXNITIS-Navigation-Library
COPY . .

SHELL ["/bin/bash", "-c"]

# rosdep の初期化と依存解決
RUN rosdep update && \
    (rosdep install -y --from-paths src --ignore-src || true)

# エントリーポイント
CMD ["/bin/bash"]
WORKDIR /home/texnitis/TEXNITIS-Navigation-Library