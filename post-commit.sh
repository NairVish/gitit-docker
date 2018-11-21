#!/bin/sh

# if the GIT_REMOTE_URL is not set OR the .netrc file does not exist, then don't push
if [ -z "$GIT_REMOTE_URL" ] || [ ! -f /root/.netrc ]; then
	exit 0
fi

# set the origin's URL if "origin" exists already
git remote set-url origin $GIT_REMOTE_URL

# if the "origin" does not yet exist, ADD it instead
if [ $? -ne 0 ]; then
	git remote add origin $GIT_REMOTE_URL
fi

# then git push
git push -u origin master