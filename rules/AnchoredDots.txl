% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

function main
    replace [program]
        P [program]
    by
        P [resolveAnchoredRule] [resolveAnchoredFunction]
end function

% Matches rules in input 
rule resolveAnchoredRule
    replace [repeat statement]
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
    construct PatternWithoutTypes [pattern]
        RulePattern [constructPattern]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
    construct newPattern [replacement]
        _ [constructNewPattern each InnerPattern]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [NoMoveEmbedded RuleReplacement] [MoveToEnd RuleReplacement]
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                'Scope '[ 'repeat RuleType ']
            'skipping '[ RuleType']
            'deconstruct '* 'Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            'deconstruct 'not 'Tail
            'construct 'Pattern '[ 'repeat RuleType']
                newPattern
            'construct 'Replacement '[ 'repeat RuleType ']
                RuleReplacement [constructReplacementNoTail]
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
            'deconstruct 'not 'Head
            'by
                PatternOrder
        'end 'rule

        'rule 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'rule  
end rule

% Matches functions in input
rule resolveAnchoredFunction
    replace [repeat statement]
        'function RuleName [ruleid]
            'replace optStar [opt dollarStar] '[ 'repeat RuleType [typeid]']
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end 'function
    deconstruct RulePattern
        '...
        Pattern [repeat literalOrVariable]
        '...
    deconstruct RuleReplacement
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    construct PatternWithoutTypes [pattern]
        RulePattern [constructPattern]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
    construct newPattern [replacement]
        _ [constructNewPattern each InnerPattern]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [NoMoveEmbedded RuleReplacement] [MoveToEnd RuleReplacement]
    by
        'function RuleName 
            'replace optStar '[ 'repeat RuleType']
                'Scope '[ 'repeat RuleType ']
            'skipping '[ RuleType']
            'deconstruct '* 'Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            'deconstruct 'not 'Tail
            'construct 'Pattern '[ 'repeat RuleType']
                newPattern
            'construct 'Replacement '[ 'repeat RuleType ']
                RuleReplacement [constructReplacementNoTail]
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
            'deconstruct 'not 'Head
            'by
                PatternOrder
        'end 'function

        'rule 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'rule
end rule

% Default Pattern construction
rule deconstructScope RuleReplacement [replacement] RuleType [typeid]
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType ']
    replace [pattern]
        '...
        Pattern [repeat literalOrVariable]
        '...
    by
        Pattern [. Tail]
end rule

rule constructPattern 
    replace [literalOrVariable]
        Var [varid] _ [type] 
    by
        Var
end rule

function constructNewPattern InnerLit [literalOrVariable]
    construct newLit [repeat literalOrExpression]
        _ [constructNewLit InnerLit]
    construct newVar [repeat literalOrExpression]
        _ [constructNewVar InnerLit]
    replace * [repeat literalOrExpression]
    by
        newLit [. newVar]
end function

function constructNewLit InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleLit [literal]
    replace * [repeat literalOrExpression]
    by
        singleLit
end function

function constructNewVar InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleVar [varid]
    replace * [repeat literalOrExpression]
    by
        singleVar
end function

function constructReplacementNoTail
    replace [replacement]
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    by
        Replacement
end function

function MoveToStart RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        'Replacement '[ '. 'Head '] '[ '. 'Tail ']
end function

function NoMove RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail ']
end function

function NoMoveEmbedded RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Replacement '] '[ '. 'Tail ']
end function

function MoveToEnd RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail '] '[ '. 'Replacement ']
end function