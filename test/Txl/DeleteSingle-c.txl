% DeleteSingle-c.txl: Delete a single Turing statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteSingle]
end function

rule DeleteSingle
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        ...
    by
        ...
end rule
