#!/bin/bash
SQL="select distinct exec from execs"
cmd="mysql extrace -e \"$SQL\""

echo $cmd
eval $cmd
