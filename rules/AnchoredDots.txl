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
    construct optDeconstruct [repeat constructDeconstructImportExportOrCondition]
        _ [constructStmts Pattern RuleReplacement RuleType] [noDeconstruct]

    construct Tail [repeat literalOrExpression]
        'Tail
    construct Order [repeat literalOrExpression]
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
                Order
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
    construct optConstruct [repeat constructDeconstructImportExportOrCondition]
        _ [constructStmts Pattern RuleReplacement RuleType] [noDeconstruct]

    construct Tail [repeat literalOrExpression]
        'Tail
    construct Order [repeat literalOrExpression]
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
                Order
        'end 'rule

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

% For cases where we move a block to the start, we need to construct the pattern with a head of the input type. This is a singular, non-repeated item, so the block is bubble sorted to the top
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

% Default replacement construction
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

% Replacement construction with head for move to start case
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

function constructReplacementNoTail
    replace [replacement]
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    by
        Replacement
end function

% Deconstruct and construct statements for the new rule/function. Deconstruct not tail to verify that we have a tail, and construct a new pattern from the replacement
function constructStmts Pattern [repeat literalOrVariable] RuleReplacement [replacement] RuleType [typeid]
    deconstruct RuleReplacement
        '...
        Replacement [repeat literalOrExpression]
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not 'Tail
        'construct 'Pattern '[ 'repeat RuleType ']
            Replacement
end function

% For cases when we don't need do make new construct/deconstruct statements
function noDeconstruct
    replace [repeat constructDeconstructImportExportOrCondition]
    by 
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
        '...
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