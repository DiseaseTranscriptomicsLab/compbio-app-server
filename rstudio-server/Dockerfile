FROM rocker/rstudio

RUN R -e "install.packages('devtools')"

#RUN apt-get update && apt-get install -y redis
#RUN apt-get install -y libzmq3-dev

RUN R -e "remotes::install_github('nuno-agostinho/floweRy')"
