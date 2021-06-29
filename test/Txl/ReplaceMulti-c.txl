% ReplaceMulti-c.txl: Replace multiple statements with single statement in c
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceMulti]
end function

rule ReplaceMulti
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        'if '( x '> e2 [additive_expression] ') '{ 
            x '= e2'; 
        '}
        ...
    by
        ...
        'int x '= 'min(0 ', 'max( e1 ', e2 '));
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        ...
end rule
