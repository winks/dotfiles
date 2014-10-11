#!/usr/bin/env python

import os
import sys

from subprocess import call

if len(sys.argv) < 3:
	print "usage: {} [USERNAME] [DIRECTORY]".format(sys.argv[0])
	sys.exit(1)

USER = sys.argv[1]
GIT_DIR = sys.argv[2]


def mirror(USER, GIT_DIR, file_name, vcs):
	user_dir = os.path.join(GIT_DIR, USER)

	try:
		file = os.path.join(os.environ['HOME'], 'Documents', file_name)
		with open(file, 'r') as file:
			all = file.readlines()
	except:
		print "ERROR: reading file: {}".format(file)
		sys.exit(1)

	print "Found {} repos for user '{}'".format(len(all), USER)

	for repo in all:
		name = repo.strip()
		if not name or len(name) < 1:
			print "ERROR: {}".format(name)
			continue
		repo_dir = os.path.join(user_dir, name)
		if not os.path.isdir(repo_dir):
			if vcs == 'hg':
				repo_url = 'ssh://{}@bitbucket.org/{}/{}'.format(vcs, USER, name)
				print ">> CLONE: {} - {}".format(name, repo_url)
				call(['hg', 'clone', repo_url], cwd=user_dir)
			else:
				repo_url = '{}@bitbucket.org:{}/{}'.format(vcs, USER, name)
				print ">> CLONE: {} - {}".format(name, repo_url)
				call(['git', 'clone', repo_url], cwd=user_dir)
		else:
			print ">> PULL : {}".format(repo_dir)
			if vcs == 'hg':
				call(['hg', 'pull', '-u'], cwd=repo_dir)
			else:
				call(['git', 'pull', '--rebase'], cwd=repo_dir)

mirror(USER, GIT_DIR, 'bitbucket_repos.txt', 'git')
mirror(USER, GIT_DIR, 'bitbucket_repos_hg.txt', 'hg')
