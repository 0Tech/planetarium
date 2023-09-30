#!/usr/bin/env python3

import argparse
import re
import yaml
import pathlib

def dump(document, path):
    yaml.SafeDumper.add_representer(
        type(None),
        lambda dumper, value: dumper.represent_scalar(u'tag:yaml.org,2002:null', ''))

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w') as f:
        yaml.safe_dump(document, f)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', '-o', type=pathlib.Path,
                        help="output directory path")
    parser.add_argument('--sentries', type=int, default=1,
                        help="the number of sentries in each region")
    parser.add_argument('--fulls', type=int, default=1,
                        help="the number of full nodes in each region")
    args = parser.parse_args()

    solos = [
        'validator',
        'seed',
        'seat',
    ]
    scalables = [
        'sentry',
        'full',
    ]

    # group vars
    for type in scalables:
        group_name = type
        group_vars = {
            'type': type,
        }
        group_vars_path = args.output / 'group_vars' / '{}.yml'.format(group_name)
        dump(group_vars, group_vars_path)

    # (type, hostname) pairs
    group_hints = []
    for i in range(args.sentries):
        type = 'sentry'
        hostname = '{}{:02d}'.format(type, i)
        group_hints.append((type, i, hostname))
    for i in range(args.fulls):
        type = 'full'
        hostname = '{}{:02d}'.format(type, i)
        group_hints.append((type, i, hostname))

    # host vars
    for _, index, hostname in group_hints:
        host_vars = {
            'replica_index': index,
        }
        host_vars_path = args.output / 'host_vars' / '{}.yml'.format(hostname)
        dump(host_vars, host_vars_path)

    for type in solos:
        hostname = type
        host_vars = {
            'type': type,
        }
        host_vars_path = args.output / 'host_vars' / '{}.yml'.format(hostname)
        dump(host_vars, host_vars_path)

    # hosts
    groups = {}
    for type, _, hostname in group_hints:
        group_name = type
        group = groups.get(group_name, {'hosts': {}})
        group['hosts'][hostname] = None
        groups[group_name] = group

    hosts = {}
    for type in solos:
        hostname = type
        hosts[hostname] = None

    dump({'all': {'hosts': hosts, 'children': groups}}, args.output / 'hosts.yml')

if __name__ == '__main__':
    main()
