#!/bin/sh
run() {
  "$@"
  result=$?
  if [ $result -ne 0 ]
  then
    echo "Failed: $@ [$PWD]" >&2
    #exit $resul
    exit 1
  fi
  return 0
}

# Install mongodb
# ---------------
if [ -z `which mongo` ]; then
  echo '--install mongodb--'
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
  sudo apt-get update
  sudo apt-get install mongodb-10gen

  echo '--start mongodb--'
  sudo service mongodb start
fi
