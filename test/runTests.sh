#!/bin/bash

if [[ $1 -eq "-u" || $# -ne 1 ]]; then
   echo "Usage: runTests.sh <txl rule>. This script runs 'txl test' on all pt files in the passed in directory, and stores outputs as *.eoutput. This script must be run from inside local ptsrc (project root) dir. For now, the immediate output files are in project root."

else
    for FILE in test/Txl/*.txl; do
        f="$(basename -- $FILE)"
        txl $FILE $1 > test/output/temp-$f
    done
fi