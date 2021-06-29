% MoveToEndMulti-java.txl: Move statements to the end of a sequence
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToEndMulti]
end function

rule MoveToEndMulti
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        ...
    by
        ...
        'int x '= e1';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
end rule