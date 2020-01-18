#!/bin/bash
doSQL(){
    SQL="$1"
    cmd="mysql extrace -e \"$SQL\""
    echo $cmd
    eval $cmd

}

doFrequencyColumn(){
    echo "$1 Frequency:"
    doSQL "SELECT $1, COUNT(*) as frequency \
    FROM execs \
    GROUP BY $1 \
    ORDER BY COUNT(*) DESC \
    LIMIT 5"
    echo
}

doSummary(){
    clear
    doSQL "select distinct exec from execs"
    doFrequencyColumn exec
    doFrequencyColumn user
    doFrequencyColumn exit_code
}


doSummary

