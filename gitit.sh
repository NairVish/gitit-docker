#!/bin/sh

# boot up the atd daemon, because it does not run automatically as soon as we install it in the Dockerfile
# source: https://ubuntuforums.org/showthread.php?t=1115274
atd

# create a .netrc file with our git remote credentials, so that pushes and pull are automatic
# BUT only create the .netrc file if GIT_REMOTE_URL is set
if [ ! -f /root/.netrc ] && [ ! -z "$GIT_REMOTE_URL" ]; then
    HOST_NAME=$(echo "$GIT_REMOTE_URL" | awk -F/ '{print $3}')
    echo "machine $HOST_NAME\nlogin $GIT_REMOTE_USERNAME\npassword $GIT_REMOTE_PASSWORD" > /root/.netrc
    chmod 600 /root/.netrc
fi

# install the post-commit hook if it does not exist in the repo
# but delay this command until after gitit first starts up, just in case the repo does not exist yet
if [ ! -f /data/wikidata/.git/hooks/post-commit ]; then
    echo "sleep 10 ; cp /post-commit.sh /data/wikidata/.git/hooks/post-commit" | at now
fi

# run gitit
exec /root/.cabal/bin/gitit -f /gitit.conf +RTS -I0 -RTS 2>&1
