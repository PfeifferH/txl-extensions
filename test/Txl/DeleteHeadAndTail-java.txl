% DeleteHeadAndTail-java.txl: Delete all surrounding statements
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteHeadAndTail]
end function

function DeleteHeadAndTail
    replace * [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        ...
    by
        'int x '= e1';
end function