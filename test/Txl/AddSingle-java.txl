% AddSingle-java.txl: Add a single statement to another
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [AddSingle]
end function

function AddSingle
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
        ...
end function