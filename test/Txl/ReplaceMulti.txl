% ReplaceMulti.txl: Replace multiple statements with single statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceMulti]
end function

rule ReplaceMulti
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        'if x '> e2 [expn] 'then 
            x ':= e2 
        'end 'if
        ...
    by
        ...
        'var x ':= 'min(0 ', 'max( e1 ', e2 '))
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        ...
end rule
