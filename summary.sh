#!/bin/bash
doSQL(){
    SQL="$1"
    cmd="mysql extrace -e \"$SQL\""
    echo $cmd
    eval $cmd

}
doSQL "select distinct exec from execs"

doSQL "SELECT exec, COUNT(*) as frequency \
FROM execs \
GROUP BY exec \
ORDER BY COUNT(*) DESC \
LIMIT 25"
