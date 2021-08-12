FROM rocker/rstudio

RUN R -e "install.packages('devtools')"

#RUN apt-get update && apt-get install -y redis
#RUN apt-get install -y libzmq3-dev

RUN apt-get update && apt-get install -y libmysqlclient-dev
#RUN R -e "devtools::install_github('lecardozo/rworker')"
RUN R -e "install.packages('RMariaDB')"
