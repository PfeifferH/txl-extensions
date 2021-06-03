% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/txl.grm"

function main
    replace [program]
        P [program]
    construct newP [program]
        P [resolveEmbed]
    by
        newP 
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
    construct newRule [ruleStatement]
        'rule RuleName 
            'replace '[ 'repeat RuleType']
                RulePattern 
                'Temp '[ 'repeat RuleType']
            'by
                ruleReplacement 
                'Temp  
        'end 'rule     
    by
        newRule [debug] 
end rule