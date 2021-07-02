# txl-extensions

[Txl](http://txl.ca/) is a unique programming language specifically designed to support computer software analysis and source transformation tasks. It is the evolving result of more than fifteen years of concentrated research on rule-based structural transformation as a paradigm for the rapid solution of complex computing problems.

This project aims to design and implement extensions of Txl using itself to transform prototype language features into its current version FreeTxl 10.8.

A TXL installation is required to execute the rules in this project, and can be obtained at https://www.txl.ca/txl-download.html

# Usage

To transform TXL rules utilizing the "..." notation, perform a TXL transformation using `txl <your txl file> rules/EmbeddedSequence.txl`

To transform all TXL files in the `test/txl` directory, run `test/runTests/sh rules/EmbeddedSequence.txl`