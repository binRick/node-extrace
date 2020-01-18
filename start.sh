#!/bin/bash
set -ex

systemctl restart node-extrace

systemctl enable node-extrace

systemctl status node-extrace

