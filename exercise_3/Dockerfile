FROM alpine:3.14

ARG TARGETARCH

COPY --chmod=755 rest_1.0/rest_1.0_linux_${TARGETARCH} /usr/local/bin/rest

ENTRYPOINT ["/usr/local/bin/rest"]