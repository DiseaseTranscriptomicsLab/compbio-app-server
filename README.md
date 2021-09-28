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

## Add new apps to ShinyProxy

[ShinyProxy][] deploys Shiny and Python apps via Docker images. Put simply, you
will need to:

### 1. [Create a Docker image of your app][deploying]

I suggest uploading your Docker image to DockerHub and then pulling it from the
app server, e.g.:

```bash
docker pull nunoagostinho/psichomics:latest
```

[Deploying]: https://shinyproxy.io/documentation/deploying-apps/

### 2. Configure ShinyProxy in [`shinyproxy/application.yml`][application.yml]

Include a block of text related to your app at the end of the file, for
instance:

```yml
  - id: psichomics
    description: Alternative splicing quantification, visualisation and analysis
    container-image: nunoagostinho/psichomics:dev
    container-cmd: ["R", "-e", "psichomics::psichomics(host='0.0.0.0', port=3838)"]
    container-network: "${proxy.docker.container-network}"
    container-volumes: [ "/srv/apps/psichomics/data:/root/Downloads" ]
```

You can edit any field you want with the exception of
`container-network: "${proxy.docker.container-network}"`: this is required for
ShinyProxy to communicate with the Docker image inside Docker Compose.
[Read more details on app configuration for ShinyProxy.][app-config]

> The `container-cmd` can be ignored if the last command inside the Dockerfile
already launches a Shiny app. Just make sure that the Shiny app is launched with
the host as '0.0.0.0' and the port 3838. Otherwise, your Shiny app will not run.

Aftwards, ShinyProxy needs to be restarted. While restarting ShinyProxy, the
website will show you simply **502: Bad Gateway**. This is expected until
ShinyProxy is ready to run and should take around 20 seconds. To restart
ShinyProxy, run:

```bash
docker-compose restart shinyproxy
```

[app-config]: https://shinyproxy.io/documentation/configuration/#apps

### 3. Slow down the progress bar when opening an app (optional)

When loading apps, a progress bar is displayed that fills in 5 seconds. If your
app takes more time to start, you should customise the time taken to fill the
bar. To do so, open [shinyproxy/templates/assets/shinyproxy.css][shinyproxy.css]
and add the following line to the end of the file:

```css
.progress-psichomics { transition: width 20s ease-in-out; }
```

Replace `psichomics` with your app ID (defined in step 2) and replace `20s` with
the desired amount of seconds.

After saving the file, the change will be automatically applied next time you
open your app in the server.

[shinyproxy.css]: shinyproxy/templates/assets/shinyproxy.css

### 4. Redirect from an URL location via Nginx (optional)

All apps in ShinyProxy are served via an intermediary path:

- `/app/appID`: application with the site-wide navigation bar on top
- `/app_direct/appID`: only the application itself

If you want an app to be available directly from `/appID`, the easiest way is to
redirect from `/appID` to `/app/appID` using a [307 Temporary Redirect][307]
status code. To do so, open [nginx/location_apps.conf](nginx/location_apps.conf)
and add the following command at the end of the file:

```nginx
location = /appID { return 307 /app/appID; }
```

After saving the file, restart Nginx to test out your new link:

```bash
docker-compose restart nginx
```

[307]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/307

## Update apps in ShinyProxy

1. Pull the latest Docker image available to the app server
2. Modify the `container-image` in
[`shinyproxy/application.yml`][application.yml] to include the latest version of
the Docker image (if applicable)
3. Restart ShinyProxy: `docker-compose restart shinyproxy`

## SSL certificate renewal

SSL certificates are maintained via [Nginx][] for encrypted HTTPS traffic. These
certificates need to be renewed frequently (e.g. every year). To do so:

1. Update the SSL certificate files

2. In case the filename of the SSL certificate changes, open the file
[`nginx/nginx.conf`][nginx.conf] and replace the path to the certificates
(in `ssl_certificate` and `ssl_certificate_key`)

3. Manually restart Nginx with the command `docker-compose restart nginx`

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

[shrektan]: https://github.com/shrektan/shinyproxy-docker-compose-example
[kassambra]: https://github.com/kassambara/shinyproxy-config
