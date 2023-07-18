FROM debian:bookworm

# install packages
RUN apt-get update && \
    apt-get install -y --quiet --no-install-recommends openssh-server && \
    apt-get install -y --quiet runit ansible jq sudo iproute2 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/ssh/ssh_host_*

RUN rm /usr/sbin/policy-rc.d && \
    ln -s /usr/bin/true /usr/sbin/policy-rc.d

RUN ansible-galaxy collection install community.general
RUN ln -s ../etc/service /var/service

CMD ["/sbin/runit"]
STOPSIGNAL SIGINT

# support healthcheck
COPY healthcheck /usr/local/bin/
HEALTHCHECK \
    --interval=10s \
    --timeout=3s \
    --start-period=2m \
    --retries=1 \
    CMD ["healthcheck", "/tmp/height"]
