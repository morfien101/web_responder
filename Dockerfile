FROM golang:1.23 AS builder
ARG OS=linux
ARG OUTPUT_DIR=/build
ARG FILENAME=web_healthcheck

COPY . .

RUN <<EOF
mkdir -p "$OUTPUT_DIR"
go mod download
CGO_ENABLED=0 GOOS="$OS" go build -a -installsuffix cgo -o "$OUTPUT_DIR/$FILENAME"
chmod 775 "$OUTPUT_DIR/$FILENAME"
EOF

FROM ubuntu:24.04 AS scratch-pad
RUN echo "nobody:x:65534:65534:Nobody:/:" > /tmp/scratch_passwd

FROM scratch
ARG OS=linux
ARG OUTPUT_DIR=/build
ARG FILENAME=web_healthcheck


COPY --from=scratch-pad /tmp/scratch_passwd /etc/passwd
USER nobody

COPY --from=builder "$OUTPUT_DIR/$FILENAME" "/$FILENAME"

ENTRYPOINT [ "/web_healthcheck" ]