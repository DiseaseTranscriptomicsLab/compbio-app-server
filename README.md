# nmorais app server

This project uses:
- [Docker Compose][] to run multiple Docker containers
- [Shinyproxy][] to run multiple containers from Docker images of shiny apps
  - The **TIG ([Telegraf][], [InfluxDB][], [Grafana][])** stack to log shinyproxy usage data
- [Celery][] to run background tasks via a job queue system
  - [Flower][] to monitor Celery and to send jobs to Celery via its REST API
  - [Redis][] to serve as message broker for celery
  - [Prometheus][] and [Grafana][] to log and visualise Celery data
- [MySQL][] as the database server
- [RStudio Server][] to test code on-the-fly

[Docker Compose]: https://docs.docker.com/compose/
[Shinyproxy]: https://shinyproxy.io
[InfluxDB]: https://www.influxdata.com
[Telegraf]: https://www.influxdata.com/time-series-platform/telegraf/
[Grafana]: https://grafana.com
[Celery]: https://docs.celeryproject.org/
[Flower]: https://flower.readthedocs.io/en/latest/
[Redis]: https://redis.io
[Prometheus]: https://prometheus.io
[MySQL]: https://www.mysql.com
[RStudio Server]: https://www.rstudio.com/products/rstudio/

## Run and stop

Go to the project folder and run:

- `docker-compose up -d --build` to build the local Docker images,
download the remote images and start the service.
- `docker-compose down` to stop the service.
- `docker-compose -h` for documentation.

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
