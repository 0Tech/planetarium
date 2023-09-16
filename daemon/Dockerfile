ARG GO_VERSION

FROM golang:${GO_VERSION}-bookworm

ARG DAEMON_NAME
ARG WORKDIR=/tmp/workdir

# Set working directory for the build
WORKDIR $WORKDIR

# Add source files
COPY . ./

# make a bundle
RUN BUILDDIR=$(realpath $(mktemp -dp .)) && \
    BUILDDIR=$BUILDDIR CGO_ENABLED=0 make build && \
    cd $BUILDDIR && \
    tar -czf ../bundle.tar.gz ${DAEMON_NAME}
