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
    construct Tail [repeat literalOrExpression]
        'Tail
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [MoveToEnd RuleReplacement]
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                'Scope '[ 'repeat RuleType ']
            'skipping '[ RuleType']
            'deconstruct '* 'Scope 
                RulePattern [constructPattern RuleReplacement RuleType]
            'deconstruct 'not 'Tail
            'construct 'Pattern '[ 'repeat RuleType']
                RuleReplacement [constructReplacementNoTail] 
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
            'deconstruct 'not 'Head
            'by
                PatternOrder
        'end 'rule

        'function 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'function  
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
    construct Tail [repeat literalOrExpression]
        'Tail
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [MoveToEnd RuleReplacement]
    by
        'function RuleName 
            'replace optStar '[ 'repeat RuleType']
                'Scope '[ 'repeat RuleType ']
            'skipping '[ RuleType']
            'deconstruct '* 'Scope 
                RulePattern [constructPattern RuleReplacement RuleType]
            'deconstruct 'not 'Tail
            'construct 'Pattern '[ 'repeat RuleType']
                RuleReplacement [constructReplacementNoTail] 
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
            'deconstruct 'not 'Head
            'by
                PatternOrder
        'end 'function

        'function 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'function
end rule

% Default Pattern construction
rule constructPattern RuleReplacement [replacement] RuleType [typeid]
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType ']
    replace [pattern]
        '...
        Pattern [repeat literalOrVariable]
        '...
    by
        Pattern [. Tail]
end rule

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
        'Pattern '[ '. 'Head '] '[ '. 'Tail ']
end function

function NoMove RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
        _ [repeat literalOrExpression]
        _ [opt dotDotDot]
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Pattern '] '[ '. 'Tail ']
end function

function MoveToEnd RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail '] '[ '. 'Pattern ']
end function