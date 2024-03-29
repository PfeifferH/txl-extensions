% MoveToStartSingle-Turing.txl: Move a single statement from a list 
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartSingle]
end function

rule MoveToStartSingle
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        ...
    by
        'var x ':= e1
        ...
end rule