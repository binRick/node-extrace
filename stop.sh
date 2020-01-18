#!/bin/bash
set -ex

systemctl stop node-extrace

systemctl disable node-extrace

systemctl status node-extrace

