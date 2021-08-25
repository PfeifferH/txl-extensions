% tempDots.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, August 2021

include "../grammars/extensions.grm"

% Run the resolveOuterRule and resolveOuterFunction rules on input
function main
    replace [program]
        P [program]
    by
        P [resolveOuter]
end function

% Matches rules in input 
rule resolveOuter
    replace [repeat statement]
        ruleType [rule_function] RuleName [ruleid]
            'replace optStar [opt dollarStar] '[ 'repeat RuleType [typeid]']
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end ruleType
    deconstruct RulePattern
        PrePattern [repeat literalOrVariable]
        '...
        Pattern [repeat literalOrVariable]
        '...
        PostPattern [repeat literalOrVariable]
    deconstruct RuleReplacement
        PreReplacement [repeat literalOrExpression]
        _ [opt dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [opt dotDotDot]
        PostReplacement [repeat literalOrExpression]
    construct PatternScope [repeat literalOrVariable]
        '_Scope '[ 'repeat RuleType ']
    construct PatternWithoutTypes [pattern]
        RulePattern [removeTypes]
    deconstruct PatternWithoutTypes
        _ [repeat literalOrVariable]
        '...
        InnerPattern [repeat literalOrVariable]
        '...
        _ [repeat literalOrVariable]
    construct newPattern [replacement]
        _ [constructPattern each InnerPattern]
    construct ConstructorsAndDeconstructors [repeat constructDeconstructImportExportOrCondition]
        'skipping '[ RuleType']
        'deconstruct '* '_Scope 
            RulePattern [deconstructScope RuleReplacement RuleType]
        'skipping '[ RuleType']
        'deconstruct '* '_Tail
            RulePattern [deconstructPostScope RuleReplacement RuleType]
        'construct '_Pattern '[ 'repeat RuleType']
            newPattern
        'construct '_Replacement '[ 'repeat RuleType ']
            Replacement
        'construct '_PostReplacement '[ 'repeat RuleType ']
            PostReplacement 
        'construct '_PatternAndTail '[ 'repeat RuleType']
            '_Pattern '[ '. '_Tail ']
        'construct '_Head '[ 'repeat RuleType']
            '_Scope '[ 'deleteTail '_PatternAndTail ']
    construct OptDeconstructHeadOrTail [repeat constructDeconstructImportExportOrCondition]
        _ [deconstructTail RuleReplacement] [deconstructHead RuleReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [NoMoveEmbedded RuleReplacement] [MoveToEnd RuleReplacement] [deleteHeadAndTail RuleReplacement]
    construct newPostReplacement [repeat literalOrExpression]
        '[ '. '_PostReplacement ']
    by
        ruleType RuleName 
            'replace optStar '[ 'repeat RuleType']
                PrePattern [. PatternScope]
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PreReplacement [. PatternOrder] [. newPostReplacement]
        'end ruleType

        'function 'deleteTail '_Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                '_Tail
            'by
        'end 'function  
end rule

rule deconstructPostScope RuleReplacement [replacement] RuleType [typeid]
    replace [pattern]
        _ [repeat literalOrVariable]
        '...
        _ [repeat literalOrVariable]
        '...
        PostPattern [repeat literalOrVariable]
    by 
        PostPattern
end rule

% Helper functions shared by resolve* rules


% Remove dotDotDots from pattern and add tail
rule deconstructScope RuleReplacement [replacement] RuleType [typeid]
    construct Tail [literalOrVariable]
        '_Tail '[ 'repeat RuleType ']
    replace [pattern]
        _ [repeat literalOrVariable]
        '...
        Pattern [repeat literalOrVariable]
        '...
        _ [repeat literalOrVariable]
    by
        Pattern [. Tail]
end rule

% Case when input is a literal
function constructNewLit InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleLit [literal]
    replace * [repeat literalOrExpression]
    by
        singleLit
end function

% Case when input is a variable
function constructNewVar InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleVar [varid]
    replace * [repeat literalOrExpression]
    by
        singleVar
end function

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

% Case when rule moves pattern to the start of a repeat with dotDotDots
function MoveToStart RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        '_Replacement '[ '. '_Head '] '[ '. '_Tail ']
end function

% Case when pattern embedded in dotDotDots deleted
function NoMove RuleReplacement [replacement]
    deconstruct RuleReplacement 
        '...
    replace [repeat literalOrExpression]
    by
        '_Head '[ '. '_Tail ']
end function

% Case when pattern embedded in dotDotDots is not moved
function NoMoveEmbedded RuleReplacement [replacement]
    deconstruct RuleReplacement 
        _ [repeat literalOrExpression]
        '...
        _ [repeat literalOrExpression]
        '...
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        '_Head '[ '. '_Replacement '] '[ '. '_Tail ']
end function

% Case when rule moves pattern to the end of a repeat with dotDotDots
function MoveToEnd RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        '_Head '[ '. '_Tail '] '[ '. '_Replacement ']
end function

% Case when Head and Tail statements are removed
function deleteHeadAndTail RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression]
    replace [repeat literalOrExpression]
    by
        '_Replacement
end function

% Add a deconstruct not Tail statement when moving replacement to the end of the block
function deconstructTail RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression+]
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not '_Tail
end function

% Add a deconstruct not Tail statement when moving replacement to the start of the block
function deconstructHead RuleReplacement [replacement]
    deconstruct RuleReplacement
        _ [repeat literalOrExpression+]
        '... 
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not '_Head
end function

% No "deconstruct not" statements necessary if not moving the replacement to a different position in block
function noDeconstruct
    replace [repeat constructDeconstructImportExportOrCondition]
    by
end function