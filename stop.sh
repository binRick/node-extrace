#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

killall -9 extrace

systemctl stop node-extrace

systemctl disable node-extrace

systemctl status node-extrace

