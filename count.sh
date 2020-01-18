#!/bin/bash
cmd="mysql extrace -e \"select COUNT(*) from execs\""

echo $cmd
eval $cmd
