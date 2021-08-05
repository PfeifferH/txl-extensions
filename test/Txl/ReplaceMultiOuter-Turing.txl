% DeleteMulti-Turing.txl: Delete multiple Turing statements
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceMultiOuter]
end function

rule ReplaceMultiOuter
    replace [repeat declaration_or_statement]
        'var x [id] ':= e1 [expn]
        ...
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        ...
        'if x '> e2 [expn] 'then 
            x ':= e2 
        'end 'if
        OuterTail [repeat declaration_or_statement]
    by
        'var x ':= 1
        ...
        'if x '> e2 'then 
            x ':= e2 
        'end 'if
        ...
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        OuterTail
end rule
