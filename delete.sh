#!/bin/bash
cmd="mysql extrace -e \"delete from execs\""

echo $cmd
eval $cmd

./count.sh
