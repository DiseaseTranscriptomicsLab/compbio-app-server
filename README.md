# CompBio app server

Visit our website at https://compbio.imm.medicina.ulisboa.pt!

This project uses:
- [Docker Compose][] to manage multiple Docker containers
- [Nginx][] as a reverse proxy (i.e. to redirect URLs), to serve SSL
certificates and to show a public folder
- [ShinyProxy][] to run R/Shiny and Python apps via Docker
- [Celery][] to run background tasks via a job queue system
  - [Flower][] to monitor Celery and to send jobs to Celery via its REST API
  - [Redis][] to serve as message broker for celery
- [Prometheus][] and [Grafana][] to log and visualise ShinyProxy and Celery data
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

## Set up the app server

Go to the project folder and run:

1. [`./shinyproxy/download-shinyproxy-dockers.sh`][downloadDockers] to
automatically pull Docker images used in ShinyProxy
2. `docker-compose up -d --build` to build local Docker images, download the
remote images and start the server

[downloadDockers]: shinyproxy/download-shinyproxy-dockers.sh

### Other relevant commands

- `docker-compose down`: stop the server and all services
- `docker-compose restart shinyproxy`: restart a specific service (in this case,
`shinyproxy`); useful after changing the configuration of a single service and
to avoid restarting the whole server
- `docker-compose logs nginx`: print logs of a specific service (in this case,
`nginx`)
- `docker-compose -h`: show further documentation

## Relevant assets

Asset                                           | Description
----------------------------------------------- | --------------------------------------------------------------------
[`docker-compose.yml`](docker-compose.yml)      | Docker Compose configuration
[`nginx`](nginx)                                | Nginx configuration files (main one is [`nginx.conf`][nginx.conf])
[`shinyproxy/application.yml`][application.yml] | ShinyProxy configuration (including Shiny apps)
[`shinyproxy/templates`](shinyproxy/templates)  | ShinyProxy custom HTML files
[`celery/tasks.py`](celery/tasks.py)            | Celery tasks
[`public`](public)                              | Publicly available data downloadable at [`/public`][public]

[application.yml]: shinyproxy/application.yml
[nginx.conf]: nginx/nginx.conf
[public]: https://compbio.imm.medicina.ulisboa.pt/public

## Next steps

- [Add and update apps in ShinyProxy](shinyproxy)
- [SSL certificate renewal](nginx)

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
