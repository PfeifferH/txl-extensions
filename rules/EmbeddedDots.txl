% EmbeddedSequence.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

% Run the resolveAnchoredRule and resolveAnchoredFunction rules on input
function main
    replace [program]
        P [program]
    by
        P [resolveEmbeddedRule] [resolveEmbeddedFunction]
end function

% Matches rules in input 
rule resolveEmbeddedRule
    replace [repeat statement]
        'rule RuleName [ruleid]
            'replace optStar [opt dollarStar] '[ 'repeat RuleType [typeid]']
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end 'rule
    deconstruct RulePattern
        PrePattern [repeat literalOrVariable]
        '...
        Pattern [repeat literalOrVariable]
        '...
        PostPattern [repeat literalOrVariable]
    construct _ [id]
        _ [message "fired1"]
    deconstruct RuleReplacement
        PreReplacement [repeat literalOrExpression]
        InnerReplacement [replacement]
        PostReplacement [repeat literalOrExpression]
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement]
    construct PatternScope [repeat literalOrVariable]
        'Scope '[ 'repeat RuleType ']
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
            'deconstruct '* 'Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            
            'construct 'Pattern '[ 'repeat RuleType']
                newPattern
            'construct 'Replacement '[ 'repeat RuleType ']
                Replacement
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
    construct OptDeconstructHeadOrTail [repeat constructDeconstructImportExportOrCondition]
        _ [deconstructTail InnerReplacement] [deconstructHead InnerReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart InnerReplacement] [NoMove InnerReplacement] [NoMoveEmbedded InnerReplacement] [MoveToEnd InnerReplacement]
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                PrePattern [. PatternScope] [. PostPattern]
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PreReplacement [. PatternOrder] [. PostReplacement]
        'end 'rule

        'function 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'function  
end rule

% Matches functions in input
rule resolveEmbeddedFunction
    replace [repeat statement]
        'function RuleName [ruleid]
            'replace optStar [opt dollarStar] '[ 'repeat RuleType [typeid]']
                RulePattern [pattern]
            'by
                RuleReplacement [replacement]    
        'end 'function
    deconstruct RulePattern
        PrePattern [repeat literalOrVariable]
        '...
        Pattern [repeat literalOrVariable]
        '...
        PostPattern [repeat literalOrVariable]
    deconstruct RuleReplacement
        PreReplacement [repeat literalOrExpression]
        InnerReplacement [replacement]
        PostReplacement [repeat literalOrExpression]
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement]
    construct PatternScope [repeat literalOrVariable]
        'Scope '[ 'repeat RuleType ']
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
            'deconstruct '* 'Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            
            'construct 'Pattern '[ 'repeat RuleType']
                newPattern
            'construct 'Replacement '[ 'repeat RuleType ']
                Replacement
            'construct 'PatternAndTail '[ 'repeat RuleType']
                'Pattern '[ '. 'Tail ']
            'construct 'Head '[ 'repeat RuleType']
                'Scope '[ 'deleteTail 'PatternAndTail ']
    construct OptDeconstructHeadOrTail [repeat constructDeconstructImportExportOrCondition]
        _ [deconstructTail InnerReplacement] [deconstructHead InnerReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart InnerReplacement] [NoMove InnerReplacement] [NoMoveEmbedded InnerReplacement] [MoveToEnd InnerReplacement]
    by
        'function RuleName 
            'replace optStar '[ 'repeat RuleType']
                PrePattern [. PatternScope] [. PostPattern]
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PreReplacement [. PatternOrder] [. PostReplacement]
        'end 'function

        'function 'deleteTail 'Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                'Tail
            'by
        'end 'function  
end rule

% Compare PostReplacement and PostPattern to ensure that the replacement is parsed correctly
rule CompareLiterals PostPattern [repeat literalOrVariable]
    deconstruct PostPattern
        PostPatternHead [literalOrVariable]
        PostPatternTail [repeat literalOrVariable]
    deconstruct PostPatternHead
        Headlit [literal]
    construct _ [id]
        _ [message "firedLit"]
    construct newLit [literalOrVariable]
        PostPatternHead [debug]
    
    match * [literal]
        HeadLit
end rule

function constructReplacementStart InnerReplacement [replacement]
    deconstruct InnerReplacement
        _ [startDotDotDot]
        Replacement [repeat literalOrExpression]
        _ [dotDotDot]
    replace * [repeat literalOrExpression]
    by
        Replacement
end function

function constructReplacement InnerReplacement [replacement]
    deconstruct InnerReplacement
        _ [dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [dotDotDot]
    replace * [repeat literalOrExpression]
    by
        Replacement
end function

function constructReplacementEnd InnerReplacement [replacement]
    deconstruct InnerReplacement
        _ [dotDotDot]
        Replacement [repeat literalOrExpression]
        _ [endDotDotDot]
    replace * [repeat literalOrExpression]
    by
        Replacement
end function

% Remove dotDotDots from pattern and add tail
rule deconstructScope RuleReplacement [replacement] RuleType [typeid]
    construct Tail [literalOrVariable]
        'Tail '[ 'repeat RuleType ']
    replace [pattern]
        _ [repeat literalOrVariable]
        '...
        Pattern [repeat literalOrVariable]
        '...
        _ [repeat literalOrVariable]
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

% Case when input is a variable
function constructNewVar InnerLit [literalOrVariable]
    deconstruct InnerLit
        singleVar [varid]
    replace * [repeat literalOrExpression]
    by
        singleVar
end function

% Case when rule moves pattern to the start of a repeat with dotDotDots
function MoveToStart RuleReplacement [replacement]
    deconstruct RuleReplacement
        '..s
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
        '..e
    replace [repeat literalOrExpression]
    by
        'Head '[ '. 'Tail '] '[ '. 'Replacement ']
end function

% Add a deconstruct not Tail statement when moving replacement to the end of the block
function deconstructTail RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression+]
        '..e
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not 'Tail
end function

% Add a deconstruct not Tail statement when moving replacement to the start of the block
function deconstructHead RuleReplacement [replacement]
    deconstruct RuleReplacement
        '..s
        _ [repeat literalOrExpression+]
        '... 
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not 'Head
end function

% No "deconstruct not" statements necessary if not moving the replacement to a different position in block
function noDeconstruct
    replace [repeat constructDeconstructImportExportOrCondition]
    by
end function