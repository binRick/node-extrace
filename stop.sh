#!/bin/bash

killall -9 extrace

systemctl stop node-extrace

systemctl disable node-extrace

systemctl status node-extrace

