% MoveToEndSingle.txl: Move a statement to the end of a sequence
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToEndSingle]
end function

rule MoveToEndSingle
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        ...
    by
        ...
        'var x ':= e1
end rule