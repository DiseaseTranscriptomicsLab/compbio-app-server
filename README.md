# nmorais apps

This project uses:
- `docker-compose` to run multiple Docker containers
- `shinyproxy` to run multiple containers from Docker images of shiny apps
- The **TIG (Telegraf, InfluxDB, Grafana)** stack to log usage data

## Run and stop

To setup this service, go to the project folder and run:

```
docker-compose build              # build Docker images
docker-compose up -d shinyproxy   # run shinyproxy in detached mode
```

To stop the service, run `docker-compose down`.

More commands available in the help documentation: `docker-compose -h`.

## Sources of inspiration

- [shrektan/shinyproxy-docker-compose-example][shrektan]
- [kassambara/shinyproxy-config][kassambra]

shrektan: https://github.com/shrektan/shinyproxy-docker-compose-example
kassambra: https://github.com/kassambara/shinyproxy-config
