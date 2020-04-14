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
    pyzor \
    liece-dcc

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
# ClamAV
RUN mkdir /var/run/clamav \
    && chown clamav:clamav /var/run/clamav
ADD etc/clamav/ /etc/clamav/

# SpamAssassin
ADD etc/spamassassin/ /etc/spamassassin/

# Amavis
ADD etc/amavis/ /etc/amavis/conf.d/
RUN chmod 777 /var/log

#####################################################################
#  Container Entrypoint
#####################################################################
RUN mkdir /usr/local/amavis/
ADD src/ /usr/local/amavis/
RUN chmod 755 /usr/local/amavis/*.sh

EXPOSE 10024
CMD ["/usr/local/amavis/entrypoint.sh"]

