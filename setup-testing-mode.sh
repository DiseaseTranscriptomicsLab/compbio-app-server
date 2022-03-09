#!/bin/bash
ROOT=$(dirname "$0")

NGINX_DIR=$ROOT/nginx
NGINX_CONFIG=$NGINX_DIR/nginx.conf

SHINYPROXY_DIR=$ROOT/shinyproxy
SHINYPROXY_DIR_REALPATH=$( realpath $SHINYPROXY_DIR )
SHINYPROXY_CONFIG=$SHINYPROXY_DIR/application.yml
SHINY_APPS_DIR=$SHINYPROXY_DIR/shiny-apps

msg () {
    COL='\033[0;33m'
    NO_COL='\033[0m' # No Color
    echo -e "\n${COL}$@${NO_COL}"
}

${ROOT}/setup.sh

# Ignore SSL certificates -----------------------------------------------------
msg "Modifying files to ignore SSL certificates in testing..."

sed -i.bak -E 's/443 ssl/80/' $NGINX_CONFIG
sed -i.bak -E '/ssl/s/( *)/\1#/' $NGINX_CONFIG
msg "  - Successfully changed $NGINX_CONFIG"

sed -i.bak -E 's/(server:)/#\1/' $SHINYPROXY_CONFIG
sed -i.bak -E 's/(secure-cookies:)/#\1/' $SHINYPROXY_CONFIG
sed -i.bak -E 's/(forward-headers-strategy:)/#\1/' $SHINYPROXY_CONFIG
sed -i.bak -E 's/(frame-options:)/#\1/' $SHINYPROXY_CONFIG
msg "  - Successfully changed $SHINYPROXY_CONFIG"

# Setup test directories ------------------------------------------------------
echo
msg "Setting up directories for ShinyProxy apps in $SHINY_APPS_DIR..."

# Create test dirs
test_dirs=$(grep -o "/srv.*:" $SHINYPROXY_CONFIG | \
            sed "s|/srv/apps|$SHINY_APPS_DIR|g" | sed 's/://g')
for i in ${test_dirs}; do mkdir -p $i; done

# Change ShinyProxy app directories used in shinyproxy/application.yml
sed -i.bak "s|/srv|$SHINYPROXY_DIR_REALPATH|g" $SHINYPROXY_CONFIG
msg "  - Done! Add data for apps inside $SHINY_APPS_DIR"

msg "==========================\nEverything seems to be ready! Now simply run:"
msg "  docker-compose up -d"
msg "Then open your browser and go to http://localhost\n"
