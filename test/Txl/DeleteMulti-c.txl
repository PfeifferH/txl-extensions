% DeleteMulti-c.txl: Delete multiple c statements that match a declaration followed by two if conditions
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteMulti]
end function

rule DeleteMulti
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
end rule
