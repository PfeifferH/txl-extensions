% ReplaceSingle-java.txl: Replace a single assignement expression with a constant
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceSingle]
end function

rule ReplaceSingle
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [multiplicative_expression] '+ e2 [multiplicative_expression]';
        ...
    by
        ...
        'int x '= 2';
        ...
end rule
