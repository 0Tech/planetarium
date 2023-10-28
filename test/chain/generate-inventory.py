#!/usr/bin/env python3

import argparse
import re
import yaml
import os
import pathlib

def dump(document, path):
    yaml.SafeDumper.add_representer(
        type(None),
        lambda dumper, value: dumper.represent_scalar(u'tag:yaml.org,2002:null', ''))

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w') as f:
        yaml.safe_dump(document, f)

def main():
    def natural(arg):
        converted = int(arg)
        if converted < 0:
            raise argparse.ArgumentTypeError("not a natural number: {}".format(arg))
        return converted

    parser = argparse.ArgumentParser()
    parser.add_argument('--output', '-o', type=pathlib.Path,
                        default=os.getcwd(),
                        help="output directory (default: current directory)")
    parser.add_argument('--validators', type=int,
                        choices=[0, 1], default=1,
                        help="the number of validators")
    parser.add_argument('--seeds', type=int,
                        choices=[0, 1], default=1,
                        help="the number of seeds")
    parser.add_argument('--seats', type=natural, default=1,
                        help="the number of seats")
    parser.add_argument('--sentries', type=natural, default=1,
                        help="the number of sentries")
    parser.add_argument('--fulls', type=natural, default=1,
                        help="the number of full nodes")
    args = parser.parse_args()

    solos = [
        ('validator', args.validators),
        ('seed', args.seeds),
    ]
    scalables = [
        ('seat', args.seats),
        ('sentry', args.sentries),
        ('full', args.fulls),
    ]

    # group vars
    for type, _ in scalables:
        group_name = type
        group_vars = {
            'type': type,
        }
        group_vars_path = args.output / 'group_vars' / '{}.yml'.format(group_name)
        dump(group_vars, group_vars_path)

    # (type, hostname) pairs
    group_hints = []
    for type, number in scalables:
        for i in range(number):
            hostname = '{}{:02d}'.format(type, i)
            group_hints.append((type, i, hostname))

    # host vars
    for _, index, hostname in group_hints:
        host_vars = {
            'replica_index': index,
        }
        host_vars_path = args.output / 'host_vars' / '{}.yml'.format(hostname)
        dump(host_vars, host_vars_path)

    for type, number in solos:
        if number != 0:
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
    for type, number in solos:
        if number != 0:
            hostname = type
            hosts[hostname] = None

    dump({'all': {'hosts': hosts, 'children': groups}}, args.output / 'hosts.yml')

if __name__ == '__main__':
    main()
