FROM phusion/baseimage:0.11

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Add gitit daemon script (TODO)
RUN mkdir /etc/service/gitit
COPY gitit.sh /etc/service/gitit/run
RUN chmod +x /etc/service/gitit/run

# Create data directory and expose
RUN mkdir /data
WORKDIR /data
EXPOSE 5001

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*