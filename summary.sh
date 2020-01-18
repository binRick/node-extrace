#!/bin/bash
doSQL(){
    SQL="$1"
    cmd="mysql extrace -e \"$SQL\""
    echo $cmd
    eval $cmd

}

doSumColumn(){
    echo "$1 $2 Sum:"
    QTY=$4
    doSQL "SELECT $1, SUM($2) as \\\`$3\\\` \
    FROM execs \
    GROUP BY $1 \
    ORDER BY \\\`$3\\\` DESC \
    LIMIT $QTY"
    echo
}
doFrequencyColumn(){
    QTY=$2
    echo "$1 Frequency:"
    doSQL "SELECT $1, COUNT(*) as frequency \
    FROM execs \
    GROUP BY $1 \
    ORDER BY frequency DESC \
    LIMIT $QTY"
    echo
}

doSummary(){
    clear
    doSQL "select distinct exec from execs"
    doFrequencyColumn exec 10
    doFrequencyColumn user 5
    doFrequencyColumn exit_code 10
    doSumColumn exec time_ms "Total Time" 15
}


doSummary

