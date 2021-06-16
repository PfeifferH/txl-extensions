% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

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
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end 'rule
    deconstruct RulePattern
        '...
        Pattern [repeat literalOrVariable]
        '...
    deconstruct RuleReplacement
        HeadDotDotDot [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        '...
    construct TempHeadPatternVar [repeat literalOrVariable]
        'Head '[ 'repeat RuleType ']
    construct TempPatternVar [repeat literalOrVariable]
        'Temp '[ 'repeat RuleType ']
    construct TempReplacementVar [repeat literalOrExpression]
        'Temp
    by
        'rule RuleName 
            'replace '[ 'repeat RuleType']
                Pattern [. TempPatternVar] 
            'by
                Replacement [. TempReplacementVar]  
        'end 'rule  
end rule

function verifyDots RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [opt dotDotDot]
        _ [repeat literalOrExpression]
        '...
    match * [dotDotDot]
        '...
end function

function verifyNoDots RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
    match * [pattern]
        _ [pattern]
end function