% DeleteHeadAndTail-c.txl: Delete all surrounding statements
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteHeadAndTail]
end function

function DeleteHeadAndTail
    replace * [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        ...
    by
        'int x '= e1';
end function