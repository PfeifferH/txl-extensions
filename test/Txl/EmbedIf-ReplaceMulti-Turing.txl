% EmbedIf-Turing.txl: Resolve embedded statements within an if statement
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [EmbedIf]
end function

rule EmbedIf
    replace [repeat declaration_or_statement]
        'if x [id] '= 1 'then
            ...
            'var 'y ':= e1 [expn]
            ...
        'end 'if
        OuterTail [repeat declaration_or_statement]
    by
        'if x '= 1 'then
            ...
            x ':= e1
            'for 'counter ': 1 '.. 15
                'put 'counter
            'end 'for 
            ...
        'end 'if
        OuterTail
end rule