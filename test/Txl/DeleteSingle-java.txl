% DeleteSingle-java.txl: Delete a single Java statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/java.grm"

function main
    replace [program]
        P [program]
    by
        P [DeleteSingle]
end function

rule DeleteSingle
    replace [repeat declaration_or_statement]
        ...
        'int x [id] '= e1 [expression]';
        ...
    by
        ...
end rule
