#!/bin/bash
set -ex

git pull

npm i

./createSql.sh

cp -prvf node-extrace.service /etc/systemd/system/.

systemctl enable node-extrace

systemctl start node-extrace

systemctl status node-extrace

