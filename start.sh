#!/bin/bash
set -e
set +x
systemctl restart node-extrace

systemctl enable node-extrace

systemctl status node-extrace

