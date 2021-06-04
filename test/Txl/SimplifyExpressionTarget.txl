% SimplifyExpressionTarget.txl: Example of a TXL rule to match an embedded sequence of declarations and statements. The output of SimplifyExpression.txl should yield this result
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
        'var x [id] ':= e1 [expn]
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        'if x '> e2 [expn] 'then 
            x ':= e2 
        'end 'if
        Tails [repeat declaration_or_statement]
    by
        'var x ':= 'min(0 ', 'max( e1 ', e2 '))
        Tails
end rule
