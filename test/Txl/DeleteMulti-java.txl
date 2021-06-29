% DeleteMulti-java.txl: Delete multiple Java statements
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteMulti]
end function

rule DeleteMulti
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        'if '( x '> e2 [additive_expression] ') '{ 
            x '= e2'; 
        '}
        ...
    by
        ...
end rule
