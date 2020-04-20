# docker-mailserver-amavis
This is a Docker image for an Amavisd-new mail scanner. The project is part of the 
[docker-mailserver](https://github.com/technicalguru/docker-mailserver) project but can run separately 
without the other components. The image listens at one port (10024) for mails to be
scanned (using SMTP protocol) and forwards messages and results after the scan back to
a SMTP server (usually the originating server on port 10025).

Related images:
* [docker-mailserver](https://github.com/technicalguru/docker-mailserver) - The main project, containing composition instructions
* [docker-mailserver-postfix](https://github.com/technicalguru/docker-mailserver-postfix) - Postfix/Dovecot image (mailserver component)
* [docker-mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) - Image for PostfixAdmin (Web UI to manage mailboxes and domain in Postfix)
* [docker-mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) - Roundcube Webmailer

# Tags
The following versions are available from DockerHub. The image tag matches the Amavisd-new version.

* [2.11.0-01, 2.11.0, 2.11, 2, latest](https://hub.docker.com/repository/docker/technicalguru/mailserver-amavis) - [Dockerfile](https://github.com/technicalguru/docker-mailserver-amavis/blob/2.11.0-01/Dockerfile)

# Features
* Virus detection using [ClamAV](https://www.clamav.net/) v0.102
* Spam detection using [SpamAssassin](https://spamassassin.apache.org/) v3.4.2
* Seamless integration in any SMTP mail chain

# License
_docker-mailserver-amavis_  is licensed under [GNU LGPL 3.0](LICENSE.md). As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

# Prerequisites
None

# Usage

## Environment Variables
_docker-mailserver-amavis_  requires various environment variables to be set. The container startup will fail when the setup is incomplete.

| **Variable** | **Description** | **Default Value** |
|------------|---------------|-----------------|
| `AV_MYDOMAIN` | The first and primary mail domain of your mailserver. Amavis uses this to add headers in a mail. | `localdomain` |
| `AV_POSTFIX_SERVICE_NAME` | The hostname or IP address of the SMTP server where Amavis will deliver scanned mails and results to. | `127.0.0.1` |
| `AV_POSTFIX_SERVICE_PORT` | The port of the SMTP server for delivering scanned mails and results. | `10025` |
| `AV_VIRUSADMIN_EMAIL` | The global administrator to be informed about virus detection and quarantines. | `postmaster@AV_MYDOMAIN` |

## Volumes
You shall provide a data volume in order to secure your quarantine data from data loss. Map the volume to `/var/virusmails` folder inside the container.

## Ports
_docker-mailserver-amavis_  exposes port 10024. This is an unprotected SMTP listener port to request AntiVirus and AntiSpam scans. **Attention!** You need to make sure that this port is not accessible by any other host than your SMTP mail service. Otherwise it can be used for SPAM attacks.
 
## Running the Container
The [main mailserver project](https://github.com/technicalguru/docker-mailserver) has examples of container configurations:
* [with docker-compose](https://github.com/technicalguru/docker-mailserver/tree/master/examples/docker-compose)
* [with Kubernetes YAML files](https://github.com/technicalguru/docker-mailserver/tree/master/examples/kubernetes)
* [with HELM charts](https://github.com/technicalguru/docker-mailserver/tree/master/helm-charts)

# Refreshing AV signatures and Spam detection rules
Every once in a while you will need to run `sa-compile` and `freshclam`in order to refresh you virus and spam detection rules. The current images does not do this yet (see [#4](https://github.com/technicalguru/docker-mailserver-amavis/issues/4))

# Additional customization
You can further customize Amavis, ClamAV and SpamAssassin configuration files. Please follow these instructions:

1. Check the `/usr/local/amavis/templates` folder for already existing customizations. 
1. If you configuration file is not present yet, take a copy of the file from `/etc/amavis`, `/etc/clamav` or `/etc/spamassassin` folders.
1. Customize your configuration file.
1. Provide your customized file(s) back into the appropriate template folder at `/usr/local/amavis/templates` by using volume mappings.
1. (Re)Start the container. If you configuration was not copied correctly then log into the container (bash is available) and delete the changed files from the corresponding `/etc` folders. Then restart the container.

# Issues
This Docker image is mature and provides scanning for my mailserver in production. However, several issues are still unresolved:

* [#2](https://github.com/technicalguru/docker-mailserver-amavis/issues/2) - DKIM support is missing
* [#3](https://github.com/technicalguru/docker-mailserver-amavis/issues/3) - SPF support is missing
* [#4](https://github.com/technicalguru/docker-mailserver-amavis/issues/4) - Add automatic SA and ClamAV rules refresh

# Contribution
Report a bug, request an enhancement or pull request at the [GitHub Issue Tracker](https://github.com/technicalguru/docker-mailserver-amavis/issues). Make sure you have checked out the [Contribution Guideline](CONTRIBUTING.md)


