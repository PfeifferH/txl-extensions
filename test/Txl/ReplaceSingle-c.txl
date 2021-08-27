% ReplaceSingle-c.txl: Replace a variable initialization with an arbitrary expression
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceSingle]
end function

rule ReplaceSingle
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [multiplicative_expression] '+ e2 [multiplicative_expression]';
        ...
    by
        ...
        'int x '= 2';
        ...
end rule
