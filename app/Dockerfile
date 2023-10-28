ARG TAG

FROM golang:${TAG}

ARG DAEMON_NAME
ARG VERSION
ARG GOFLAGS
ARG WORKDIR=/tmp/workdir

# Set working directory for the build
WORKDIR $WORKDIR

# Add source files
COPY . ./

# make a bundle
RUN BUILDDIR=$(realpath $(mktemp -dp .)) && \
    BUILDDIR=$BUILDDIR CGO_ENABLED=0 VERSION=${VERSION} GOFLAGS=${GOFLAGS} make build && \
    cd $BUILDDIR && \
    tar -czf ../bundle.tar.gz ${DAEMON_NAME}
