FROM ubuntu:latest as downloader

RUN apt-get update && apt-get install -y curl \
&& curl -SsL https://github.com/morfien101/web_responder/releases/download/v1.0.0/web_healthcheck_linux_amd64 -o /web_healthcheck \
&& chmod +x /web_healthcheck

FROM ubuntu:latest as scratch-pad
RUN echo "nobody:x:65534:65534:Nobody:/:" > /tmp/scratch_passwd

FROM scratch

COPY --from=scratch-pad /tmp/scratch_passwd /etc/passwd
USER nobody

COPY --from=downloader /web_healthcheck /web_healthcheck

ENTRYPOINT [ "/web_healthcheck" ]