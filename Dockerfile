FROM phusion/baseimage:0.11

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install haskell platform, git, and minimal texlive
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends haskell-platform git texlive lmodern;

# Install gitit
RUN set -ex; \
    \
    git clone https://github.com/jgm/gitit; \
    cd gitit; \
    cabal update; \
    cabal install --reinstall --ghc-options="-rtsopts";

# Add gitit daemon script
RUN mkdir /etc/service/gitit
COPY gitit.sh /etc/service/gitit/run
RUN chmod +x /etc/service/gitit/run

# Copy the post-commit script into the file-system's root and make it executable
# We will copy this over to the git repo later on container startup
COPY post-commit.sh /post-commit.sh
RUN chmod +x /post-commit.sh

# Install "at" to allow for scheduling commands for later
# Also, grant the appropriate permissions. Source: https://www.simonholywell.com/post/2010/08/ubuntu-atd-not-running/
RUN set -ex; \
	\
	apt-get install -y --no-install-recommends at; \
	chmod -R 770 /var/spool/cron/atjobs; \
	chmod -R +t /var/spool/cron/atjobs; \
	chmod -R 770 /var/spool/cron/atspool; \
	chmod -R +t /var/spool/cron/atspool; \
	chown -R daemon:daemon /var/spool/cron/atjobs; \
	chown -R daemon:daemon /var/spool/cron/atspool;

# Install cron, add the crontab and pull script, and install the cronjob
RUN apt-get install -y --no-install-recommends cron;
COPY pull.sh /pull.sh
COPY crontab /etc/cron.d/gitit-pull-cron
RUN set -ex; \
    \
    chmod +x /pull.sh; \
    chmod 0644 /etc/cron.d/gitit-pull-cron; \
    crontab /etc/cron.d/gitit-pull-cron;

# Create data directory and expose
RUN mkdir /data
WORKDIR /data
EXPOSE 5001

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
