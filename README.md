# Docker image for Gitit

This is a Docker image for [Gitit](https://github.com/jgm/gitit), a wiki program written in Haskell. This image specifically has been created to sync with a remote git repo. Pulls are done through a cron job, while pushes are done as a post-commit (i.e., post-page edit/creation) hook.

## Notes

* See the `docker-compose` file. Three environment variables (`GIT_REMOTE_URL`, `GIT_REMOTE_USERNAME`, and `GIT_REMOTE_PASSWORD`) are required to be defined for pushing and pulling to work correctly.
* Only HTTP(S) remotes are currently supported.
* Pulls are done on a minutely basis for quick updating across platforms. This can be increased as desired in the `crontab` file, but the image must be rebuilt as the file is copied over during the initial building process.
