FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    chromium \
    curl \
    fonts-liberation \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    git \
    jq \
    novnc \
    python3 \
    websockify \
    x11vnc \
    xvfb

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

RUN useradd --create-home --shell /bin/bash sandbox
USER sandbox
WORKDIR /home/sandbox

EXPOSE 9222 9223 5900 6080

CMD ["/usr/local/bin/entrypoint.sh"]
