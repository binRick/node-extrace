#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
./count.sh


cmd="mysql extrace -e \"delete from execs\""
echo $cmd
eval $cmd

./count.sh
