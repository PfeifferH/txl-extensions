% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

function main
    replace [program]
        P [program]
    by
        P [resolveEmbedRule] [resolveEmbedFunction]
end function

% Matches rules in input 
rule resolveEmbedRule
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

% Matches functions in input
rule resolveEmbedFunction
    replace [functionStatement]
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
    by
        'function RuleName 
            'replace optStar '[ 'repeat RuleType']
                RulePattern [constructPattern RuleReplacement RuleType] [constructPatternWithHead RuleReplacement RuleType] 
            optConstruct
            'by
                RuleReplacement [constructReplacement] [constructReplacementWithHead] 
        'end 'function  
end rule

% Default Pattern construction
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