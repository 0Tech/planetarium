# chain

## Introduction

It creates an ephemeral chain using your local Docker instances. After the test
has been finished, it will also cleanup the chain. For its usage, please refer
to [test](../README.md).

## region

A `region` is a conceptual equivalance to a private subnet for the chain.
The Ansible playbooks and the tests assume a chain consists of several regions.

## network

All the nodes in a region share a subnet. And certain nodes exposes their ports
to the internet, so that other nodes in the chain can access to them.

## type

Each node in a region has a `type`, which affects its configuration.

### `administrator`

It's the controller node (of Ansible) for the region. It maintains the other
nodes in the region.

- Only one node per region
- No internet access
- No app installed
- Can access to the other nodes in the region via ssh

### `validator`

It's the validator node for the region and also the main purpose of the region.
Other nodes from the outside of the region cannot directly access to it. They
can only access to its sentries.

- Only one node per region
- No internet access
- No peer exchange
- No information about the other peers

### `seed`

It's the seed node for the region. It provides information of the other peers
in the chain, so sentries in the region don't need to know about seeds of
other regions.

- Only one node per region
- Has information about other seeds

#### `seat`

It has the private key of the validator.

- Only one node per region
- No internet access
- No peer exchange

### `sentry`

It's the sentry node for the region. To protect the validator, the number of
sentries keeps changing. There is no direct connection between outside nodes
and its validator, which means with no sentries the validator would be
isolated.

- One or more nodes per region

### `full`

It's the full node for the region. They are for the queries, so full history
remains in the nodes. Also, they don't connect with outside nodes, because it's
a sentry's job.

- Zero or more nodes per region

## peer exchange

The first configuration would be like following diagram. After some moment,
sentries will exchange the peer information directly.

sentries <-> seed <---> seed <-> sentries

## data exchange

validator <-> sentries <---> sentries <-> validator
