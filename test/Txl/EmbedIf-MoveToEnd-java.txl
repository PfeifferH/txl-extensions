% EmbedIf-MoveToEnd-java.txl: Resolve embedded statements within an if statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [EmbedIf]
end function

rule EmbedIf
    replace [repeat declaration_or_statement]
        'if '( x [id] '== 1 ') '{
            ...
            'int y [id] '= e1 [expression]';
            ...
        '}
        OuterTail [repeat declaration_or_statement]
    by
        'if '( x '== 1 ') '{
            ...
            'int y '= e1';
            ..
        '}
        OuterTail
end rule