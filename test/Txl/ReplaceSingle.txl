% ReplaceSingle.txl: Replace a variable declaration with its inverse
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [ReplaceSingle]
end function

rule ReplaceSingle
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [primary] '+ e2 [expn]
        ...
    by
        ...
        'var x ':= 2
        ...
end rule
