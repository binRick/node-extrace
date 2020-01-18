#!/bin/bash

killall -9 extrace

set -ex
systemctl stop node-extrace

systemctl disable node-extrace

systemctl status node-extrace

