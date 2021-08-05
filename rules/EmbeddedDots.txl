% EmbeddedDots.txl: Recognizes "..." notation in a TXL program to match embedded sequences
% Hayden Pfeiffer
% Queen's University, June 2021

% Run the resolveEmbeddedRule and resolveAnchoredFunction rules on input
function main2
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
    deconstruct RuleReplacement
        PreReplacement [repeat literalOrExpression]
        InnerReplacement [replacement]
        PostReplacement [repeat literalOrExpression]
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement] [constructReplacementDelete InnerReplacement]
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
            'deconstruct '* '_Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            
            'construct '_Pattern '[ 'repeat RuleType']
                newPattern
            'construct '_Replacement '[ 'repeat RuleType ']
                Replacement
            'construct '_PatternAndTail '[ 'repeat RuleType']
                '_Pattern '[ '. 'Tail ']
            'construct '_Head '[ 'repeat RuleType']
                '_Scope '[ 'deleteTail '_PatternAndTail ']
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

        'function 'deleteTail '_Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                '_Tail
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
        _ [constructReplacementStart InnerReplacement] [constructReplacement InnerReplacement] [constructReplacementEnd InnerReplacement] [constructReplacementDelete InnerReplacement]
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
            'deconstruct '* '_Scope 
                RulePattern [deconstructScope RuleReplacement RuleType]
            
            'construct '_Pattern '[ 'repeat RuleType']
                newPattern
            'construct '_Replacement '[ 'repeat RuleType ']
                Replacement
            'construct '_PatternAndTail '[ 'repeat RuleType']
                '_Pattern '[ '. '_Tail ']
            'construct '_Head '[ 'repeat RuleType']
                '_Scope '[ 'deleteTail '_PatternAndTail ']
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