# agent-chrome

Chrome VNC in Docker for agent. Dockerized Chromium with VNC and CDP (Chrome DevTools Protocol) access, designed for use as an agent browser.

## Quick Start

```bash
# host  
docker run -d --rm --network host --name chrome-debug agent-chrome
```



```bash
docker run -d --rm --name chrome-debug \
  -p 9222:9222 \
  -p 9223:9223 \
  -p 5900:5900 \
  -p 6080:6080 \
  ghcr.io/mark0725/agent-chrome:latest
  
```



Open http://localhost:6080/vnc.html to view the browser via noVNC. The password is printed in the container logs:

```bash
docker logs chrome-debug
```

## Build

```bash
docker build -t agent-chrome .
```

## Claude Code Integration

```bash
# global mcp
claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest --browserUrl=http://localhost:9222

# project mcp
claude mcp add chrome-devtools --scope project -- npx -y chrome-devtools-mcp@latest --browserUrl=http://localhost:9222
```

## Ports

| Port | Service | Description |
|------|---------|-------------|
| 9222 | CDP Relay | Authenticated CDP endpoint (external) |
| 9223 | Chrome CDP | Direct Chrome DevTools Protocol (internal) |
| 5900 | VNC | Direct VNC access |
| 6080 | noVNC | Browser-based VNC client |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SANDBOX_BROWSER_CDP_PORT` | `9222` | External CDP relay listen port |
| `SANDBOX_BROWSER_CDP_AUTH_TOKEN` | *(empty)* | Auth token for CDP relay (Basic/Bearer). If unset, relay does not start |
| `SANDBOX_BROWSER_CDP_SOURCE_RANGE` | *(empty)* | CIDR range allowed to connect (e.g. `10.0.0.0/8`). Empty = allow all |
| `SANDBOX_BROWSER_VNC_PORT` | `5900` | x11vnc listen port |
| `SANDBOX_BROWSER_NOVNC_PORT` | `6080` | websockify/noVNC listen port |
| `SANDBOX_BROWSER_ENABLE_NOVNC` | `1` | Enable VNC + noVNC (`0` to disable) |
| `SANDBOX_BROWSER_NOVNC_PASSWORD` | *(empty)* | VNC password. No password if unset |
| `SANDBOX_BROWSER_HEADLESS` | `0` | Run Chrome in headless mode (`1` = headless) |
| `SANDBOX_BROWSER_NO_SANDBOX` | `1` | Add `--no-sandbox` / `--disable-setuid-sandbox` (`1` = enable) |
| `SANDBOX_BROWSER_DISABLE_GRAPHICS_FLAGS` | `1` | Disable GPU, 3D APIs, software rasterizer |
| `SANDBOX_BROWSER_DISABLE_EXTENSIONS` | `1` | Disable Chrome extensions |
| `SANDBOX_BROWSER_RENDERER_PROCESS_LIMIT` | `2` | Max Chrome renderer processes |
| `SANDBOX_BROWSER_AUTO_START_TIMEOUT_MS` | `12000` | Max wait time for CDP to become ready (ms) |
| `SANDBOX_BROWSER_DISPLAY_WIDTH` | `1280` | Display width (Xvfb + Chrome window) |
| `SANDBOX_BROWSER_DISPLAY_HEIGHT` | `800` | Display height (Xvfb + Chrome window) |

## Examples

### Headless mode (no VNC)

```bash
docker run -d --rm --name chrome-headless \
  -e SANDBOX_BROWSER_HEADLESS=1 \
  -e SANDBOX_BROWSER_ENABLE_NOVNC=0 \
  -p 9222:9222 \
  ghcr.io/mark0725/agent-chrome:latest
```

### With CDP authentication

```bash
docker run -d --rm --name chrome-debug \
  -e SANDBOX_BROWSER_CDP_AUTH_TOKEN=my-secret-token \
  -e SANDBOX_BROWSER_CDP_SOURCE_RANGE=10.0.0.0/8 \
  -p 9222:9222 \
  -p 6080:6080 \
  ghcr.io/mark0725/agent-chrome:latest
```

Then connect with auth:

```bash
# Bearer token
curl -H "Authorization: Bearer my-secret-token" http://localhost:9222/json/version

# Basic auth (username: sandbox)
curl -u sandbox:my-secret-token http://localhost:9222/json/version
```

### Docker Compose

```yaml
services:
  chrome:
    image: ghcr.io/mark0725/agent-chrome:latest
    ports:
      - "9222:9222"
      - "6080:6080"
    environment:
      SANDBOX_BROWSER_CDP_AUTH_TOKEN: my-secret-token
```

## License

[MIT](LICENSE)
