% SimplifyExpression.txl: Notation for TXL to explicity define if a sequence of statements can be embedded
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/Turing.Grm"

rule simplifyExp
    replace [repeat declaration_or_statement]
        x [id] := e1 [expn]
        if x < 0 then x := 0 end if
        if x > e2 [expn] then x := e2 end if
    by
        x := max (0, min (e1, e2))
end rule
