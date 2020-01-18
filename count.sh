#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cmd="mysql extrace -e \"select COUNT(*) from execs\""

echo $cmd
eval $cmd
