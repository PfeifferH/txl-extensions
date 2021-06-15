% AddSingle.txl: Add a single statement to another
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [simplifyExp]
end function

rule simplifyExp
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
        ...
end rule
