% AddMulti-java.txl: Add multiple statements onto a single statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [AddMulti]
end function

function AddMulti
    replace * [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        ...
    by
        ...
        'int x '= e1';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        'if '( x '> 10') '{
            x '= x '* 2';
        '}
        ...
end function