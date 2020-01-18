#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set +e
set -x
systemctl restart node-extrace

systemctl enable node-extrace

systemctl status node-extrace

