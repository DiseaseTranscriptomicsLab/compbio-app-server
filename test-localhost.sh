#!/bin/zsh

# Helper functions -------------------------------------------------------------

colour () {
    COL=$1; shift
    NC='\033[0m' # No Color
    printf "${COL}$@${NC}\n"
}
msg    () { colour '\033[0;35m' "\n$@" }
inform () { colour '\033[0;33m' $@ }
error  () { colour '\033[0;31m' $@ }

assertThat () {
    message=$1
    string=$2
    condition=$3
    printf "$message: "
    echo $string | grep -q $condition && inform "OK" || error "FAILED"
}

function url() {
    ret=$( curl -sI $1 )
    ret=${ret:-"null"}
    echo $ret
}

# Unit tests -------------------------------------------------------------------

docker-compose up -d
sleep 30

# nginx
msg "Testing nginx..."
nginx=$( url http://localhost )
assertThat "nginx is healthy" $nginx "200 OK"
assertThat "nginx as server" $nginx "Server: nginx"

# test random page
random=$( url http://localhost/random )
assertThat "localhost/random expected to return 404 Not Found" \
  $random "404 Not Found"

# shinyproxy
msg "Testing shinyproxy..."
shinyproxy=$( url http://localhost:8080 )
assertThat "shinyproxy is healthy" $shinyproxy "200 OK"

# plausible
plausible=$( url http://localhost:8000 )
assertThat "plausible redirects to login" $plausible "302 Found"

plausible_login=$( url http://localhost:8000/login )
assertThat "plausible login is healthy" $plausible_login "200 OK"

