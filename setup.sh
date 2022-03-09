#!/bin/bash
ROOT=$(dirname "$0")

NGINX_DIR=$ROOT/nginx
NGINX_CONFIG=$NGINX_DIR/nginx.conf

SHINYPROXY_DIR=$ROOT/shinyproxy
SHINYPROXY_CONFIG=$SHINYPROXY_DIR/application.yml
SHINY_APPS_DIR=$SHINYPROXY_DIR/shiny-apps

msg () {
    COL='\033[0;33m'
    NO_COL='\033[0m' # No Color
    echo -e "\n${COL}$@${NO_COL}"
}

# Building necessary Docker images --------------------------------------------
msg "Preparing Docker images for services..."
docker compose pull
docker compose build

msg "Preparing Docker images for ShinyProxy apps..."
./${SHINYPROXY_DIR}/setup-shinyproxy.sh

msg "Preparing Nginx and ShinyProxy config files from default..."

copyDefault () {
    if [[ -f "$1" ]]; then
      mv $1 $1.bkp
      msg "  - File $1 already existed and was renamed $1.bkp"
    fi
    cp $1.default $1
}

copyDefault $NGINX_CONFIG
copyDefault $SHINYPROXY_CONFIG
