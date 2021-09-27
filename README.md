# CompBio app server

Visit our website at https://compbio.imm.medicina.ulisboa.pt!

This project uses:
- [Docker Compose][] to manage multiple Docker containers
- [Nginx][] as a reverse proxy (i.e. to redirect URLs), to serve SSL
certificates and to show a public folder
- [ShinyProxy][] to run R/Shiny and Python apps via Docker
  - [Prometheus][] and [Grafana][] to log and visualise ShinyProxy usage data
- [Celery][] to run background tasks via a job queue system
  - [Flower][] to monitor Celery and to send jobs to Celery via its REST API
  - [Redis][] to serve as message broker for celery
  - [Prometheus][] and [Grafana][] to log and visualise Celery data
- [MySQL][] as the database server
- [RStudio Server][] to test code on-the-fly

[Docker Compose]: https://docs.docker.com/compose/
[ShinyProxy]: https://shinyproxy.io
[Grafana]: https://grafana.com
[Celery]: https://docs.celeryproject.org/
[Flower]: https://flower.readthedocs.io/en/latest/
[Redis]: https://redis.io
[Prometheus]: https://prometheus.io
[MySQL]: https://www.mysql.com
[RStudio Server]: https://www.rstudio.com/products/rstudio/
[Nginx]: https://nginx.org

## Useful commands

Go to the project folder and run:

1. [`./shinyproxy/download-shinyproxy-dockers.sh`][downloadDockers] to
automatically pull Docker images used in ShinyProxy.
2. `docker-compose up -d --build` to build local Docker images, download the
remote images and start the server.

[downloadDockers]: shinyproxy/download-shinyproxy-dockers.sh

Other relevant commands:

Command                             | Description                     
----------------------------------- | --------------------------------
`docker-compose down`               | Stop the server and all services
`docker-compose restart shinyproxy` | Restart a specific service (in this case, `shinyproxy`); useful after changing the configuration of a single service and to avoid restarting the whole server
`docker-compose logs nginx`         | Print logs of a specific service (in this case, `nginx`)
`docker-compose -h`                 | Show further documentation

## Relevant assets

Asset                                                      | Description
---------------------------------------------------------- | --------------------------------------------------------------------
[`docker-compose.yml`](docker-compose.yml)                 | Docker Compose configuration
[`nginx/nginx.conf`](nginx/nginx.conf)                     | Nginx configuration
[`shinyproxy/application.yml`](shinyproxy/application.yml) | ShinyProxy configuration (including Shiny apps to run)
[`shinyproxy/templates`](shinyproxy/templates)             | ShinyProxy HTML theme
[`celery/tasks.py`](celery/tasks.py)                       | Celery tasks
[`public`](public)                                         | Publicly available files/folders downloadable at [`/public`][public]

[public]: https://compbio.imm.medicina.ulisboa.pt/public

### Adding new apps to ShinyProxy

[ShinyProxy][] deploys Shiny and Python apps via Docker images. Put simply,
you will need to:

#### 1. [Create a Docker image of your app][deploying]

I suggest uploading your Docker image to DockerHub and then pull it from
the app server, e.g.:

```
docker pull nunoagostinho/psichomics:latest
```

[Deploying]: https://shinyproxy.io/documentation/deploying-apps/

#### 2. Configure ShinyProxy in [`shinyproxy/application.yml`](shinyproxy/application.yml)

Include a block of text related to your app at the end of the file, for
instance:

```yml
  - id: psichomics
    description: Alternative splicing quantification, visualisation and analysis
    container-image: nunoagostinho/psichomics:dev
    container-cmd: ["R", "-e", "psichomics::psichomics(host='0.0.0.0', port=3838, shinyproxy=TRUE)"]
    container-network: "${proxy.docker.container-network}"
    container-volumes: [ "/srv/apps/psichomics/data:/root/Downloads" ]
```

You can edit any field you want with the exception of
`container-network: "${proxy.docker.container-network}"`: this is required for
ShinyProxy to communicate with the Docker image inside Docker Compose.

More details on app configuration for ShinyProxy are available at
https://shinyproxy.io/documentation/configuration/#apps

#### 3. Restart ShinyProxy using `docker-compose restart shinyproxy`

While restarting ShinyProxy, the website will show you simply **502: Bad Gateway**.
This is expected until ShinyProxy starts running again.

### SSL certificate renewal

SSL certificates are maintained via [Nginx][] for encrypted HTTPS traffic. These
certificates need to be renewed frequently (e.g. every year). To do so, after
replacing the SSL certificate files:

1. In case the filename of the SSL certificate changes, open the file
[`nginx/nginx.conf`](nginx/nginx.conf) and replace the path to the certificates
(in `ssl_certificate` and `ssl_certificate_key`)

2. Manually restart Nginx with the command `docker-compose restart nginx`

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
