% MoveToEndSingle-java.txl: Move a statement to the end of a sequence
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToEndSingle]
end function

rule MoveToEndSingle
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        ...
    by
        ...
        'int x '= e1';
        ..
end rule