# playbook

## TL;DR

``` shell
ansible-playbook -i inventory cosmovisor.yml \
                 -e src=cosmovisor \
                 -e daemon_name=gaia \
                 -e daemon_home=/home/cosmovisor/.gaia
ansible-playbook -i inventory daemon.yml \
                 -e src=gaia.tar.gz \
                 -e region_id=antarctica \
                 -e chain_id=testnet \
                 -e keyring_backend=test
ansible-playbook -i inventory peers.yml \
                 -e @seeds.json
ansible-playbook -i inventory blocksync.yml \
                 -e src=genesis.json
```

## Introduction

You can use [Ansible](https://www.ansible.com) to manage your valiator subnet.

By using these playbooks, one can:

1. setup a subnet from scratch
2. scale up or down the sentries
3. prepare in-place migrations
4. execute rolling update in a sequential manner

## Prerequisites

Preparing node is out of scope, so you must setup your nodes. Also, you must
ensure the control node can access to the managed nodes by using SSH. You must
also prepare the inventory for the managed nodes, in which each node must have
its `type` variable. It must be one of the following values: 

1. `validator`: one can have only one validator node per subnet.
2. `seed`: one seed node per subnet.
3. `sentry`: one can add many sentry nodes.
4. `full`: full nodes are for the queries.
5. `seat`: this node has the private key of the validator's operator.

## Usage

### Setting a new subnet

#### Install cosmovisor

At first, you need to install cosmovisor:

``` shell
cosmovisor_src=cosmovisor           # the path of the executable
daemon_name=gaia                    # see DAEMON_NAME of cosmovisor
daemon_home=/home/cosmovisor/.gaia  # see DAEMON_HOME of cosmovisor
ansible-playbook -i inventory cosmovisor.yml \
                 -e src=$cosmovisor_src \
                 -e daemon_name=$daemon_name \
                 -e daemon_home=daemon_home
```

#### Install daemon

After installing cosmovisor, you must install a daemon (e.g. gaia):

``` shell
daemon_src=gaia.tar.gz  # the path of the executable bundle
region_id=antarctica    # the name for the subnet
chain_id=testnet        # see chain-id of cosmos-sdk
keyring_backend=test    # see keyring-backend of cosmos-sdk
ansible-playbook -i inventory daemon.yml \
                 -e src=$daemon_src \
                 -e region_id=$region_id \
                 -e chain_id=$chain_id \
                 -e keyring_backend=$keyring_backend
```

#### Set peers information

You must know at least one IPv4 address of a seed. You may extract it from a
region by:

``` shell
seed_json=seed.json  # the destination path of the seed information
ansible-playbook -i inventory peers.yml \
                 -e dest=$seed_json
```

Then, one can use the information on the other nodes by:

``` shell
seeds_json=seeds.json  # information of the seeds
cat $seed_json | jq -ns '.seeds |= inputs' >$seeds_json
ansible-playbook -i inventory peers.yml \
                 -e @$seeds_json
```

#### Generate genesis (optional)

You may have to generate the `genesis.json`. There would be many ways to
generate it, so we won't show you the exact procedure here. You may get a hint
from `gentx.yml` and `genesis.yml`, which are the playbooks to generate the
genesis on the tests.

#### Sync your subnet

By now, you must already have `genesis.json` for your subnet. There are several
ways to sync your subnet, but this time, blocksync would be sufficient:

``` shell
genesis_src=genesis.json  # the path of the genesis
ansible-playbook -i inventory blocksync.yml \
                 -e src=$genesis_src
```

### Upgrading a subnet

#### Rolling update

If there is no breaking change, we do rolling update with the new binary.

``` shell
new_daemon_src=gaia2.tar.gz  # the path of the new executable bundle
ansible-playbook -i inventory upgrade.yml \
                 -e src=$new_daemon_src
```

#### In-place migration

If there is a breaking change, we must do in-place migration with the new
binary. You should prepare the migration before the chain reaches the upgrade
height:

``` shell
new_daemon_src=gaia2.tar.gz  # the path of the new executable bundle
upgrade_name=v0-Dummy        # see plan name of x/upgrade
ansible-playbook -i inventory upgrade.yml \
                 -e src=$new_daemon_src \
                 -e upgrade_name=$upgrade_name
```
