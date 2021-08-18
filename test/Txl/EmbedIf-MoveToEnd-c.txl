% EmbedIf-MoveToEnd-c.txl: Resolve embedded statements within an if statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [EmbedIf]
end function

rule EmbedIf
    replace [repeat block_item]
        'if '( x [id] '== 1 ') '{
            ...
            'int y [id] '= e1 [assignment_expression]';
            ...
        '}
        OuterTail [repeat block_item]
    by
        'if '( x '== 1 ') '{
            ...
            'int y '= e1';
            ..
        '}
        OuterTail
end rule