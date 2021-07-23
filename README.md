# txl-extensions

[Txl](http://txl.ca/) is a unique programming language specifically designed to support computer software analysis and source transformation tasks. It is the evolving result of more than fifteen years of concentrated research on rule-based structural transformation as a paradigm for the rapid solution of complex computing problems.

This project aims to design and implement extensions of Txl using itself to transform prototype language features into its current version FreeTxl 10.8.

A TXL installation is required to execute the rules in this project, and can be obtained at https://www.txl.ca/txl-download.html

# Usage

To transform TXL rules utilizing the anchored "..." notation, perform a TXL transformation using `txl <your txl file> rules/AnchoredDots.txl`

Example: `txl test/txl/MoveToStartMulti-Turing.txl rules/AnchoredDots.txl > test/transforms/temp-MoveToStartMulti-Turing.txl`

To transform all TXL files in the `test/txl` directory, run `test/runTests.sh rules/AnchoredDots.txl`. This will save each test file transformation as `test/transforms/temp-<filename>`

This will also create the transformation for each target language (`test/Turing`, `test/c`, and `test/java`) in the `test/output` directory. 

To view further options of the testing script, view its usage with the `-u` flag. 
