FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/MrGuato/windrose-dedicated-server" \
      org.opencontainers.image.description="Windrose Dedicated Server (SteamCMD + Wine)" \
      org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive \
    USER=steam \
    HOME=/home/steam \
    STEAMCMDDIR=/opt/steamcmd \
    DISPLAY=:99 \
    WINEDEBUG=-all \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        libc6:i386 \
        lib32gcc-s1 \
        lib32stdc++6 \
        libncurses5:i386 \
        libstdc++6:i386 \
        libtinfo5:i386 \
        locales \
        procps \
        tini \
        wine32 \
        wine64 \
        winbind \
        xauth \
        xvfb && \
    sed -i 's/^# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    useradd -u 1000 -m -s /bin/bash steam && \
    mkdir -p /opt/steamcmd && \
    curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
        | tar -xz -C /opt/steamcmd && \
    chown -R steam:steam /opt/steamcmd /home/steam && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 entrypoint.sh /entrypoint.sh

WORKDIR /home/steam

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=3 \
    CMD pgrep -f 'WindroseServer-Win64-Shipping.exe' >/dev/null || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
