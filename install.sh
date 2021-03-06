#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cat /etc/redhat-release |grep 'release 8'  >/dev/null && {
 wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libcgroup-devel-0.41-21.el7.x86_64.rpm;
 wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libcgroup-0.41-21.el7.x86_64.rpm;
 wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libcgroup-tools-0.41-21.el7.x86_64.rpm;
 wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libcgroup-pam-0.41-21.el7.x86_64.rpm;
 rpm -Uvh libcgroup*rpm;
}

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
