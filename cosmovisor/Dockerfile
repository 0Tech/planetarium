ARG GO_VERSION

FROM golang:${GO_VERSION}-bookworm

ARG COSMOVISOR_VERSION

RUN CGO_ENABLED=0 go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v${COSMOVISOR_VERSION}
