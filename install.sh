#!/bin/bash
set -ex

git pull

if [[ ! -f /usr/sbin/mysqld ]]; then
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

systemctl enable node-extrace

systemctl restart node-extrace

systemctl status node-extrace

