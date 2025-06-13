FROM wesleydeanflexion/busybox-jq AS jq
FROM alpine:3.18.4
WORKDIR /tools
COPY --from=jq /bin/jq /tools/jq
