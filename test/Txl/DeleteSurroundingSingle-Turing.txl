% DeleteSurroundingSingle-Turing.txl: Add multiple statements onto a single statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteSurroundingSingle]
end function

function DeleteSurroundingSingle
    replace * [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        ...
    by
        'var x ':= e1
end function