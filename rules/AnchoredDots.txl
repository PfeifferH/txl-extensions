% AnchoredDots.txl: Recognizes "..." notation in a TXL program to match anchored sequences
% Hayden Pfeiffer
% Queen's University, June 2021

% Run the resolveAnchoredRule and resolveAnchoredFunction rules on input
function main1
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
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart RuleReplacement] [constructReplacement RuleReplacement] [constructReplacementEnd RuleReplacement] [constructReplacementDelete RuleReplacement] [constructReplacementDefault RuleReplacement]
    
    construct PatternWithoutTypes [pattern]
        RulePattern [removeTypes]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
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
        _ [deconstructTail RuleReplacement] [deconstructHead RuleReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [NoMoveEmbedded RuleReplacement] [MoveToEnd RuleReplacement] [deleteHeadAndTail RuleReplacement]
    by
        'rule RuleName 
            'replace optStar '[ 'repeat RuleType']
                '_Scope '[ 'repeat RuleType ']
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PatternOrder
        'end 'rule

        'function 'deleteTail '_Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                '_Tail
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
    construct Replacement [repeat literalOrExpression]
        _ [constructReplacementStart RuleReplacement] [constructReplacement RuleReplacement] [constructReplacementEnd RuleReplacement] [constructReplacementDelete RuleReplacement] [constructReplacementDefault RuleReplacement]
    construct PatternWithoutTypes [pattern]
        RulePattern [removeTypes]
    deconstruct PatternWithoutTypes
        '...
        InnerPattern [repeat literalOrVariable]
        '...
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
        _ [deconstructTail RuleReplacement] [deconstructHead RuleReplacement] [noDeconstruct]
    construct PatternOrder [repeat literalOrExpression]
        _ [MoveToStart RuleReplacement] [NoMove RuleReplacement] [NoMoveEmbedded RuleReplacement] [MoveToEnd RuleReplacement] [deleteHeadAndTail RuleReplacement]
    by
        'function RuleName 
            'replace optStar '[ 'repeat RuleType']
                '_Scope '[ 'repeat RuleType ']
            ConstructorsAndDeconstructors [ . OptDeconstructHeadOrTail ]
            'by
                PatternOrder
        'end 'function

        'function 'deleteTail '_Tail '[ 'repeat RuleType']
            'skipping '[ RuleType']
            'replace '* '[ 'repeat RuleType ']
                '_Tail
            'by
        'end 'function  
end rule
