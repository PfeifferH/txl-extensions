% MoveToStartMulti-java.txl: Move a multiples statements to the start of a sequence 
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartMulti]
end function

rule MoveToStartMulti
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
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