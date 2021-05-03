# github.com/tiredofit/docker-nginx-proxy-cloudflare-companion

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-nginx-proxy-cloudflare-companion?style=flat-square)](https://github.com/tiredofit/docker-nginx-proxy-cloudflare-companion/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-nginx-proxy-cloudflare-companion/build?style=flat-square)](https://github.com/tiredofit/docker-nginx-proxy-cloudflare-companion/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/nginx-proxy-cloudflare-companion.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nginx-proxy-cloudflare-companion/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/nginx-proxy-cloudflare-companion.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nginx-proxy-cloudflare-companion/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This builds a Docker image to automatically update Cloudflare DNS records upon container start. A time saver if you are regularly moving containers around to different systems. This will allow you to set multiple zone's you wish to update.

## Maintainer

- [Dave Conroy](http://github/tiredofit/)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Volumes](#volumes)
  - [Environment Variables](#environment-variables)
  - [Docker Secrets](#docker-secrets)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using Traefik as a reverse proxy:
   *  [Nginx-Proxy](https://github.com/jwilder/nginx-proxy)

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/traefik-cloudflare-companion) and is the recommended method of installation.

```bash
docker pull tiredofit/traefik-cloudflare-companion:(imagetag)
```
The following image tags are available along with their taged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Archictecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

Upon startup the image looks for a label containing `traefik.frontend.rule` (version 1) or `Host*` (version2) from your running containers of either updates Cloudflare with a CNAME record of your `TARGET_DOMAIN`. Previous versions of this container used to only update one Zone, however with the additional of the `DOMAIN` environment variables it now parses the containers variables and updates the appropriate zone.

For those wishing to assign multiple CNAMEs to a container use the following format:
### Volumes
| File                   | Description                                                              |
| ---------------------- | ------------------------------------------------------------------------ |
| `/var/run/docker.sock` | You must have access to the docker socket in order to utilize this image |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


| Parameter           | Description                                                                             | Default                      |
| ------------------- | --------------------------------------------------------------------------------------- | ---------------------------- |
| `DOCKER_ENTRYPOINT` | Docker Entrypoint default (local mode)                                                  | `unix://var/run/docker.sock` |
| `DOCKER_HOST`       | (optional) If using tcp connection e.g. `tcp://111.222.111.32:2376`                     |                              |
| `DOCKER_CERT_PATH`  | (optional) If using tcp connection with TLS - Certificate location e.g. `/docker-certs` |                              |
| `DOCKER_TLS_VERIFY` | (optional) If using tcp conneciton to socket Verify TLS                                 | `1`                          |
| `REFRESH_ENTRIES`   | If record exists, update entry with new values `TRUE` or `FALSE`                        | `TRUE`                       |
| `SWARM_MODE`        | Enable Docker Swarm Mode `TRUE` or `FALSE`                                              | `FALSE`                      |
| `CF_EMAIL`          | Email address tied to Cloudflare Account - Leave Blank  for Scoped API                  |                              |
| `CF_TOKEN`          | API Token for the Domain                                                                |                              |
| `DEFAULT_TTL`       | TTL to apply to records                                                                 | `1`                          |
| `TARGET_DOMAIN`     | Destination Host to forward records to e.g. `host.example.com`                          |                              |
| `DOMAIN1`           | Domain 1 you wish to update records for.                                                |                              |
| `DOMAIN1_ZONE_ID`   | Domain 1 Zone ID from Cloudflare                                                        |                              |
| `DOMAIN1_PROXIED`   | Domain 1 True or False if proxied                                                       |                              |
| `DOMAIN2`           | (optional Domain 2 you wish to update records for.)                                     |                              |
| `DOMAIN2_ZONE_ID`   | Domain 2 Zone ID from Cloudflare                                                        |                              |
| `DOMAIN2_PROXIED`   | Domain 1 True or False if proxied                                                       |                              |
| `DOMAIN3....`       | And so on..                                                                             |                              |

### Docker Secrets

`CF_EMAIL` and `CF_TOKEN` support Docker Secrets
Name your secrets either CF_EMAIL and CF_TOKEN or cf_email and cf_token.


* * *
## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. traefik-cloudflare-companion) bash
```

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* https://www.cloudflare.com
* https://github.com/tiredofit/docker-traefik-cloudflare-companion
* https://github.com/code5-lab/dns-flare
