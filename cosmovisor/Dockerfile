ARG TAG

FROM golang:${TAG}

ARG COSMOVISOR_VERSION

RUN CGO_ENABLED=0 go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v${COSMOVISOR_VERSION}
