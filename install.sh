#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

set -ex
git pull

if [[ "$__NODE_EXTRACE_INSTALL" != "1" ]]; then
    __NODE_EXTRACE_INSTALL=1 exec ${BASH_SOURCE[0]} $@
fi




if [[ ! -f /usr/libexec/mysqld ]]; then
    dnf -y install mariadb-server
fi

systemctl enable mariadb
systemctl start mariadb

if [[ ! -f /usr/local/bin/node ]]; then
 if [[ ! -f /usr/bin/n ]]; then
 set -e
 (
    dnf -y install nodejs npm
    n stable
    dnf -y remove nodejs npm
 )
    
 fi
fi

set -ex
/usr/local/bin/node --version
/usr/local/bin/npm --version

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

/usr/local/bin/npm i

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
