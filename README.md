# CompBio app server

Visit our website at https://compbio.imm.medicina.ulisboa.pt!

This project uses:
- [Docker Compose][] to manage multiple Docker containers
- [Nginx][] as a reverse proxy (i.e. to redirect URLs), to serve SSL
certificates and to show a public folder
- [ShinyProxy][] to run R/Shiny and Python apps via Docker
  - The **TIG ([Telegraf][], [InfluxDB][], [Grafana][])** stack to log
  ShinyProxy usage data
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

## Run and stop the server

Go to the project folder and run:

1. `./shinyproxy/download-shinyproxy-dockers.sh` to automatically pull Docker
images used in ShinyProxy.
2. `docker-compose up -d --build` to build local Docker images, download the
remote images and start the server.

Other relevant commands:

- `docker-compose down` to stop the service.
- `docker-compose restart shinyproxy` to restart a specific service (in this
case, `shinyproxy`); useful after changing the configuration of a single service
and to avoid restarting the whole server.
- `docker-compose logs nginx` to get the logs of a specific service (in this
case, `nginx`).
- `docker-compose -h` for documentation.

## Public folder

Files and directories in the [public](public) folder will be downloadable from
the `/public` path of the website, e.g.:
https://compbio.imm.medicina.ulisboa.pt/public.

This configuration can be found in [nginx/nginx.conf](nginx/nginx.conf).

## SSL certificate renewal

SSL certificates are maintained via [Nginx][] for encrypted HTTPS traffic. These
certificates need to be renewed frequently (e.g. every year). To do so, after
replacing the SSL certificate files:

1. In case the filename of the SSL certificate changes, open the file
[nginx/nginx.conf](nginx/nginx.conf) and replace the path to the certificates
(in `ssl_certificate` and `ssl_certificate_key`)

2. Manually restart Nginx with the command `docker-compose restart nginx`

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
