% SimplifyExpression.txl: Example of a TXL rule to transform to match embedded sequences. After transformation, output should yield SimplifyExpressionTarget.txl
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
        ...
end rule