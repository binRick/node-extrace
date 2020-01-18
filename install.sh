#!/bin/bash
set -ex

git pull

if [[ ! -f /usr/libexec/mysqld ]]; then
    dnf -y install mariadb-server
fi

systemctl enable mariadb
systemctl start mariadb

if [[ ! -f /usr/bin/npm ]]; then
 (
    dnf -y install nodejs
 )
fi
command -v npm
command -v node


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

sleep 2
./stop.sh
sleep 2
./start.sh
