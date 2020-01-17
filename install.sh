#!/bin/bash
set -ex

git pull

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

command extrace -v

npm i

./createSql.sh

cp -prvf node-extrace.service /etc/systemd/system/.

systemctl daemon-reload

systemctl enable node-extrace

systemctl start node-extrace

systemctl status node-extrace

