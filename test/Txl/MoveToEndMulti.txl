% MoveToEndMulti.txl: Move statements to the end of a sequence
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToEndMulti]
end function

rule MoveToEndMulti
    replace [repeat declaration_or_statement]
        ...
        'var x [id] ':= e1 [expn]
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
        ...
    by
        ...
        'var x ':= e1
        'if x '< 0 'then 
            x ':= 0 
        'end 'if
end rule