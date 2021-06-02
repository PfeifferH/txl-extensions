% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../txl.grm"

function main
    replace [program]
        P [program]
    by
        P
end function