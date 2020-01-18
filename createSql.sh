#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
mysql -e "drop database extrace" 2>/dev/null
mysql -e "create database extrace"
mysql extrace < execs.sql
