#!/bin/bash
set -ex

git pull

if [[ ! -f /usr/libexec/mysqld ]]; then
    dnf -y install mariadb-server
fi

systemctl enable mariadb
systemctl start mariadb

if [[ ! -f /usr/local/bin/node ]]; then
 if [[ ! -f /usr/bin/n ]]; then
 set -e
 (
    dnf -y install nodejs
    n stable
    /usr/local/bin/node --version
 )
    
 fi
fi


if [[ ! -f /usr/local/bin/extrace ]]; then
 (
    if [ -d ~/.extrace-src ]; then 
        rm -rf ~/.extrace-src
    fi
    git clone https://github.com/leahneukirchen/extrace ~/.extrace-src
    cd ~/.extrace-src
    make install
 )   
    
fi

command -v extrace

npm i

./createSql.sh

cp -prvf node-extrace.service /etc/systemd/system/.

systemctl daemon-reload

set +e
sleep 2
./stop.sh
sleep 2
./start.sh
sleep 2
./start.sh
