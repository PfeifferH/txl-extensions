% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/txl.grm"

function main
    replace [program]
        P [program]
    by
        P [resolveEmbed] 
end function

rule resolveEmbed
    replace [ruleStatement]
        'rule RuleName [ruleid]
            'replace '[ 'repeat RuleType [typeid]']
                '...
                RulePattern [repeat literalOrVariable]
                '...
            'by
                '...
                RuleReplacement [repeat literalOrExpression]
                '... 
        'end 'rule
    construct TempPatternVar [repeat literalOrVariable]
        'Temp '[ 'repeat RuleType']
    construct TempReplacementVar [repeat literalOrExpression]
        'Temp
    by
        'rule RuleName 
            'replace '[ 'repeat RuleType']
                RulePattern [. TempPatternVar] 
            'by
                RuleReplacement [. TempReplacementVar]  
        'end 'rule  
end rule