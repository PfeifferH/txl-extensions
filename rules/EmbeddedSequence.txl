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
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    construct optDeconstruct [repeat constructDeconstructImportExportOrCondition]
        _ [deconstructPattern Pattern RuleReplacement RuleType] [noDeconstruct]

    construct Tail [repeat literalOrExpression]
        'Tail
    by
        'rule RuleName 
            'replace '[ 'repeat RuleType']
                RulePattern [constructPattern RuleReplacement RuleType] [constructPatternWithHead RuleReplacement RuleType] 
            optDeconstruct
            'by
                RuleReplacement [constructReplacement] [constructReplacementWithHead] [constructReplacementMoveToEnd]
        'end 'rule  
end rule

rule constructPattern RuleReplacement [replacement] RuleType [typeid]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
        _ [opt dotDotDot]
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType ']
    replace [pattern]
        '...
        Pattern [repeat literalOrVariable]
        '...
    by
        Pattern [. Tail]
end rule

rule constructPatternWithHead RuleReplacement [replacement] RuleType [typeid]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
        '...
    construct Head [repeat literalOrVariable]
        'Head '[ RuleType ']
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType ']        
    replace [pattern]
        '...
        Pattern [repeat literalOrVariable]
        '...
    by
        Head [. Pattern] [. Tail]
end rule

rule constructPatternWithStmts RuleReplacement [replacement] RuleType [typeid]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression+]
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType '+']
    construct Stmts [repeat literalOrVariable]
        'Stmts '[ RuleType ']
    replace [pattern]
        '...
        Pattern [repeat literalOrVariable]
        '...
    by
        Stmts [. Tail]
end rule

rule constructReplacement
    construct Tail [repeat literalOrExpression]
        'Tail
    replace [replacement]
        '...
        Replacement [repeat literalOrExpression]
        '...
    by
        Replacement [. Tail]
end rule

rule constructReplacementWithHead
    construct Head [repeat literalOrExpression]
        'Head
    construct Tail [repeat literalOrExpression]
        'Tail
    replace [replacement]
        Replacement [repeat literalOrExpression]
        '...
    by
        Replacement [. Head] [. Tail]
end rule

rule constructReplacementMoveToEnd
    construct Tail [repeat literalOrExpression]
        'Tail '['. 'Pattern ']
    replace [replacement]
        '...
        Replacement [repeat literalOrExpression]
    by
        Tail
end rule

function deconstructPattern Pattern [repeat literalOrVariable] RuleReplacement [replacement] RuleType [typeid]
    deconstruct RuleReplacement
        '...
        Replacement [repeat literalOrExpression]
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not 'Tail
        'construct 'Pattern '[ 'repeat RuleType ']
            Replacement
end function

function noDeconstruct
    replace [repeat constructDeconstructImportExportOrCondition]
    by 
end function