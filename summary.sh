#!/bin/bash
doSQL(){
    SQL="$1"
    cmd="mysql extrace -e \"$SQL\""
    echo $cmd
    eval $cmd

}

doSumColumn(){
    echo "$1 $2 Sum:"
    doSQL "SELECT $1, SUM($2) as total_time \
    FROM execs \
    GROUP BY $1 \
    ORDER BY total_time DESC \
    LIMIT 5"
    echo
}
doFrequencyColumn(){
    echo "$1 Frequency:"
    doSQL "SELECT $1, COUNT(*) as frequency \
    FROM execs \
    GROUP BY $1 \
    ORDER BY frequency DESC \
    LIMIT 5"
    echo
}

doSummary(){
    clear
    doSQL "select distinct exec from execs"
    doFrequencyColumn exec
    doFrequencyColumn user
    doFrequencyColumn exit_code
    doSumColumn exec time_ms
}


doSummary

