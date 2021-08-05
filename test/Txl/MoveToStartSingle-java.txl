% MoveToStartSingle-java.txl: Move a single statement from a list 
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartSingle]
end function

rule MoveToStartSingle
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        ...
    by
        ..
        'int x '= e1';
        ...
end rule