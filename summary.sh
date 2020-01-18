#!/bin/bash
SQL="select distinct exec from execs"
cmd="mysql extrace -e \"$SQL\""
echo $cmd
eval $cmd


SQL="SELECT exec, COUNT(*) as frequency \
FROM execs \
GROUP BY exec \
ORDER BY COUNT(*) DESC \
LIMIT 25; \
"
cmd="mysql extrace -e \"$SQL\""
echo $cmd
eval $cmd
