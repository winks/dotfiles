#!/usr/bin/env python
import fnmatch
import os
import re
import sys
from subprocess import call

STOP_AT = 400
CAT_BLACKLIST = ['blog.md', 'stack.md', 'blog__2011.md', 'stack_2011.md']

REPLACE = {
    'github': 'https://github.com/',
    'bitbucket': 'https://bitbucket.org/',
    's9y': 'http://s9y.org',
    'hyde': 'http://ringce.com/hyde',
    'vim': 'http://www.vim.org',
    'django': 'http://djangoproject.com',
    'silex': 'http://silex.sensiolabs.org/',
    'blueprint': 'http://www.blueprintcss.org/',
    'sass': 'http://sass-lang.com/',
}

def fmt_date(s):
    parts = s.split(' ')
    p1 = parts[0]
    p2 = parts[1]
    if len(p2) != 8:
        print 'WARNING: malformed time: {}'.format(s)
    if len(p1) != 10:
        print 'WARNING: malformed date: {}'.format(s)
        ymd = p1.split('-')
        if len(ymd[1]) != 2:
            ymd[1] = '0{}'.format(ymd[1])
        if len(ymd[2]) != 2:
            ymd[2] = '0{}'.format(ymd[2])
        p1 = '-'.join(ymd)
    return '{}T{}Z'.format(p1, p2)

if len(sys.argv) < 2:
    print "usage: {} /path/to/old/content".format(sys.argv[0])
    sys.exit(1)

input = os.path.realpath(sys.argv[1])

if not os.path.isdir(input):
    print "{} is not a dir".format(sys.argv[1])
    sys.exit(1)

files = [os.path.join(dirpath, f)
    for dirpath, dirnames, files in os.walk(input)
    for f in fnmatch.filter(files, '*.html')]

print len(files)

tpl = """+++
draft = false
title = "{}"
date = {}
+++



"""

re_hyde_tags  = re.compile('\{%.*?%\}\n', re.DOTALL)
re_hyde_title = re.compile('.*title:([^\n]+)', re.DOTALL)
re_hyde_date  = re.compile('.*created:([^\n]+)', re.DOTALL)

i = 0
for file in files:
    i +=1
    if i > STOP_AT:
        continue
    stripped = re.sub(r'^' + input + '/', '', file)
    print file, stripped
    parts = stripped.split('/')
    static_page = False
    if parts[-1] == 'index.html':
        if len(parts) < 2:
            continue
        else:
            static_page = True
    if static_page:
        md_path = re.sub(r'\/index.html$', '.md', stripped)
        new_path = 'content/{}'.format(md_path.replace('/', '__'))
    else:
        md_path = re.sub(r'\.html$', '.md', stripped)
        new_path = 'content/{}'.format(md_path)
    print md_path
    with open(file, 'r') as f:
        old = f.read()
        title = '1111'
        date = '2011-06-18T23:23:23Z'

        tt = re_hyde_title.match(old)
        if tt:
            title = tt.group(1).strip().strip('"')
        dd = re_hyde_date.match(old)
        if dd:
            date = fmt_date(dd.group(1).strip())

        old = re.sub(re_hyde_tags, '', old)
        old = re.sub(r'[\n]{4,}', '\n\n\n', old)
        header = tpl.format(title, date)
        dir_name = os.path.dirname(new_path)
        if len(dir_name) > 0 and not os.path.isdir(dir_name):
            os.makedirs(dir_name)
        #call(["hugo", "new", md_path])
        if md_path not in CAT_BLACKLIST:
            with open(new_path, 'w') as f2:
                for k, v in REPLACE.iteritems():
                    pat = '{{{{links.{}}}}}'.format(k)
                    old = old.replace(pat, v)
                f2.write(header + old.strip())
