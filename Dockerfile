FROM debian:10.3
MAINTAINER Ralph Schuster <github@ralph-schuster.eu>

#####################################################################
#  Prerequisites
#####################################################################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl file pax bzip2 bash vim perl openssl wget default-mysql-client procps \
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
    amavisd-new

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
    && chown clamav:clamav /var/run/clamav
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
#  Container Entrypoint
#####################################################################

EXPOSE 10024
CMD ["/usr/local/amavis/entrypoint.sh"]
#CMD ["/usr/local/amavis/loop.sh"]

