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
LIMIT 5"

doSQL "SELECT user, COUNT(*) as frequency \
FROM execs \
GROUP BY user \
ORDER BY COUNT(*) DESC \
LIMIT 5"

doSQL "SELECT exit_code, COUNT(*) as frequency \
FROM execs \
GROUP BY exit_code \
ORDER BY COUNT(*) DESC \
LIMIT 5"

