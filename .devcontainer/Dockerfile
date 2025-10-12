FROM ubuntu:22.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
  && apt-get -y install git curl wget unzip xz-utils zip libglu1-mesa \
  ca-certificates gnupg lsb-release software-properties-common \
  build-essential libssl-dev pkg-config sudo \
  && apt-get autoremove -y \
  && apt-get clean -y

# Install OpenJDK 17 (required for Android SDK tools)
RUN apt-get update \
  && apt-get -y install --no-install-recommends openjdk-17-jdk-headless ca-certificates-java \
  && apt-get clean -y

# Install Android SDK command-line tools and platform components
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
  cd /tmp && \
  curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdline-tools.zip && \
  unzip cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
  rm cmdline-tools.zip && \
  mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest

ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Pre-install essential Android SDK components
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true && \
  ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Get host user info (passed as build args)
ARG USER_UID=1000
ARG USER_GID=1000
ARG USERNAME=brett

# Create user with matching UID/GID and username to avoid permission issues
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -ms /bin/bash $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# Install Flutter
ENV FLUTTER_HOME="/opt/flutter"
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
  && cd $FLUTTER_HOME \
  && git checkout stable \
  && $FLUTTER_HOME/bin/flutter doctor --android-licenses || true \
  && $FLUTTER_HOME/bin/flutter config --no-analytics \
  && chown -R $USERNAME:$USERNAME $FLUTTER_HOME

# Set the default user
USER $USERNAME
WORKDIR /workspace

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog