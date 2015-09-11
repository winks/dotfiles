#!/usr/bin/env python
#
# Grabs all hostnames from EC2 and outputs them in /etc/hosts format
# Needs python, boto and ~/.eucarc:
# EC2_REGION=eu-west-1
# EC2_ACCESS_KEY=
# EC2_SECRET_KEY=
# EC2_URL=https://ec2.${EC2_REGION}.amazonaws.com


import boto.ec2
import ConfigParser
import os
import re
import sys

from random import randint


class FakeSecHead(object):
    def __init__(self, fp):
        self.fp = fp
        self.sechead = '[asection]\n'
    def readline(self):
        if self.sechead:
            try: return self.sechead
            finally: self.sechead = None
        else: return self.fp.readline()


def debug(inst):
    keys = [ 'id', 'state', 'public_dns_name', 'private_dns_name',
    'ip_address', 'private_ip_address', 'launch_time', 'placement',
    'groups', 'tags', ]
    LEN = 20

    for k in keys:
        v = getattr(inst, k)
        if k == 'tags':
            print '{}:'.format('Tags'.ljust(LEN))
            for tk, tv in v.iteritems():
                print "t{} : {}".format(tk.rjust(LEN-1), tv)
        elif k == 'groups':
            print '{}:'.format('Groups'.ljust(LEN))
            for x in v:
                print "{}  {}".format(''.ljust(LEN), x.name)
        else:
            print "{} : {}".format(k.ljust(LEN), v)
    print "---"


def slugify(what, replacement='-'):
    return re.sub(r'[^a-zA-Z0-9]', replacement, str(what)).lower()


def fmt(inst, domain):
    fqdn = '{}.' + domain
    ip = getattr(inst, 'ip_address')
    intl = getattr(inst, 'private_dns_name')
    tags = getattr(inst, 'tags')

    name = ''
    if intl:
        fqdn += "\t{}".format(intl)
    if 'hostname' in inst.tags:
        fqdn += "\t{}".format(inst.tags['hostname'])
    if 'Name' in inst.tags:
        name += inst.tags['Name'].strip().replace(' ', '-xyz-')
    found = False
    for k, v in tags.iteritems():
        if found:
            continue
        if k == 'role':
            fqdn = fqdn.format(slugify(v))
            found = True
    if not found:
        fqdn = fqdn.format('host'+str(randint(100,999)))

    if ip:
        return "{}\t{}\t{}".format(ip, fqdn, name)


def main(domain):
    home = os.environ.get('HOME')
    if not home:
        sys.exit(1)

    file_name = "{}/.eucarc".format(home)
    if not file_name:
        sys.exit(2)
    if not os.path.exists(file_name):
        sys.exit(3)

    cp = ConfigParser.ConfigParser()
    cp.readfp(FakeSecHead(open(file_name)))
    section = 'asection'
    config = dict()
    for option in cp.options(section):
        config[option] = cp.get(section, option)

    if not 'ec2_region' in config:
        sys.exit(4)
    if not 'ec2_access_key' in config:
        sys.exit(5)
    if not 'ec2_secret_key' in config:
        sys.exit(6)

    client = boto.ec2.connect_to_region(config['ec2_region'],
                                             aws_access_key_id=config['ec2_access_key'],
                                             aws_secret_access_key=config['ec2_secret_key'])
    reservations = client.get_all_reservations()
    lines = []

    for rx in reservations:
        for inst in rx.instances:
            #debug(inst)
            line = fmt(inst, domain)
            if line:
                lines.append(line)

    content = "\n".join(lines)
    if len(content) > 0:
        print content


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print "Usage: {} DEFAULT_DOMAIN".format(sys.argv[0])
        sys.exit(1)
    main(sys.argv[1])
