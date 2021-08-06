% Outer.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021


% Run the resolveOuterRule and resolveOuterFunction rules on input
function main3
    replace [program]
        P [program]
    by
        P [resolveOuterRule] [resolveOuterFunction]
end function

% Matches rules in input 
rule resolveOuterRule
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
    deconstruct RuleReplacement
        PreReplacement [repeat literalOrExpression]
        InnerReplacement [replacement]
        PostReplacement [repeat literalOrExpression]
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement] [constructReplacementDelete InnerReplacement]  [constructReplacementDefault RuleReplacement]
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
            '_Scope '[ 'deleteTail 'PatternAndTail ']
    construct OptDeconstructHeadOrTail [repeat constructDeconstructImportExportOrCondition]
        _ [deconstructTail InnerReplacement] [deconstructHead InnerReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart InnerReplacement] [NoMove InnerReplacement] [NoMoveEmbedded InnerReplacement] [MoveToEnd InnerReplacement] [deleteHeadAndTail InnerReplacement]
    construct newPostReplacement [repeat literalOrExpression]
        '[ '. '_PostReplacement ']
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                PrePattern [. PatternScope]
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PreReplacement [. PatternOrder] [. newPostReplacement]
        'end 'rule

        'function 'deleteTail '_Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                '_Tail
            'by
        'end 'function  
end rule

% Matches functions in input
rule resolveOuterFunction
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
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement] [constructReplacementDelete InnerReplacement] [deleteHeadAndTail InnerReplacement]  [constructReplacementDefault RuleReplacement]
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
        'construct '_PatternAndTail '[ 'repeat RuleType']
            '_Pattern '[ '. '_Tail ']
        'construct '_Head '[ 'repeat RuleType']
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
