% ReplaceMultiOuter-java.txl: Replace multiple java statements with statements inside and outside of dotDotDots
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceMultiOuter]
end function

rule ReplaceMultiOuter
    replace [repeat declaration_or_statement]
        'int x [id] '= e1 [expression]';
        ...
        'if '( x '< 0 ') '{ 
            x '= 0'; 
        '}
        ...
        'if '( x '> e2 [shift_expression] ') '{
            x '= e2'; 
        '}
        OuterTail [repeat declaration_or_statement]
    by
        'int x '= 1';
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
