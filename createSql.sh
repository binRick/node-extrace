#!/bin/bash
mysql -e "create database extrace"
mysql extrace < execs.sql
