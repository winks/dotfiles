#!/usr/bin/env python

import json
import os
import urllib2
import sys

from subprocess import call

if len(sys.argv) < 3:
	print "usage: {} [USERNAME] [DIRECTORY]".format(sys.argv[0])
	sys.exit(1)

USER = sys.argv[1]
GIT_DIR = sys.argv[2]
#USER = 'winks'
#GIT_DIR  = '/srv/git'

url = 'https://api.github.com/users/{}/repos'.format(USER)
user_dir = os.path.join(GIT_DIR, USER)

try:
	response = urllib2.urlopen(url)
	contents = response.read()
	all = json.loads(contents)
except:
	print "ERROR: reading JSON"
	sys.exit(1)

print "Found {} repos for user '{}'".format(len(all), USER)

for repo in all:
	name = repo['name']
	if not name or len(name) < 1:
		print "ERROR: {}".format(name)
		continue
	repo_dir = os.path.join(user_dir, name)
	ssh_url = repo['ssh_url']
	print ">> CLONE: {} - {}".format(name, ssh_url)
	if not os.path.isdir(repo_dir):
		call(['git', 'clone', '--bare', ssh_url], cwd=user_dir)
	else:
		print ">> PULL : {}".format(repo_dir)
		call(['git', 'pull', '--rebase'], cwd=repo_dir)
