% AddMulti.txl: Add multiple statements onto a single statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [AddMulti]
end function

function AddMulti
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        ...
    by
        ...
        'var x ':= e1
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        'if x '> 10 'then
            x ':= x '* 2
        'end 'if
        ...
end function
