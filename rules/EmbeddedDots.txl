% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "AnchoredDots.txl"

function EmbeddedDots
    replace [program]
        P [program]
    by
        P [resolveAnchoredRule] [resolveAnchoredFunction]
end function

rule resolveEmbed
    replace [ruleStatement]
        'rule RuleName [ruleid]
            'replace optStar [opt dollarStar] '[ 'repeat RuleType [typeid]']
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end 'rule
    deconstruct RulePattern
        '...
        Pattern [repeat literalOrVariable]
        '...
    deconstruct RuleReplacement
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    construct optDeconstruct [repeat constructDeconstructImportExportOrCondition]
        _ [constructStmts Pattern RuleReplacement RuleType] [noDeconstruct]

    construct Tail [repeat literalOrExpression]
        'Tail
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                RulePattern [constructPattern RuleReplacement RuleType] [constructPatternWithHead RuleReplacement RuleType] 
            optDeconstruct
            'by
                RuleReplacement [constructReplacement] [constructReplacementWithHead] [constructReplacementMoveToEnd]
        'end 'rule  
end rule