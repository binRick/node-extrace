#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
dnf -y install libcgroup-devel

set -ex
git pull

if [[ "$__NODE_EXTRACE_INSTALL" != "1" ]]; then
    __NODE_EXTRACE_INSTALL=1 exec ${BASH_SOURCE[0]} $@
fi

cp -prvf profile.d_node-extrace.sh /etc/profile.d/node-extrace.sh


if [[ ! -f /usr/bin/cgcreate ]]; then
    dnf -y install libcgroup-tools
fi
if [[ ! -f /usr/libexec/mysqld ]]; then
    dnf -y install mariadb-server
fi

systemctl enable mariadb
systemctl start mariadb

if [[ ! -f /usr/local/bin/node ]]; then
 set -ex
 dnf -y install nodejs npm
 if [[ ! -f /usr/local/bin/n ]]; then
     npm i n -g
     cp $(which n) /usr/local/bin/n
 fi
 /usr/local/bin/n --version
 n stable
 dnf -y remove nodejs npm
fi

set -ex
/usr/local/bin/node --version
/usr/local/bin/npm --version

if [[ ! -f /usr/local/bin/extrace ]]; then
 (
    if [ -d ~/.extrace-src ]; then 
        rm -rf ~/.extrace-src
    fi
    git clone https://github.com/binRick/extrace ~/.extrace-src
    cd ~/.extrace-src
    make pwait
    ./build.sh
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
