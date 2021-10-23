# ShinyProxy

[ShinyProxy][] is open-source and allows to deploy R/Shiny and Python apps via
Docker images.

[ShinyProxy]: https://shinyproxy.io

## Add new apps to ShinyProxy

### 1. [Create a Docker image of your app][deploying]

I suggest uploading your Docker image to DockerHub and then pulling it from the
app server, e.g.:

```bash
docker pull nunoagostinho/psichomics:latest
```

[deploying]: https://shinyproxy.io/documentation/deploying-apps/

### 2. Configure ShinyProxy in [`application.yml`][application.yml]

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

[application.yml]: application.yml
[app-config]: https://shinyproxy.io/documentation/configuration/#apps

### 3. Slow down the progress bar when opening an app (optional)

When loading apps, a progress bar is displayed that fills in 5 seconds. If your
app takes more time to start, you should customise the time taken to fill the
bar. To do so, open [`templates/assets/shinyproxy.css`][shinyproxy.css] and add
the following line to the end of the file:

```css
.progress-psichomics { transition: width 20s ease-in-out; }
```

Replace `psichomics` with your app ID (defined in step 2) and replace `20s` with
the desired amount of seconds.

After saving the file, the change will be automatically applied next time you
open your app in the server.

[shinyproxy.css]: templates/assets/shinyproxy.css

### 4. Redirect from an URL location via Nginx (optional)

All apps in ShinyProxy are served via an intermediary path:

- `/app/appID`: application with the site-wide navigation bar on top
- `/app_direct/appID`: only the application itself

For an app to be available from `/appID`, use Nginx to redirect the path
`/appID` to `/app/appID` using a [307 Temporary Redirect][307] status code.
To do so, open [`../nginx/location_apps.conf`][location_apps.conf] and add
the following command at the end of the file:

```nginx
location = /appID { return 307 /app/appID; }
```

After saving the file, restart Nginx to test out your new link:

```bash
docker-compose restart nginx
```

[307]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/307
[location_apps.conf]: ../nginx/location_apps.conf

## Update apps in ShinyProxy

1. Pull the latest Docker image available to the app server
2. Modify the `container-image` in [`application.yml`][application.yml] to
include the latest version of the Docker image (if applicable)
3. Restart ShinyProxy: `docker-compose restart shinyproxy`

## Custom ShinyProxy HTML

Custom HTML pages are available in [`templates`](templates):

File                                 | Description
-------------------------------------|---------------------------------
[`index.html`](templates/index.html) | Landing page with app list
[`app.html`](templates/app.html)     | Apps
[`error.html`](templates/error.html) | Errors (e.g. 404 page not found)
[`fragments`](templates/fragments)   | Reusable HTML code (page headers and navigation bar)
[`assets/shinyproxy.css`](assets/shinyproxy.css) | CSS code

> Error pages are shown when ShinyProxy is working. Otherwise, if ShinyProxy is
down/unresponsive, a [custom Nginx error][nginx-error] is shown.

[nginx-error]: ../nginx#custom-html-pages-eg-502-error-page

More HTML pages can be customised from ShinyProxy if needed: read
[ShinyProxy's custom HTML template][custom-HTML].

[custom-HTML]: https://github.com/openanalytics/shinyproxy-config-examples/tree/master/04-custom-html-template
