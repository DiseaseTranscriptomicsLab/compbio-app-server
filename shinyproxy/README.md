# CompBio App Server - ShinyProxy configuration

## Add new apps to ShinyProxy

[ShinyProxy][] deploys Shiny and Python apps via Docker images. Put simply, you
will need to:

[ShinyProxy]: https://shinyproxy.io

### 1. [Create a Docker image of your app][deploying]

I suggest uploading your Docker image to DockerHub and then pulling it from the
app server, e.g.:

```bash
docker pull nunoagostinho/psichomics:latest
```

[deploying]: https://shinyproxy.io/documentation/deploying-apps/

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

[application.yml]: shinyproxy/application.yml
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
status code. To do so, open [nginx/location_apps.conf][location_apps.conf]
and add the following command at the end of the file:

```nginx
location = /appID { return 307 /app/appID; }
```

After saving the file, restart Nginx to test out your new link:

```bash
docker-compose restart nginx
```

[307]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/307
[location_apps.conf]: nginx/location_apps.conf

## Update apps in ShinyProxy

1. Pull the latest Docker image available to the app server
2. Modify the `container-image` in
[`shinyproxy/application.yml`][application.yml] to include the latest version of
the Docker image (if applicable)
3. Restart ShinyProxy: `docker-compose restart shinyproxy`
