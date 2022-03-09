# [CompBio app server](https://compbio.imm.medicina.ulisboa.pt)

This project uses:
- [Docker Compose][] to manage multiple Docker containers
- [Nginx][] as a reverse proxy (i.e. to redirect URLs), to serve SSL
certificates and to show a [public](nginx/public) folder
- [ShinyProxy][] to run R/Shiny and Python apps via Docker
- [Celery][] to run background tasks via a job queue system
  - [Flower][] to monitor Celery and to send jobs to Celery via its REST API
  - [Redis][] to serve as message broker for celery
- [Prometheus][] and [Grafana][] to log and visualise ShinyProxy and Celery data
- [Plausible][] analytics to gather traffic metrics of multiple websites
  - [Postgres][] database (Plausible's user data)
  - [Clickhouse][] database (Plausible's analytics)
- [RStudio Server][] to test code on-the-fly (`dev` profile only)

[Docker Compose]: https://docs.docker.com/compose/
[ShinyProxy]: https://shinyproxy.io
[Grafana]: https://grafana.com
[Celery]: https://docs.celeryproject.org/
[Flower]: https://flower.readthedocs.io/en/latest/
[Redis]: https://redis.io
[Prometheus]: https://prometheus.io
[RStudio Server]: https://www.rstudio.com/products/rstudio/
[Nginx]: https://nginx.org
[Plausible]: https://plausible.io
[Postgres]: https://www.postgresql.org
[Clickhouse]: https://clickhouse.com

## Setup

First, download or clone this repository to your personal computer.

To setup and start running the app server, you will need to build local Docker
images and download Docker images used in Docker Compose and as ShinyProxy apps.
This can be done in slightly different ways as detailed below.

### Testing environment (i.e. staging)

To avoid testing changes in the production server, prepare a staging environment
in your computer by going to the project folder and running:

```bash
./setup-testing-mode.sh            # setup files for testing and download Docker images
docker compose --profile dev up -d # start services and RStudio in detached mode
```

You can now visit http://localhost in your web browser. The services should be
fully operational in about ~30 seconds. Specific services may only be accessible
via their port, e.g. http://localhost:8000 for plausible and
http://localhost:8787 for RStudio.

### Production environment

Some services are given a default email, user and/or password. The default ones
are fine for testing purposes, but should be set in a `.env` file when running
in a production environment.

<details>
<summary>Example `.env` file</summary>

```bash
RSTUDIO_PASSWORD=rstudio_pass

POSTGRES_USER=postgres_user
POSTGRES_PASSWORD=postgres_pass

GRAPHANA_USER=graphana_user
GRAPHANA_PASSWORD=graphana_pass

PLAUSIBLE_EMAIL=someone@email.com
PLAUSIBLE_USER=plausible_user
PLAUSIBLE_PASSWORD=plausible_pass
```
</details>

After creating such a file, go to the project folder and run:

```bash
./setup.sh              # prepare config files and download Docker images
docker compose up -d    # start services in detached mode
```

You can now visit http://localhost in your web browser.

> Some services are only available in the `dev` profile (RStudio). To
> run this profile, type:
> ```bash
> docker compose --profile dev up -d
> ```

## Next steps

- [Add and update apps in ShinyProxy](shinyproxy)
- [Monitor website analytics with Plausible](plausible)
- [Renew SSL certificates and other Nginx configurations](nginx)

## Essential Docker Compose commands

```bash
docker compose up -d --build      # build images and start in detached mode
docker compose down               # stop all services
docker compose restart shinyproxy # restart a specific service, e.g. shinyproxy
docker compose logs nginx         # print logs of a specific servcie, e.g. nginx
docker compose -h                 # show help documentation
```

Some of the services were configured to store their data in
[Docker volumes][volumes]:

```bash
docker volume ls                  # list Docker volumes
docker volume inspect [volume]    # inspect volume information
```

[volumes]: https://docs.docker.com/storage/volumes/

## Relevant assets

Asset                                           | Description
----------------------------------------------- | --------------------------------------------------------------------
[`docker-compose.yml`](docker-compose.yml)      | Docker Compose configuration
[`nginx`](nginx)                                | Nginx configuration files (main one is [`nginx.conf`][nginx.conf])
[`nginx/public`](nginx/public)                  | Publicly available data downloadable at [`/public`][public]
[`shinyproxy/application.yml`][application.yml] | ShinyProxy configuration (including Shiny apps)
[`shinyproxy/templates`](shinyproxy/templates)  | ShinyProxy custom HTML files
[`celery/tasks.py`](celery/tasks.py)            | Celery tasks

[application.yml]: shinyproxy/application.yml
[nginx.conf]: nginx/nginx.conf
[public]: https://compbio.imm.medicina.ulisboa.pt/public

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
