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


def mirror(USER, GIT_DIR):
	user_dir = os.path.join(GIT_DIR, USER)

	try:
		url = 'https://api.github.com/users/{}/repos'.format(USER)
		response = urllib2.urlopen(url)
		contents = response.read()
		all = json.loads(contents)
	except:
		print "ERROR: reading JSON: {}".format(url)
		sys.exit(1)

	print "Found {} repos for user '{}'".format(len(all), USER)

	for repo in all:
		name = repo['name']
		if not name or len(name) < 1:
			print "ERROR: {}".format(name)
			continue
		repo_dir = os.path.join(user_dir, name)
		repo_url = repo['ssh_url']
		if not os.path.isdir(repo_dir):
			print ">> CLONE: {} - {}".format(name, repo_url)
			call(['git', 'clone', repo_url], cwd=user_dir)
		else:
			print ">> PULL : {}".format(repo_dir)
			call(['git', 'pull', '--rebase'], cwd=repo_dir)

mirror(USER, GIT_DIR)
