% MoveToEndSingle-c.txl: Move a statement to the end of a sequence
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToEndSingle]
end function

rule MoveToEndSingle
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        ...
    by
        ...
        'int x '= e1';
end rule