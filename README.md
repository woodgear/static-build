# static-build
## how to use
```bash
# for example jq
docker cp $(docker run -d ghcr.io/woodgear/static-build:latest):/toos/jq ./
```
## tools
- /tools/jq
- /tools/k6 
  - k6 with dashboard extenstion
- /tools/go-wrk
- /tools/rg