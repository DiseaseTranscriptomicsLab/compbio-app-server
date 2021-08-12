FROM bioconductor/bioconductor_docker:RELEASE_3_13
LABEL maintainer="Nuno Agostinho <nunodanielagostinho@gmail.com>"

RUN apt-get update && apt-get install -y python3 python3-pip

# Install Python packages
RUN pip3 install --no-cache-dir redis flower

# PYTHONUNBUFFERED: force unbuffered stdin, stdout and stderr (`python -u`)
# PYTHONHASHSEED: enable hash randomization (`python -R`)
# PYTHONDONTWRITEBYTECODE: do not write to disk - readonly (`python -B`)
ENV PYTHONUNBUFFERED=1 PYTHONHASHSEED=random PYTHONDONTWRITEBYTECODE=1

# Prepare data folders
ENV FLOWER_DATA_DIR /celery
ENV PYTHONPATH ${FLOWER_DATA_DIR}
WORKDIR /data

# Default port
EXPOSE 5555

# Install R packages
RUN R -e "install.packages(c('BiocManager', 'shiny'))"
RUN R -e "BiocManager::install('cTRAP')"
