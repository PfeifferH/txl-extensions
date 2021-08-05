% MoveToStartSingle-c.txl: Move a single statement from a list to the start
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartSingle]
end function

rule MoveToStartSingle
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        ...
    by
        ..
        'int x '= e1';
        ...
end rule