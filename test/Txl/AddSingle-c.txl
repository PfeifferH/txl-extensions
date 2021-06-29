% AddSingle-c.txl: Add a single statement to another
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/c.grm"

function main
    replace [program]
        P [program]
    by
        P [AddSingle]
end function

function AddSingle
    replace * [repeat block_item]
        ...
        'int x [id] '= e1 [assignment_expression]';
        ...
    by
        ...
        'int x '= e1';
        'if '( x '< 0') '{ 
            x '= 0'; 
        '}
        ...
end function
