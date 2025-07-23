FROM alpine:3.18.4 AS fetch
RUN apk add --no-cache curl wget jq bash
WORKDIR /build
COPY ./fetch.sh /build/fetch.sh
RUN bash -c 'mkdir ./tools;source ./fetch.sh;static-build-fetch';ls -alh ./tools

FROM golang:1.25rc2-bullseye AS go-wrk
RUN mkdir /go-wrk; cd /go-wrk;git clone https://github.com/tsliwowicz/go-wrk.git;cd /go-wrk/go-wrk; CGO_ENABLED=0 go build -o /go-wrk/wrk ;pwd;ls;date;

FROM wesleydeanflexion/busybox-jq AS jq

FROM grafana/xk6 AS xk6
RUN xk6 version
RUN xk6 build --with github.com/grafana/xk6-dashboard@latest

FROM alpine:3.18.4

WORKDIR /tools
COPY --from=jq /bin/jq /tools/jq
COPY --from=xk6 /xk6/k6 /tools/k6
COPY --from=fetch /build/tools /tools/
COPY --from=go-wrk /go-wrk/wrk /tools/go-wrk
RUN ls -alh /tools
