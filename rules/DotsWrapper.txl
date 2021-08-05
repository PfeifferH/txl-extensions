% DotsWrapper.txl: Wrapper for the Anchored, Embedded, and Outer Dots cases to utilize the "..." notation of txl
% Hayden Pfeiffer
% Queen's University, June 2021

include "../grammars/extensions.grm"

include "AnchoredDots.txl"
include "EmbeddedDots.txl"
include "OuterDots.txl"

% Run the resolveOuterRule and resolveOuterFunction rules on input
function main
    replace [program]
        P [program]
    by
        P [resolveAnchoredRule] [resolveAnchoredFunction] [resolveEmbeddedRule] [resolveEmbeddedFunction] [resolveOuterRule] [resolveOuterFunction]
end function


% Helper functions shared by resolve* rules

function constructReplacementStart InnerReplacement [replacement]
    deconstruct InnerReplacement
        _ [anchorDotDot]
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
        _ [anchorDotDot]
    replace * [repeat literalOrExpression]
    by
        Replacement
end function

function constructReplacementDelete InnerReplacement [replacement]
    deconstruct InnerReplacement
        _ [dotDotDot]
    replace * [repeat literalOrExpression]
    by
end function

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
        '..
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
        '...
        _ [repeat literalOrExpression]
        '...
    replace [repeat literalOrExpression]
    by
        '_Head '[ '. '_Replacement '] '[ '. '_Tail ']
end function

% Case when rule moves pattern to the end of a repeat with dotDotDots
function MoveToEnd RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression]
        '..
    replace [repeat literalOrExpression]
    by
        '_Head '[ '. '_Tail '] '[ '. '_Replacement ']
end function

% Add a deconstruct not Tail statement when moving replacement to the end of the block
function deconstructTail RuleReplacement [replacement]
    deconstruct RuleReplacement
        '...
        _ [repeat literalOrExpression+]
        '..
    replace [repeat constructDeconstructImportExportOrCondition]
    by
        'deconstruct 'not '_Tail
end function

% Add a deconstruct not Tail statement when moving replacement to the start of the block
function deconstructHead RuleReplacement [replacement]
    deconstruct RuleReplacement
        '..
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