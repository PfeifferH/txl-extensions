#!/bin/bash

if [[ $1 == "-u" || $# -gt 2 ]]; then
   echo "Usage: runTests.sh [-u | -t] <txl rule>.
   Transformations of all test files in test/txl are generated to be located in test/transforms, and transformation of each test for the target languages are stored in test/output. 
   This script must be run from inside local project root dir.
   
   Options:
   -u: Display usage
   -t: Perform rule transform only"

else
    if [[ $1 == "-t" ]]; then
        rule=$2
    else
        rule=$1
        mkdir -p test/output
    fi

    mkdir -p test/transforms
    
    for FILE in test/Txl/*.txl; do
        f="$(basename -- $FILE)"
        transform=test/transforms/temp-$f
        name=$(echo "$f" | cut -f 1 -d '.')
        txl $FILE $rule > $transform
        if [[ $1 != "-t" ]]; then
            if [[ $f == *"-Turing"* ]]; then
                for TuringProgram in test/Turing/*.tu; do
                    t="$(basename -- $TuringProgram)"
                    txl $TuringProgram $transform > test/output/temp-$name-$t
                done
            fi
            if [[ $f == *"-c"* ]]; then
                for CProgram in test/c/*.c; do
                    c="$(basename -- $CProgram)"
                    txl $CProgram $transform > test/output/temp-$name-$c
                done
            fi        
            if [[ $f == *"-java"* ]]; then
                for JavaProgram in test/java/*.java; do
                    j="$(basename -- $JavaProgram)"
                    txl $JavaProgram $transform > test/output/temp-$name-$j
                done
            fi
        fi
    done
fi