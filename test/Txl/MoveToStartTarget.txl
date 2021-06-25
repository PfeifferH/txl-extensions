% MoveToStartTargetressionTarget.txl: Example of a TXL rule to match an embedded sequence of declarations and statements. The output of MoveToStartTargetression.txl should yield this result
% Hayden Pfeiffer
% Queen's University, June 2021

include "../../grammars/Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [MoveToStartTarget]
end function

rule MoveToStartTarget
    replace [repeat declaration_or_statement]
        Head [declaration_or_statement]
        IfStmt [if_statement]
        Tail [repeat declaration_or_statement]
    by
        IfStmt
        Tail
end rule
