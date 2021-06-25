% DeleteSingle.txl: Delete a single Turing statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteSingle]
end function

rule DeleteSingle
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        ...
    by
        ...
end rule
