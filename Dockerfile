FROM debian:10.3
LABEL maintainer="Ralph Schuster <github@ralph-schuster.eu>"

#####################################################################
#  Prerequisites
#####################################################################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl file pax bzip2 bash vim perl openssl wget default-mysql-client procps \
    rsyslog \
    ca-certificates

#####################################################################
# INSTALL
#####################################################################
# ClamAV
RUN apt-get install -y --no-install-recommends \
    clamav \
    clamav-freshclam \
    clamav-daemon \
    clamav-base

# SpamAssassin recomended packages
RUN apt-get install -y --no-install-recommends \
    gnupg \
    libio-socket-inet6-perl \
    libmail-spf-perl \
    libdbi-perl \
    libencode-detect-perl \
    libgeo-ip-perl \
    libio-socket-ssl-perl \
    libnet-patricia-perl \
    razor \
    pyzor

# SpamAssassin
RUN apt-get install -y --no-install-recommends \
    spamassassin \
    sa-compile \
    spamc

# Amavis-new
RUN apt-get install -y --no-install-recommends \
    amavisd-new \
    && rm -rf /var/lib/apt/lists/*

# Create initial AV data
RUN /usr/bin/freshclam

#####################################################################
#  CONFIGURE
#####################################################################
# Scripts
RUN mkdir /usr/local/amavis && mkdir /usr/local/amavis/templates
ADD src/ /usr/local/amavis/
RUN chmod 755 /usr/local/amavis/*.sh

# ClamAV
RUN mkdir /var/run/clamav \
    && chown clamav:clamav /var/run/clamav \
    && adduser clamav amavis
# Copy templates and remove files already existing
RUN mkdir /usr/local/amavis/templates/clamav
ADD etc/clamav/  /usr/local/amavis/templates/clamav/
RUN cd /usr/local/amavis/templates/clamav/ && \
    for file in *; do rm /etc/clamav/$file; done


# SpamAssassin
# Copy templates and remove files already existing
RUN mkdir /usr/local/amavis/templates/spamassassin
ADD etc/spamassassin/  /usr/local/amavis/templates/spamassassin/
RUN cd /usr/local/amavis/templates/spamassassin/ && \
    for file in *; do rm /etc/spamassassin/$file; done

# Amavis
# Copy templates and remove files already existing
RUN mkdir /usr/local/amavis/templates/amavis
ADD etc/amavis/  /usr/local/amavis/templates/amavis/
RUN cd /usr/local/amavis/templates/amavis/ && \
    for file in *; do rm /etc/amavis/conf.d/$file; done
RUN chmod 777 /var/log

#####################################################################
#  Image OCI labels
#####################################################################
ARG ARG_CREATED
ARG ARG_URL
ARG ARG_SOURCE
ARG ARG_VERSION=2.11.0-01
ARG ARG_REVISION
ARG ARG_VENDOR
ARG ARG_TITLE
ARG ARG_DESCRIPTION
ARG ARG_DOCUMENTATION
ARG ARG_AUTHORS
ARG ARG_LICENSES

LABEL org.opencontainers.image.created=$ARG_CREATED
LABEL org.opencontainers.image.url=$ARG_URL
LABEL org.opencontainers.image.source=$ARG_SOURCE
LABEL org.opencontainers.image.version=$ARG_VERSION
LABEL org.opencontainers.image.revision=$ARG_REVISION
LABEL org.opencontainers.image.vendor=$ARG_VENDOR
LABEL org.opencontainers.image.title=$ARG_TITLE
LABEL org.opencontainers.image.description=$ARG_DESCRIPTION
LABEL org.opencontainers.image.documentation=$ARG_DOCUMENTATION
LABEL org.opencontainers.image.authors=$ARG_AUTHORS
LABEL org.opencontainers.image.licenses=$ARG_LICENSES

#####################################################################
#  Container Entrypoint
#####################################################################

EXPOSE 10024
VOLUME /var/virusmails
WORKDIR /usr/local/amavis
CMD ["/usr/local/amavis/entrypoint.sh"]
#CMD ["/usr/local/amavis/loop.sh"]

