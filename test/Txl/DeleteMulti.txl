% DeleteMulti.txl: Delete multiple Turing statements
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteMulti]
end function

rule DeleteMulti
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
end rule
