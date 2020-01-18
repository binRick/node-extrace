#!/bin/bash
./count.sh


cmd="mysql extrace -e \"delete from execs\""
echo $cmd
eval $cmd

./count.sh
