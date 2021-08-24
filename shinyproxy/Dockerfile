FROM openanalytics/shinyproxy:2.5.0 AS shinyproxy

FROM openjdk:8-jre
RUN mkdir -p /opt/shinyproxy/
WORKDIR /opt/shinyproxy/

COPY --from=shinyproxy /opt/shinyproxy/shinyproxy.jar .

CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
