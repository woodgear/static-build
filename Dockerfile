FROM wesleydeanflexion/busybox-jq AS jq

FROM grafana/xk6 AS xk6
RUN xk6 version
RUN xk6 build --with github.com/grafana/xk6-dashboard@latest


FROM alpine:3.18.4
WORKDIR /tools
COPY --from=jq /bin/jq /tools/jq
COPY --from=xk6 /xk6/k6 /tools/k6
