% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

% Run the resolveAnchoredRule and resolveAnchoredFunction rules on input
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
        RulePattern [removeTypes]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
    construct newPattern [replacement]
        _ [constructPattern each InnerPattern]
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
                RuleReplacement [constructReplacement]
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
    construct PatternWithoutTypes [pattern]
        RulePattern [removeTypes]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
    construct newPattern [replacement]
        _ [constructPattern each InnerPattern]
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
                RuleReplacement [constructReplacement]
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

% Remove dotDotDots from pattern and add tail
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

% Remove all instances of a type (ex: 'var x [id] -> var x)
rule removeTypes
    replace [literalOrVariable]
        Var [varid] _ [type] 
    by
        Var
end rule

% Extract literal or variable from input. Since the literalOrVariable can only be one of these, the output literalOrExpression is of size 1 
function constructPattern InnerLit [literalOrVariable]
    construct newLit [repeat literalOrExpression]
        _ [constructNewLit InnerLit]
    construct newVar [repeat literalOrExpression]
        _ [constructNewVar InnerLit]
    replace * [repeat literalOrExpression]
    by
        newLit [. newVar]
end function

% Case when input is a literal
function constructNewLit InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleLit [literal]
    replace * [repeat literalOrExpression]
    by
        singleLit
end function

% Case when in is a variable
function constructNewVar InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleVar [varid]
    replace * [repeat literalOrExpression]
    by
        singleVar
end function

% Extract replacement from dotDotDots
function constructReplacement
    replace [replacement]
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
    by
        Replacement
end function

% Case when rule moves pattern to the start of a repeat with dotDotDots
function MoveToStart RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        'Replacement '[ '. 'Head '] '[ '. 'Tail ']
end function

% Case when pattern embedded in dotDotDots deleted
function NoMove RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail ']
end function

% Case when pattern embedded in dotDotDots is not moved
function NoMoveEmbedded RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Replacement '] '[ '. 'Tail ']
end function

% Case when rule moves pattern to the end of a repeat with dotDotDots
function MoveToEnd RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail '] '[ '. 'Replacement ']
end function