FROM debian:bookworm

# install packages
RUN apt-get update && \
    apt-get install -y --quiet runit jq && \
    rm -rf /var/lib/apt/lists/*

RUN rm /usr/sbin/policy-rc.d && \
    ln -s /usr/bin/true /usr/sbin/policy-rc.d

RUN ln -s ../etc/service /var/service

CMD ["/sbin/runit"]
STOPSIGNAL SIGINT

COPY hermes /usr/bin/hermes

RUN mkdir -p /root/.hermes
COPY config.toml /root/.hermes/

# support healthcheck
# COPY healthcheck /usr/local/bin/
# HEALTHCHECK \
#     --interval=10s \
#     --timeout=3s \
#     --start-period=2m \
#     --retries=1 \
#     CMD ["healthcheck", "/tmp/height"]
