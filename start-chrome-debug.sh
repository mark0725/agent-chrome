docker stop chrome-debug
docker rm chrome-debug
docker run -d --rm --network host --name chrome-debug agent-chrome

exit 0

docker run -d  --name chrome-debug \
  -p 9222:9222 \
  -p 9223:9223 \
  -p 5900:5900 \
  -p 6080:6080 \
  agent-chrome

# docker run -d --rm --name chrome-debug  -p 5900:5900 -p 9222:9222 -p 9223:9223 ghcr.io/mark0725/agent-chrome:latest
# docker run -d --rm --name chrome-debug --network host chromedp/headless-shell
