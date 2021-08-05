% MoveToStartMulti-c.txl: Move multiple statements to the start of a sequence in c
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartMulti]
end function

rule MoveToStartMulti
    replace [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        ...
    by
        ..
        'int x '= e1';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        ...
end rule