# nmorais app server

This project uses:
- [Docker Compose][] to manage multiple Docker containers
- [Nginx][] to redirect URLs and serve SSL certificates
- [ShinyProxy][] to run Shiny apps via Docker
  - The **TIG ([Telegraf][], [InfluxDB][], [Grafana][])** stack to log
  shinyproxy usage data
- [Celery][] to run background tasks via a job queue system
  - [Flower][] to monitor Celery and to send jobs to Celery via its REST API
  - [Redis][] to serve as message broker for celery
  - [Prometheus][] and [Grafana][] to log and visualise Celery data
- [MySQL][] as the database server
- [RStudio Server][] to test code on-the-fly

[Docker Compose]: https://docs.docker.com/compose/
[ShinyProxy]: https://shinyproxy.io
[InfluxDB]: https://www.influxdata.com
[Telegraf]: https://www.influxdata.com/time-series-platform/telegraf/
[Grafana]: https://grafana.com
[Celery]: https://docs.celeryproject.org/
[Flower]: https://flower.readthedocs.io/en/latest/
[Redis]: https://redis.io
[Prometheus]: https://prometheus.io
[MySQL]: https://www.mysql.com
[RStudio Server]: https://www.rstudio.com/products/rstudio/
[Nginx]: https://nginx.org

## Run and stop

Go to the project folder and run:

1. `./shinyproxy/download-shinyproxy-dockers.sh` to download Docker images
to be run via ShinyProxy.
2. `docker-compose up -d --build` to build the local Docker images,
download the remote images and start the service.

Other relevant commands:

- `docker-compose down` to stop the service.
- `docker-compose -h` for documentation.

## SSL certificates renewal

SSL certificates are maintained via [Nginx][] to provide encrypted HTTPS
traffic. SSL certificates expire and need to be renewed after some time
(e.g. one year). After replacing the SSL certificates:

1. In case the filename of the SSL certificate changes, open the file
[nginx/nginx.conf](nginx/nginx.conf) and replace the path to the
certificates (in `ssl_certificate` and `ssl_certificate_key`)

2. Manually restart Nginx with the command `docker-compose restart nginx`

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
