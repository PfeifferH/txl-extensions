% ReplaceMultiOuter-java.txl: Replace multiple c statements with statements inside and outside of dotDotDots
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceMultiOuter]
end function

rule ReplaceMultiOuter
    replace [repeat block_item]
        'int x [id] '= e1 [assignment_expression]';
        ...
        'if '( x '< 0 ') '{ 
            x '= 0'; 
        '}
        ...
        'if '( x '> e2 [additive_expression] ') '{
            x '= e2'; 
        '}
        OuterTail [repeat block_item]
    by
        'int x '= 1
        ...
        'if '( x '> e2 ') '{ 
            x '= e2'; 
        '}
        ...
        'if '( x '< 0 ') '{ 
            x '= 0';
        '}
        OuterTail
end rule
