#!/bin/sh

# Helper functions -------------------------------------------------------------

colour () {
    COL=$1; shift
    NC='\033[0m' # No Color
    printf "${COL}$@${NC}\n"
}
msg    () { colour '\033[0;35m' "\n$@"; }
inform () { colour '\033[0;33m' $@; }
error  () { colour '\033[0;31m' $@; }

url () {
    ret=$( curl -sI $1 )
    ret=${ret:-"null"}
    echo $ret
}

FAIL=0

assertThat () {
    message="$1"
    string=$( url "$2")
    condition="$3"
    
    echo message:   $message
    echo string:    $string
    echo condition: $condition
    
    printf "$message: "

    countError () { error "FAILED"; let "FAIL++"; }
    echo "$string" | grep -q "$condition" && inform "OK" || countError
}

# Unit tests -------------------------------------------------------------------

docker-compose up -d
sleep 60

# nginx
msg "Testing nginx..."
nginx=http://localhost
assertThat "nginx is healthy" $nginx "200 OK"
assertThat "nginx as server" $nginx "Server: nginx"

# test random page
random=http://localhost/random
assertThat "localhost/random expected to return 404 Not Found" \
  $random "404 Not Found"

# shinyproxy
msg "Testing shinyproxy..."
shinyproxy=http://localhost:8080
assertThat "shinyproxy is healthy" $shinyproxy "200 OK"

# plausible
plausible=http://localhost:8000
assertThat "plausible redirects to login" $plausible "302 Found"

plausible_login=http://localhost:8000/login
assertThat "plausible login is healthy" $plausible_login "200 OK"

if [ "$FAIL" -gt 0 ]; then error "\nERROR: $FAIL test(s) failed"; exit 1; fi
