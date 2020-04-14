FROM debian:10.3
MAINTAINER Ralph Schuster <github@ralph-schuster.eu>

# Install prereqs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl file pax bzip2 bash vim perl openssl wget default-mysql-client procps \
    ca-certificates

# Install Amavisd
RUN apt-get install -y --no-install-recommends \
    amavisd-new

RUN mkdir /usr/local/amavis/
ADD src/ /usr/local/amavis/
ADD etc/ /etc/amavis/conf.d/
RUN chmod 755 /usr/local/amavis/*.sh
RUN chmod 777 /var/log
#RUN ln -s /dev/stdout /var/log/amavis.log && chown amavis:amavis /var/log/amavis.log && chmod 640 /var/log/amavis.log

#CMD ["/usr/local/amavis/loop.sh"]
EXPOSE 10024
CMD ["/usr/sbin/amavisd-new", "foreground"]
